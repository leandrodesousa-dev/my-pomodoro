import Foundation

public extension TimeInterval {
    var asTimerString: String {
        let totalSeconds = Int(self) // nao entendi essa parte do self
        let minutes = (totalSeconds / 60) % 60 // ele divide por 60 e depois dividi de novo por 60? qual é a diferença enre '/' e '%'
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d", minutes, seconds) // o que significa '%02d'
    }
}
