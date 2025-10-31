import SwiftUI

struct PomodoroView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
            VStack(spacing: 40) {
                Text(pomodoroViewModel.currentCycleType == .focus ? "Foco" : (pomodoroViewModel.currentCycleType == .shortBreak ? "Pausa Curta" : "Pausa Longa"))
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(pomodoroViewModel.timeRemaining.asTimerString)
                    .font(.system(size: 80, weight: .bold, design: .monospaced))
                    .foregroundColor(pomodoroViewModel.currentCycleType == .focus ? .gray : .green)
                
                Text("Ciclos de Foco Concluídos: \(pomodoroViewModel.cyclesCompleted)")
                    .font(.subheadline)
                
                HStack(spacing: 30) {
                    Button {
                        pomodoroViewModel.startTimer()
                    } label: {
                        Image(systemName: "play.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .controlSize(.large)
                    .opacity(0.8)
                    
                    Button {
                        pomodoroViewModel.pauseTimer()
                    } label: {
                        Image(systemName: "pause.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                    .controlSize(.large)
                    .opacity(0.8)

                    Button {
                        pomodoroViewModel.stopTimer()
                    } label: {
                        Image(systemName: "stop.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .controlSize(.large)
                    .opacity(0.8)
                }
            }
        }
}

#Preview {
    let mockViewModel = PomodoroViewModel()
    mockViewModel.timeRemaining = 600
    mockViewModel.currentCycleType = .focus
    mockViewModel.state = .paused
    
    return PomodoroView()
        .environmentObject(mockViewModel)
        .preferredColorScheme(.dark)
}
