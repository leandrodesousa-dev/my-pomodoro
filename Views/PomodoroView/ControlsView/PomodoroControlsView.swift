import SwiftUI

struct PomodoroControlsView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            Group {
                if pomodoroViewModel.state == .running {
                    ControlButton(
                        title: "Pause",
                        iconName: "pause.fill",
                        backgroundColor: Color(.systemGray5),
                        foregroundColor: .primary,
                        action: pomodoroViewModel.pauseTimer
                    )
                } else {
                    ControlButton(
                        title: "Start",
                        iconName: "play.fill",
                        backgroundColor: .blue,
                        foregroundColor: .white,
                        action: pomodoroViewModel.startTimer
                    )
                }
            }

            ControlButton(
                title: "Stop",
                iconName: "stop.fill",
                backgroundColor: Color(.systemGray5),
                foregroundColor: .primary,
                action: pomodoroViewModel.stopTimer
            )
            .opacity(pomodoroViewModel.state == .stopped ? 0.5 : 1.0)
            .disabled(pomodoroViewModel.state == .stopped)

            ControlButton(
                title: "Restart",
                iconName: "arrow.counterclockwise",
                backgroundColor: Color(.systemGray5),
                foregroundColor: .primary,
                action: pomodoroViewModel.stopTimer
            )
            
            ControlButton(
                title: "Skip Break",
                iconName: "forward.fill",
                backgroundColor: Color.yellow,
                foregroundColor: .primary,
                action: pomodoroViewModel.skipBreak
            )
            .opacity(pomodoroViewModel.currentCycleType == .focus ? 0.5 : 1.0)
            .disabled(pomodoroViewModel.currentCycleType == .focus)

        }
    }
}
