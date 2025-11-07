import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    
    // MARK: - Properties
    private let pomodoroViewModel: PomodoroViewModel
    
    @Published var isRunning: Bool
    @Published var focusDuration: TimeInterval
    @Published var shortBreakDuration: TimeInterval
    @Published var longBreakDuration: TimeInterval
    @Published var notificationsEnabled: Bool
    @Published var autoStartFocus: Bool
    @Published var autoStartBreaks: Bool
    @Published var cyclesBeforeLongBreak: Int
    @Published var focusValue: String = ""
    @Published var focusUnit: FocusUnit = .minutes
    @Published var shortBreakValue: String = ""
    @Published var shortBreakUnit: BreakUnit = .minutes
    @Published var longBreakValue: String = ""
    @Published var longBreakUnit: BreakUnit = .minutes
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(pomodoroViewModel: PomodoroViewModel) {
        self.pomodoroViewModel = pomodoroViewModel
        self.isRunning = pomodoroViewModel.state == .running
        self.focusDuration = pomodoroViewModel.focusDuration
        self.shortBreakDuration = pomodoroViewModel.shortBreakDuration
        self.longBreakDuration = pomodoroViewModel.longBreakDuration
        self.notificationsEnabled = pomodoroViewModel.notificationsEnabled
        self.autoStartFocus = pomodoroViewModel.autoStartFocus
        self.autoStartBreaks = pomodoroViewModel.autoStartBreaks
        self.cyclesBeforeLongBreak = pomodoroViewModel.cyclesBeforeLongBreak
        
        setupInitial(pomodoroViewModel)
    }
}

// MARK: - Private Setup Methods
extension SettingsViewModel {
    fileprivate func setupInitial(_ pomodoroViewModel: PomodoroViewModel) {
        setupInitialValues()
        
        DispatchQueue.main.async {
            self.setupBindings()
            self.setupAutomationBindings()
            
            pomodoroViewModel.$state
                .map { $0 == .running }
                .sink { [weak self] isRunning in
                    self?.isRunning = isRunning
                }
                .store(in: &self.cancellables)
        }
    }
    
    private func setupInitialValues() {
        (self.focusValue, self.focusUnit) = splitFocus(time: pomodoroViewModel.focusDuration)
        (self.shortBreakValue, self.shortBreakUnit) = splitBreak(time: pomodoroViewModel.shortBreakDuration)
        (self.longBreakValue, self.longBreakUnit) = splitBreak(time: pomodoroViewModel.longBreakDuration)
    }
    
    private func setupAutomationBindings() {
        $notificationsEnabled
            .sink { [weak self] isEnabled in
                guard let self = self else { return }
                self.pomodoroViewModel.notificationsEnabled = isEnabled
                self.handleNotificationsChange(isEnabled: isEnabled)
            }
            .store(in: &cancellables)
        
        $autoStartFocus
            .sink { [weak self] value in
                self?.pomodoroViewModel.autoStartFocus = value
            }
            .store(in: &cancellables)
        
        $autoStartBreaks
            .sink { [weak self] value in
                self?.pomodoroViewModel.autoStartBreaks = value
            }
            .store(in: &cancellables)
        
        $cyclesBeforeLongBreak
            .sink { [weak self] value in
                self?.pomodoroViewModel.cyclesBeforeLongBreak = value
            }
            .store(in: &cancellables)
    }
    
    private func setupBindings() {
        Publishers.CombineLatest($focusValue, $focusUnit)
            .sink { [weak self] value, unit in
                self?.updateFocusDuration(value: value, unit: unit)
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest($shortBreakValue, $shortBreakUnit)
            .sink { [weak self] value, unit in
                self?.updateShortBreakDuration(value: value, unit: unit)
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest($longBreakValue, $longBreakUnit)
            .sink { [weak self] value, unit in
                self?.updateLongBreakDuration(value: value, unit: unit)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Methods
extension SettingsViewModel {
    private func handleNotificationsChange(isEnabled: Bool) {
        if isEnabled {
            pomodoroViewModel.setupSystemFeatures()
        } else {
            pomodoroViewModel.cancelAllNotifications()
        }
    }
    
    private func updateFocusDuration(value: String, unit: FocusUnit) {
        if let finalTime = getValueFromFinalFocusTime(from: value, unit: unit), finalTime > 0 {
            self.focusDuration = finalTime
            self.pomodoroViewModel.focusDuration = self.focusDuration
        }
    }
    
    private func updateShortBreakDuration(value: String, unit: BreakUnit) {
        if let finalTime = getValueOfFinalPauseTime(from: value, unit: unit), finalTime > 0 {
            self.shortBreakDuration = finalTime
            self.pomodoroViewModel.shortBreakDuration = self.shortBreakDuration
        }
    }
    
    private func updateLongBreakDuration(value: String, unit: BreakUnit) {
        if let finalTime = getValueOfFinalPauseTime(from: value, unit: unit), finalTime > 0 {
            self.longBreakDuration = finalTime
            self.pomodoroViewModel.longBreakDuration = self.longBreakDuration
        }
    }
    
    private func getValueFromFinalFocusTime(from value: String, unit: FocusUnit) -> TimeInterval? {
        guard let number = Double(value.replacingOccurrences(of: ",", with: ".")) else { return nil }
        switch unit {
        case .seconds: return number
        case .minutes: return number * 60
        case .hours:   return number * 3600
        }
    }
    
    private func getValueOfFinalPauseTime(from value: String, unit: BreakUnit) -> TimeInterval? {
        guard let number = Double(value.replacingOccurrences(of: ",", with: ".")) else { return nil }
        switch unit {
        case .seconds: return number
        case .minutes: return number * 60
        }
    }
    
    private func splitFocus(time: TimeInterval) -> (String, FocusUnit) {
        if time >= 3600, time.truncatingRemainder(dividingBy: 3600) == 0 {
            return (String(Int(time / 3600)), .hours)
        } else if time >= 60, time.truncatingRemainder(dividingBy: 60) == 0 {
            return (String(Int(time / 60)), .minutes)
        } else {
            return (String(Int(time)), .seconds)
        }
    }
    
    private func splitBreak(time: TimeInterval) -> (String, BreakUnit) {
        if time >= 60, time.truncatingRemainder(dividingBy: 60) == 0 {
            return (String(Int(time / 60)), .minutes)
        } else {
            return (String(Int(time)), .seconds)
        }
    }
}
