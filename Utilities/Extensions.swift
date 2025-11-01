import Foundation

public extension TimeInterval {
    var asTimerString: String {
        let totalSeconds = Int(self)
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
