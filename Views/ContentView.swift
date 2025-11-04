import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            TabView {
                PomodoroView()
                    .environmentObject(pomodoroViewModel)
                    .tabItem {
                        Label("Timer", systemImage: "timer")
                    }

                Group {
                    if isLandscape {
                        VStack(spacing: 16) {
                            Image(systemName: "iphone.rotated")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            Text("Configurações disponíveis apenas na orientação vertical")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                    } else {
                        SettingsView()
                            .environmentObject(pomodoroViewModel)
                    }
                }
                .tabItem {
                    Label("Configurações", systemImage: "gearshape.fill")
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
