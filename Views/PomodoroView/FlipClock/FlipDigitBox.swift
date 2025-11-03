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
            let characters = Array(digit)
            ForEach(characters.indices, id: \.self) { index in
                FlipDigit(character: characters[index], calculatedWidth: digitWidth)
            }
        }
        .frame(width: totalBoxWidth)
        .frame(height: digitWidth * AppConstants.GeneralConstants.maxRetryRate)
    }
}
