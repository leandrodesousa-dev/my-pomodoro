import SwiftUI

struct FlipDigit: View {
    let character: Character
    let calculatedWidth: CGFloat
    
    var body: some View {
        let fontSize = calculatedWidth * AppConstants.GeneralConstants.defaultTimeScaleFactor
        let boxHeight = calculatedWidth * AppConstants.GeneralConstants.maxRetryRate
        
        Text(String(character))
            .font(.system(size: fontSize, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .frame(width: calculatedWidth, height: boxHeight, alignment: .center)
            .background(Color(.systemGray6).opacity(0.1))
            .cornerRadius(10)
            .clipped()
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.2))
                    .frame(maxHeight: .infinity),
                alignment: .center
            )
    }
}
