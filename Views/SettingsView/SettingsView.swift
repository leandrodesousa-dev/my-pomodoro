import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Duração do Foco")) {
                    Slider(
                        value: $pomodoroViewModel.focusDuration,
                        in: 5*60...60*60,
                        step: 5*60
                    ) {
                        Text("Tempo de Foco")
                    }
                    
                    HStack {
                        Text("Duração atual:")
                        Spacer()
                        Text(pomodoroViewModel.focusDuration.asTimerString)
                            .fontWeight(.semibold)
                    }
                }
                
                Section(header: Text("Intervalo Curto")) {
                    Slider(
                        value: $pomodoroViewModel.shortBreakDuration,
                        in: 1*60...15*60,
                        step: 1*60
                    )
                    HStack {
                        Text("Duração atual:")
                        Spacer()
                        Text(pomodoroViewModel.shortBreakDuration.asTimerString)
                            .fontWeight(.semibold)
                    }
                }
                
                Section(header: Text("Intervalo Longo")) {
                    Slider(
                        value: $pomodoroViewModel.longBreakDuration,
                        in: 5*60...30*60,
                        step: 5*60
                    )
                    HStack {
                        Text("Duração atual:")
                        Spacer()
                        Text(pomodoroViewModel.longBreakDuration.asTimerString)
                            .fontWeight(.semibold)
                    }
                }
                
                Section(header: Text("Ciclos")) {
                    Stepper("Ciclos para Intervalo Longo: \(pomodoroViewModel.cyclesBeforeLongBreak)",
                            value: $pomodoroViewModel.cyclesBeforeLongBreak,
                            in: 2...8)
                }
            }
            .navigationTitle("Configurações")
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
