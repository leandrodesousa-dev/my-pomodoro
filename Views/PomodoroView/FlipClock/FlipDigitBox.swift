import SwiftUI

struct FlipDigitBox: View {
    let digit: Substring
    let totalBoxWidth: CGFloat
    
    var digitWidth: CGFloat {
        let numberOfDigits = 2.0
        return (totalBoxWidth - AppConstants.UI.flipClockSpacing) / numberOfDigits
    }
    
    var body: some View {
        HStack(spacing: AppConstants.UI.interDigitSpacing) {
            ForEach(Array(digit), id: \.self) { character in
                FlipDigit(character: character, calculatedWidth: digitWidth)
            }
        }
        .frame(width: totalBoxWidth)
        .frame(height: digitWidth * AppConstants.GeneralConstants.maxRetryRate)
    }
}
