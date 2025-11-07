import SwiftUI

@main
struct MyPomodoroApp: App {
    @StateObject var pomodoroViewModel: PomodoroViewModel
    @StateObject var settingsViewModel: SettingsViewModel
    
    @Environment(\.scenePhase) var scenePhase
    @State private var showSplash: Bool = true
    
    init() {
        let initialPomodoroViewModel = PomodoroViewModel()
        _pomodoroViewModel = StateObject(wrappedValue: initialPomodoroViewModel)
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel(pomodoroViewModel: initialPomodoroViewModel))
    }
    
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
