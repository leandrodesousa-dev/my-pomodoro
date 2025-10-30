import Foundation

struct UserSettings {
    var focusDuration: TimeInterval
    var shortBreakDuration: TimeInterval
    var longBreakDuration: TimeInterval
    var cyclesBeforeLongBreak: Int
}

public struct AppSettings {
    public static let defaultFocusDuration: TimeInterval = 25 * 60
    public static let defaultShortBreakDuration: TimeInterval = 5 * 60
    public static let defaultLongBreakDuration: TimeInterval = 15 * 60
    public static let defaultCyclesBeforeLongBreak: Int = 4
}
