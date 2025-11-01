import SwiftUI

struct PomodoroView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        VStack {
            Text(pomodoroViewModel.currentCycleType == .focus ? "Foco" : (pomodoroViewModel.currentCycleType == .shortBreak ? "Pausa Curta" : "Pausa Longa"))
                .font(.title)
                .fontWeight(.bold)
            
            GeometryReader { geo in
                VStack {
                    FlipClockView(
                        timeString: pomodoroViewModel.timeString,
                        availableWidth: geo.size.width
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }

            StatusPanel()
                .padding(.horizontal)
                .padding(.bottom, 40)
            
            PomodoroControlsView()
        }
        .padding(.horizontal, AppConstants.UI.standardPadding)
        .padding(.vertical, AppConstants.UI.standardPadding)
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
