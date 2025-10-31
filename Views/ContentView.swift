import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel

    var body: some View {
        TabView {
            PomodoroView()
                .environmentObject(pomodoroViewModel)
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }

            SettingsView()
                .environmentObject(pomodoroViewModel)
                .tabItem {
                    Label("Configurações", systemImage: "gearshape.fill")
                }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
