import SwiftUI

@main
struct MyPomodoroApp: App {
    @StateObject var pomodoroViewModel = PomodoroViewModel()
    
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroViewModel)
        }
        
        .onChange(of: scenePhase) { newPhase in
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
