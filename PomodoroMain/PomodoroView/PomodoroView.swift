import SwiftUI

struct PomodoroView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            Group {
                if isLandscape {
                    setComponentsHStack(isLandscape, width: geometry.size.width)
                } else {
                    setComponentsVStack(isLandscape)
                }
            }
            .padding(.horizontal, AppConstants.UI.standardPadding)
            .padding(.vertical, AppConstants.UI.standardPadding)
        }
    }
    
    fileprivate func setFlipClockView(_ isLandscape: Bool, width: CGFloat) -> some View {
        return FlipClockView(
            timeString: pomodoroViewModel.timeRemaining.asTimerStringWithoutTwoPoints,
            availableWidth: isLandscape ? (width * 0.55) : width
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    fileprivate func setComponentsHStack(_ isLandscape: Bool, width: CGFloat) -> some View {
        return HStack(alignment: .center, spacing: AppConstants.UI.standardPadding) {
            VStack(spacing: AppConstants.UI.flipClockSpacing) {
                titlePomodoroView(isLandscape)
                setFlipClockView(isLandscape, width: width)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            VStack(spacing: AppConstants.UI.standardPadding) {
                StatusPanel(isLandscape: true)
                PomodoroControlsView()
            }
            .frame(maxWidth: width * 0.35)
        }
    }
    
    fileprivate func setComponentsVStack(_ isLandscape: Bool) -> some View {
        return VStack {
            titlePomodoroView(isLandscape)
            GeometryReader { geometry in
                VStack {
                    setFlipClockView(isLandscape, width: geometry.size.width)
                }
            }
            
            StatusPanel(isLandscape: false)
                .padding(.bottom, 40)
            
            PomodoroControlsView()
        }
    }
    
    fileprivate func titlePomodoroView(_ isLandscape: Bool) -> Text {
        return Text(pomodoroViewModel.currentCycleType == .focus ? "Foco" : (pomodoroViewModel.currentCycleType == .shortBreak ? "Pausa Curta" : "Pausa Longa"))
            .font(isLandscape ? .title2 : .title)
            .fontWeight(.bold)
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
