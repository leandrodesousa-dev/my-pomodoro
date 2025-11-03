import SwiftUI
import UserNotifications

final class PomodoroViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var state: PomodoroState = .stopped
    @Published var currentCycleType: CycleType = .focus
    @Published var timeRemaining: TimeInterval = 0
    @Published var cyclesCompleted: Int = 0
    
    // MARK: - AppStorage Properties
    @AppStorage("focusDuration") var focusDuration: TimeInterval = AppConstants.Duration.defaultFocusDuration
    @AppStorage("shortBreakDuration") var shortBreakDuration: TimeInterval = AppConstants.Duration.defaultShortBreakDuration
    @AppStorage("longBreakDuration") var longBreakDuration: TimeInterval = AppConstants.Duration.defaultLongBreakDuration
    @AppStorage("cyclesBeforeLongBreak") var cyclesBeforeLongBreak: Int = AppConstants.Duration.defaultCyclesBeforeLongBreak

    // MARK: - Properties
    private var timer: Timer?
    private var startTime: Date?
    private var backgroundTime: Date?
    
    // MARK: - Initializers
    init() {
        self.timeRemaining = focusDuration
    }
    
    // MARK: Actions Buttons
    func startTimer() {
        guard state != .running else { return }
        
        if state == .stopped {
            setInitialTime()
        }
        
        state = .running
        startTime = Date()
        timer?.invalidate()
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func pauseTimer() {
        guard state == .running else { return }
        state = .paused
        timer?.invalidate()
        cancelAllNotifications()
    }
    
    func stopTimer() {
        guard state != .stopped else { return }
        state = .stopped
        timer?.invalidate()
        timer = nil
        setInitialTime()
        cancelAllNotifications()
    }
    
    func resetTimer() {
        timer?.invalidate()
        cancelAllNotifications()
        
        state = .stopped
        currentCycleType = .focus
        cyclesCompleted = 0
        timeRemaining = focusDuration
        backgroundTime = nil
    }
    
    func skipBreak() {
        if currentCycleType != .focus {
            currentCycleType = .focus
            timeRemaining = focusDuration
            state = .stopped
        }
    }
    
    // MARK: - Time Methods
    @objc private func updateTime() {
        DispatchQueue.main.async {
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                if self.timeRemaining <= 0 {
                    self.timeRemaining = 0
                    self.endCycle()
                }
            } else {
                self.endCycle()
            }
        }
    }
    
    private func setInitialTime() {
        switch currentCycleType {
        case .focus:
            timeRemaining = focusDuration
        case .shortBreak:
            timeRemaining = shortBreakDuration
        case .longBreak:
            timeRemaining = longBreakDuration
        }
    }
    
    private func endCycle() {
        timer?.invalidate()
        
        vibrateForCycleEnd()
        
        switch currentCycleType {
        case .focus:
            cyclesCompleted += 1
            if cyclesCompleted % cyclesBeforeLongBreak == 0 {
                currentCycleType = .longBreak
                timeRemaining = longBreakDuration
            } else {
                currentCycleType = .shortBreak
                timeRemaining = shortBreakDuration
            }
        case .shortBreak, .longBreak:
            currentCycleType = .focus
            timeRemaining = focusDuration
        }
        
        setInitialTime()
        state = .stopped
    }
    
    private func vibrateForCycleEnd() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    // MARK: - Scene Phase Methods
    func handleAppBackground() {
        guard state == .running else { return }
        self.backgroundTime = Date()
        scheduleBackgroundNotification()
    }
    
    func handleAppActive() {
        cancelAllNotifications()
        reconcileTime()
    }
    
    private func reconcileTime() {
        guard let savedBackgroundTime = backgroundTime, state == .running else {
            self.backgroundTime = nil
            return
        }
        
        let timePassedInBackground = Date().timeIntervalSince(savedBackgroundTime)
        self.timeRemaining -= timePassedInBackground
        self.backgroundTime = nil
        
        if self.timeRemaining <= 0 {
            self.timeRemaining = 0
            endCycle()
        } else {
            startTimer()
        }
    }
    
    // MARK: - Public Methods Notification
    func setupSystemFeatures() {
        requestNotificationPermission()
    }
    
    func scheduleBackgroundNotification() {
        guard state == .running else { return }
        
        cancelAllNotifications()
        
        let finishDate = Date().addingTimeInterval(timeRemaining)
        let timeInterval = finishDate.timeIntervalSinceNow
        
        let requestNotification = setupNotificationRequest(timeInterval, "PomodoroEnd_\(UUID().uuidString)")
        setupUserNotificationCenter(requestNotification, for: timeInterval)
        timer?.invalidate()
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Private Methods Notification
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted { print("Permissão de notificação concedida.") }
        }
    }
    
    private func setupNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        switch currentCycleType {
        case .focus:
            content.title = "🎉 Ciclo Concluído!"
            content.body = "Hora da sua Pausa! Você completou \(cyclesCompleted + 1) foco(s)."
        case .shortBreak, .longBreak:
            content.title = "Fim da Pausa! 💪"
            content.body = "Hora de Voltar ao Foco! 🚀"
        }
        content.sound = UNNotificationSound.default
        
        return content
    }
    
    private func setupNotificationRequest(_ timeInterval: TimeInterval, _ identifier: String) -> UNNotificationRequest {
        let content = setupNotificationContent()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        return request
    }
    
    private func setupUserNotificationCenter(_ request: UNNotificationRequest, for duration: TimeInterval) {
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            } else {
                print("Notificação agendada para daqui a \(Int(duration)) segundos.")
            }
        }
    }
    
    // MARK: SatusPanel
    var statusText: String {
        let currentCycle = (cyclesCompleted % cyclesBeforeLongBreak) + 1
        return "Ciclos • \(currentCycle) de \(cyclesBeforeLongBreak)"
    }
    
    var nextBreakText: String {
        if cyclesCompleted % cyclesBeforeLongBreak == cyclesBeforeLongBreak - 1 {
            return "Próximo: Pausa Longa \(longBreakDuration.asTimerString)"
        } else {
            return "Próximo: Pausa Curta \(shortBreakDuration.asTimerString)"
        }
    }
}


