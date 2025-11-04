import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Group {
                if let icon = AppIconProvider.primaryAppIcon() {
                    Image(uiImage: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 120, maxHeight: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                } else {
                    Image(systemName: "timer")
                        .font(.system(size: 128, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    SplashView()
}


