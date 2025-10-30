import SwiftUI

struct PomodoroView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        VStack {
            Text("\(pomodoroViewModel.timeRemaining.asTimerString)")
                .font(.system(size: 80, weight: .bold, design: .monospaced))
            
            HStack {
                Button("Start") {
                    pomodoroViewModel.startTimer()
                }
                Button("Pause") {
                    pomodoroViewModel.pauseTimer()
                }
                Button("Reset") {
                    pomodoroViewModel.resetTimer()
                }
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
