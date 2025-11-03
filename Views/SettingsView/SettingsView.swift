import SwiftUI

struct SettingsView: View {
    // MARK: - Properites
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    @State private var focusValue: String = ""
    @State private var focusUnit: FocusUnit = .minutes
    
    @State private var shortBreakValue: String = ""
    @State private var shortBreakUnit: BreakUnit = .minutes
    
    @State private var longBreakValue: String = ""
    @State private var longBreakUnit: BreakUnit = .minutes
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                if pomodoroViewModel.state != .paused {
                    Section {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.yellow)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Configurações bloqueadas")
                                    .fontWeight(.semibold)
                                Text("Edite as configurações apenas quando o timer estiver pausado.")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Duração de Foco")) {
                    HStack(spacing: 12) {
                        TextField("0", text: $focusValue)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.separator), lineWidth: 1)
                            )
                            .cornerRadius(10)
                        Picker("Unit", selection: $focusUnit) {
                            Text("sec").tag(FocusUnit.seconds)
                            Text("min").tag(FocusUnit.minutes)
                            Text("hr").tag(FocusUnit.hours)
                        }
                        .pickerStyle(.segmented)
                    }
                    .onChange(of: focusValue) { _, _ in
                        if let finalFocusTime = getValueFromFinalFocusTime(from: focusValue, unit: focusUnit), finalFocusTime > 0 {
                            pomodoroViewModel.focusDuration = finalFocusTime
                        }
                    }
                    .onChange(of: focusUnit) { _, _ in
                        if let finalFocusTime = getValueFromFinalFocusTime(from: focusValue, unit: focusUnit), finalFocusTime > 0 {
                            pomodoroViewModel.focusDuration = finalFocusTime
                        }
                    }

                    HStack {
                        Text("Tempo Final:")
                        Spacer()
                        Text(pomodoroViewModel.focusDuration.asTimerString)
                            .fontWeight(.semibold)
                    }
                }
                
                Section(header: Text("Pausa Curta")) {
                    HStack(spacing: 12) {
                        TextField("0", text: $shortBreakValue)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.separator), lineWidth: 1)
                            )
                            .cornerRadius(10)
                        Picker("Unit", selection: $shortBreakUnit) {
                            Text("sec").tag(BreakUnit.seconds)
                            Text("min").tag(BreakUnit.minutes)
                        }
                        .pickerStyle(.segmented)
                    }
                    .onChange(of: shortBreakValue) { _, _ in
                        if let finalPauseTime = getValueOfFinalPauseTime(from: shortBreakValue, unit: shortBreakUnit), finalPauseTime > 0 {
                            pomodoroViewModel.shortBreakDuration = finalPauseTime
                        }
                    }
                    .onChange(of: shortBreakUnit) { _, _ in
                        if let finalPauseTime = getValueOfFinalPauseTime(from: shortBreakValue, unit: shortBreakUnit), finalPauseTime > 0 {
                            pomodoroViewModel.shortBreakDuration = finalPauseTime
                        }
                    }
                    HStack {
                        Text("Tempo Final:")
                        Spacer()
                        Text(pomodoroViewModel.shortBreakDuration.asTimerString)
                            .fontWeight(.semibold)
                    }
                }
                
                Section(header: Text("Puasa Longa")) {
                    HStack(spacing: 12) {
                        TextField("0", text: $longBreakValue)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.separator), lineWidth: 1)
                            )
                            .cornerRadius(10)
                        Picker("Unit", selection: $longBreakUnit) {
                            Text("sec").tag(BreakUnit.seconds)
                            Text("min").tag(BreakUnit.minutes)
                        }
                        .pickerStyle(.segmented)
                    }
                    .onChange(of: longBreakValue) { _, _ in
                        if let finalPauseTime = getValueOfFinalPauseTime(from: longBreakValue, unit: longBreakUnit), finalPauseTime > 0 {
                            pomodoroViewModel.longBreakDuration = finalPauseTime
                        }
                    }
                    .onChange(of: longBreakUnit) { _, _ in
                        if let finalPauseTime = getValueOfFinalPauseTime(from: longBreakValue, unit: longBreakUnit), finalPauseTime > 0 {
                            pomodoroViewModel.longBreakDuration = finalPauseTime
                        }
                    }
                    HStack {
                        Text("Tempo Final:")
                        Spacer()
                        Text(pomodoroViewModel.longBreakDuration.asTimerString)
                            .fontWeight(.semibold)
                    }
                }
                
                Section(header: Text("Ciclos")) {
                    Stepper("Ciclos completos: \(pomodoroViewModel.cyclesBeforeLongBreak)",
                            value: $pomodoroViewModel.cyclesBeforeLongBreak,
                            in: 2...8)
                }

                Section(header: Text("Execução Automática & Notificações")) {
                    Toggle(isOn: $pomodoroViewModel.autoStartFocus) {
                        Text("Início automático do Foco")
                    }

                    Toggle(isOn: $pomodoroViewModel.autoStartBreaks) {
                        Text("Início automático das Pausas")
                    }

                    Toggle(isOn: $pomodoroViewModel.notificationsEnabled) {
                        Text("Notificações")
                    }
                    .onChange(of: pomodoroViewModel.notificationsEnabled) { _, isEnabled in
                        if isEnabled {
                            pomodoroViewModel.setupSystemFeatures()
                        } else {
                            pomodoroViewModel.cancelAllNotifications()
                        }
                    }
                }
            }
            .navigationTitle("Configurações")
            .disabled(pomodoroViewModel.state != .paused)
            .onAppear {
                let (focusValue, focusUnit) = splitFocus(time: pomodoroViewModel.focusDuration)
                self.focusValue = focusValue
                self.focusUnit = focusUnit
                
                let (shortBreakValue, shortBreakUnit) = splitBreak(time: pomodoroViewModel.shortBreakDuration)
                self.shortBreakValue = shortBreakValue
                self.shortBreakUnit = shortBreakUnit
                
                let (longBreakValue, longBreakUnit) = splitBreak(time: pomodoroViewModel.longBreakDuration)
                self.longBreakValue = longBreakValue
                self.longBreakUnit = longBreakUnit
            }
        }
    }
    
    // MARK: - Models
    private enum FocusUnit: String, CaseIterable, Identifiable {
        case seconds, minutes, hours;
        var id: String { rawValue }
    }
    
    private enum BreakUnit: String, CaseIterable, Identifiable {
        case seconds, minutes;
        var id: String { rawValue }
    }
    
    // MARK: - Private Methods
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

#Preview {
    let mockViewModel = PomodoroViewModel()
    mockViewModel.timeRemaining = 600
    mockViewModel.currentCycleType = .focus
    mockViewModel.state = .paused
    
    return SettingsView()
        .environmentObject(mockViewModel)
}
