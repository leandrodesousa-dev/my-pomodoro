import Foundation
import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let pomodoroViewModel: PomodoroViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - AppStorage
    @AppStorage("notificationsEnabled")
    private var notificationsEnabledStorage: Bool = AppConstants.GeneralConstants.defaultNotificationsEnabled
    @AppStorage("autoStartFocus")
    private var autoStartFocusStorage: Bool = AppConstants.GeneralConstants.defaultAutoStartFocus
    @AppStorage("autoStartBreaks")
    private var autoStartBreaksStorage: Bool = AppConstants.GeneralConstants.defaultAutoStartBreaks
    @AppStorage("cyclesBeforeLongBreak")
    private var cyclesBeforeLongBreakStorage: Int = AppConstants.Duration.defaultCyclesBeforeLongBreak
    @AppStorage("focusDuration")
    private var focusDurationStorage: TimeInterval = AppConstants.Duration.defaultFocusDuration
    @AppStorage("shortBreakDuration")
    private var shortBreakDurationStorage: TimeInterval = AppConstants.Duration.defaultShortBreakDuration
    @AppStorage("longBreakDuration")
    private var longBreakDurationStorage: TimeInterval = AppConstants.Duration.defaultLongBreakDuration
    
    // MARK: - Published Properties
    @Published var isRunning: Bool = false
    @Published var focusDuration: TimeInterval = 0.0
    @Published var shortBreakDuration: TimeInterval = 0.0
    @Published var longBreakDuration: TimeInterval = 0.0
    
    @Published var notificationsEnabled: Bool = false
    @Published var autoStartFocus: Bool = false
    @Published var autoStartBreaks: Bool = false
    @Published var cyclesBeforeLongBreak: Int = 0
    
    @Published var focusValue: String = ""
    @Published var focusUnit: FocusUnit = .minutes
    @Published var shortBreakValue: String = ""
    @Published var shortBreakUnit: BreakUnit = .minutes
    @Published var longBreakValue: String = ""
    @Published var longBreakUnit: BreakUnit = .minutes
    
    // MARK: - Initializers
    init(pomodoroViewModel: PomodoroViewModel) {
        self.pomodoroViewModel = pomodoroViewModel
        self.isRunning = pomodoroViewModel.state == .running
        
        self.setupInitial()
        
        DispatchQueue.main.async {
            self.syncSettingsFromStorage()
            self.setupPersistenceBindings()
        }
    }
}

// MARK: - Setup & Synchronization
extension SettingsViewModel {
    private func setupInitial() {
        pomodoroViewModel.$state
            .map { $0 == .running }
            .sink { [weak self] isRunning in
                    self?.isRunning = isRunning
            }
            .store(in: &cancellables)
    }
    
    private func syncSettingsFromStorage() {
        self.notificationsEnabled = self.notificationsEnabledStorage
        self.autoStartFocus = self.autoStartFocusStorage
        self.autoStartBreaks = self.autoStartBreaksStorage
        self.cyclesBeforeLongBreak = self.cyclesBeforeLongBreakStorage
        self.focusDuration = self.focusDurationStorage
        self.shortBreakDuration = self.shortBreakDurationStorage
        self.longBreakDuration = self.longBreakDurationStorage
        self.updatePomodoroOnViewLoad()
        self.setupInitialValues()
        self.setupBindings()
        self.setupAutomationBindings()
    }

    private func setupPersistenceBindings() {
        $notificationsEnabled
            .assign(to: \.notificationsEnabledStorage, on: self)
            .store(in: &cancellables)
            
        $autoStartFocus
            .assign(to: \.autoStartFocusStorage, on: self)
            .store(in: &cancellables)
            
        $autoStartBreaks
            .assign(to: \.autoStartBreaksStorage, on: self)
            .store(in: &cancellables)
            
        $cyclesBeforeLongBreak
            .assign(to: \.cyclesBeforeLongBreakStorage, on: self)
            .store(in: &cancellables)
        
        $focusDuration
            .assign(to: \.focusDurationStorage, on: self)
            .store(in: &cancellables)
        
        $shortBreakDuration
            .assign(to: \.shortBreakDurationStorage, on: self)
            .store(in: &cancellables)
        
        $longBreakDuration
            .assign(to: \.longBreakDurationStorage, on: self)
            .store(in: &cancellables)
    }

    private func setupInitialValues() {
        (self.focusValue, self.focusUnit) = splitFocus(time: pomodoroViewModel.focusDuration)
        (self.shortBreakValue, self.shortBreakUnit) = splitBreak(time: pomodoroViewModel.shortBreakDuration)
        (self.longBreakValue, self.longBreakUnit) = splitBreak(time: pomodoroViewModel.longBreakDuration)
    }
    
    private func setupAutomationBindings() {
        self.$notificationsEnabled
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
        
        $focusDuration
            .sink { [weak self] value in
                self?.pomodoroViewModel.focusDuration = value
            }
            .store(in: &cancellables)
        
        $shortBreakDuration
            .sink { [weak self] value in
                self?.pomodoroViewModel.shortBreakDuration = value
            }
            .store(in: &cancellables)
        
        $longBreakDuration
            .sink { [weak self] value in
                self?.pomodoroViewModel.longBreakDuration = value
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
    
    func updatePomodoroOnViewLoad() {
        pomodoroViewModel.notificationsEnabled = self.notificationsEnabled
        pomodoroViewModel.autoStartFocus = self.autoStartFocus
        pomodoroViewModel.autoStartBreaks = self.autoStartBreaks
        pomodoroViewModel.cyclesBeforeLongBreak = self.cyclesBeforeLongBreak
        pomodoroViewModel.focusDuration = self.focusDuration
        pomodoroViewModel.shortBreakDuration = self.shortBreakDuration
        pomodoroViewModel.longBreakDuration = self.longBreakDuration
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
        case .hours: return number * 3600
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
