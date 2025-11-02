import SwiftUI

struct FlipClockView: View {
    let timeString: String
    let availableWidth: CGFloat
    
    var boxWidth: CGFloat {
        let totalMinSecWidth = 2.0
        let totalPomodoroViewPadding = AppConstants.UI.standardPadding * 2
        
        return (availableWidth - AppConstants.UI.flipClockSpacing - totalPomodoroViewPadding) / totalMinSecWidth
    }
    
    var body: some View {
        HStack {
            FlipDigitBox(digit: timeString.prefix(2), totalBoxWidth: boxWidth)
            Text(":")
                .font(.system(size: 80, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .offset(y: -10)

            FlipDigitBox(digit: timeString.suffix(2), totalBoxWidth: boxWidth)
        }
    }
}
