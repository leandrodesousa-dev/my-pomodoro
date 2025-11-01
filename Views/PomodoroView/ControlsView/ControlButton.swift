import SwiftUI

struct ControlButton: View {
    let title: String
    let iconName: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.title3)
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
