import SwiftUI

struct PomodoroControlsView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack(spacing: 16) {
                Group {
                    if pomodoroViewModel.state == .running {
                        ControlButton(
                            title: "Pause",
                            iconName: "pause.fill",
                            backgroundColor: .red,
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
                    title: "Restart",
                    iconName: "arrow.counterclockwise",
                    backgroundColor: Color(.systemGray5),
                    foregroundColor: .primary,
                    action: pomodoroViewModel.stopTimer
                )
            }
            .frame(maxWidth: .infinity)

            ControlButton(
                title: "Skip Break",
                iconName: "forward.fill",
                backgroundColor: Color.yellow,
                foregroundColor: .primary,
                action: pomodoroViewModel.skipBreak
            )
            .opacity(pomodoroViewModel.currentCycleType == .focus ? 0.5 : 1.0)
            .disabled(pomodoroViewModel.currentCycleType == .focus)
            .frame(maxWidth: .infinity)
        }
    }
}
