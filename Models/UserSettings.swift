import Foundation

struct UserSettings {
    var focusDuration: TimeInterval
    var shortBreakDuration: TimeInterval
    var longBreakDuration: TimeInterval
    var cyclesBeforeLongBreak: Int
}

public struct AppSettings {
    public static let defaultFocusDuration: TimeInterval = 0.0625 * 60
    public static let defaultShortBreakDuration: TimeInterval = 0.0625 * 60
    public static let defaultLongBreakDuration: TimeInterval = 0.0625 * 60
    public static let defaultCyclesBeforeLongBreak: Int = 2
}
