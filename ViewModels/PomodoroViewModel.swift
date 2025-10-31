import SwiftUI
import UserNotifications

final class PomodoroViewModel: ObservableObject {
    @Published var state: PomodoroState = .stopped
    @Published var currentCycleType: CycleType = .focus
    @Published var timeRemaining: TimeInterval = 0
    @Published var cyclesCompleted: Int = 0
    
    @AppStorage("focusDuration") var focusDuration: TimeInterval = AppSettings.defaultFocusDuration
    @AppStorage("shortBreakDuration") var shortBreakDuration: TimeInterval = AppSettings.defaultShortBreakDuration
    @AppStorage("longBreakDuration") var longBreakDuration: TimeInterval = AppSettings.defaultLongBreakDuration
    @AppStorage("cyclesBeforeLongBreak") var cyclesBeforeLongBreak: Int = AppSettings.defaultCyclesBeforeLongBreak
    
    private var timer: Timer?
    private var startTime: Date?
    private var backgroundTime: Date?
    
    init() {
        self.timeRemaining = focusDuration
    }
    
    func setupSystemFeatures() {
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted { print("Permissão de notificação concedida.") }
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
    
    @objc private func updateTime() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            timer = nil
            moveToNextCycle()
        }
    }

    private func moveToNextCycle() {
        switch currentCycleType {
        case .focus:
            cyclesCompleted += 1
            if cyclesCompleted % cyclesBeforeLongBreak == 0 {
                currentCycleType = .longBreak
            } else {
                currentCycleType = .shortBreak
            }
            
        case .shortBreak:
            currentCycleType = .focus
            
        case .longBreak:
            currentCycleType = .focus
        }
        
        setInitialTime()
        state = .stopped
        
        // TODO: Disparar Notificação de Fim de Ciclo
        /// Aqui seria o local para disparar um som ou uma notificação local.
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

    func endCycle() {
        timer?.invalidate()
        
        // TODO: Acionar feedback sonoro ou vibração aqui.
        
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
        
        startTimer()
    }

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
    
    func scheduleBackgroundNotification() {
        guard state == .running else { return }
        
        let finishDate = Date().addingTimeInterval(timeRemaining)
        let timeInterval = finishDate.timeIntervalSinceNow

        let content = UNMutableNotificationContent()
        content.title = "🎉 Ciclo Concluído!"
        
        switch currentCycleType {
        case .focus:
            content.body = "Hora da sua Pausa! Você completou \(cyclesCompleted + 1) foco(s)."
        case .shortBreak, .longBreak:
            content.body = "Hora de Voltar ao Foco! 🚀"
        }
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: "PomodoroEnd_\(UUID().uuidString)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            }
        }

        timer?.invalidate()
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}


