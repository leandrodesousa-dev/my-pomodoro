import SwiftUI

@main
struct MyPomodoroApp: App {
    @StateObject var pomodoroViewModel = PomodoroViewModel()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var showSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(pomodoroViewModel)
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    showSplash = false
                                }
                            }
                        }
                }
            }
        }
        
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .background:
                pomodoroViewModel.handleAppBackground()
            case .active:
                pomodoroViewModel.setupSystemFeatures()
                pomodoroViewModel.handleAppActive()
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}
