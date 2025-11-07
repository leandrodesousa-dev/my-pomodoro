import SwiftUI

struct SettingsView: View {
    // MARK: - Properites
    @StateObject private var settingsViewModel: SettingsViewModel
    @FocusState private var focusedField: FocusField?
    
    // MARK: - Initializers
    init(pomodoroViewModel: PomodoroViewModel) {
        self._settingsViewModel = StateObject(wrappedValue: SettingsViewModel(pomodoroViewModel: pomodoroViewModel))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    if settingsViewModel.isRunning {
                        setSettingsLockMessage()
                    }
                    List {
                        Section { EmptyView() }
                            .id("settingsTop")
                        setFocusDurationSectionSettings()
                        setShortBreakSectionSettings()
                        setLongBreakSectionSettings()
                        setCyclesSectionSettings()
                        setAutomaticActionsSectionSettings()
                    }
                    .overlay(
                        Color.black
                            .opacity(settingsViewModel.isRunning ? 0.8 : 0)
                            .animation(.easeInOut(duration: 0.2), value: settingsViewModel.isRunning)
                    )
                    .disabled(settingsViewModel.isRunning)
                    .scrollDismissesKeyboard(.immediately)
                    .simultaneousGesture(TapGesture().onEnded { focusedField = nil })
                    .onChange(of: settingsViewModel.isRunning) { _, _ in
                        withAnimation { proxy.scrollTo("settingsTop", anchor: .top)
                        }
                    }
                }
                .navigationTitle("Configurações")
                .safeAreaInset(edge: .bottom) {
                    if self.isFocusedField {
                        setKeyboardCloseButton()
                    }
                }
            }
        }
    }
}

// MARK: - Private Methods
extension SettingsView {
    private var isFocusedField: Bool {
        return focusedField != nil
    }
    
    fileprivate func setKeyboardCloseButton() -> some View {
        return HStack {
            Spacer()
            Button("Fechar") { focusedField = nil }
                .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
    
    fileprivate func setSettingsLockMessage() -> some View {
        return HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundColor(.yellow)
            VStack(alignment: .leading, spacing: 4) {
                Text("Configurações bloqueadas")
                    .fontWeight(.semibold)
                Text("Edite as configurações apenas quando o timer estiver pausado.")
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
    }
    
    fileprivate func setFocusDurationSectionSettings() -> some View {
        return DurationSettingSection(
            title: "Duração de Foco",
            valueString: $settingsViewModel.focusValue,
            unit: $settingsViewModel.focusUnit,
            focusedField: $focusedField,
            equalsField: .focus,
            finalDuration: settingsViewModel.focusDuration,
            unitOptions: FocusUnit.allCases
        )
    }
    
    fileprivate func setShortBreakSectionSettings() -> some View {
        return DurationSettingSection(
            title: "Pausa Curta",
            valueString: $settingsViewModel.shortBreakValue,
            unit: $settingsViewModel.shortBreakUnit,
            focusedField: $focusedField,
            equalsField: .shortBreak,
            finalDuration: settingsViewModel.shortBreakDuration,
            unitOptions: BreakUnit.allCases
        )
    }
    
    fileprivate func setLongBreakSectionSettings() -> some View {
        return DurationSettingSection(
            title: "Pausa Longa",
            valueString: $settingsViewModel.longBreakValue,
            unit: $settingsViewModel.longBreakUnit,
            focusedField: $focusedField,
            equalsField: .longBreak,
            finalDuration: settingsViewModel.longBreakDuration,
            unitOptions: BreakUnit.allCases
        )
    }
    
    fileprivate func setAutomaticActionsSectionSettings() -> some View {
        return  Section(header: Text("Execução Automática & Notificações")) {
            Toggle(isOn: $settingsViewModel.autoStartFocus) {
                Text("Início automático do Foco")
            }
            
            Toggle(isOn: $settingsViewModel.autoStartBreaks) {
                Text("Início automático das Pausas")
            }
            
            Toggle(isOn: $settingsViewModel.notificationsEnabled) {
                Text("Notificações")
            }
        }
    }
    
    fileprivate func setCyclesSectionSettings() -> some View {
        return Section(header: Text("Ciclos")) {
            Stepper("Ciclos completos: \(settingsViewModel.cyclesBeforeLongBreak)",
                    value: $settingsViewModel.cyclesBeforeLongBreak,
                    in: 2...8)
        }
    }
}

#Preview {
    let mockViewModel = PomodoroViewModel()
    mockViewModel.timeRemaining = 600
    mockViewModel.currentCycleType = .focus
    mockViewModel.state = .paused
    
    return SettingsView(pomodoroViewModel: mockViewModel)
}
