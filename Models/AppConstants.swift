import Foundation
import SwiftUI

public struct AppConstants {
    // MARK: - Default work session duration.
    /** The standard duration for the focused work interval (Pomodoro) in minutes. */
    struct Duration {
        public static let defaultFocusDuration: TimeInterval = 0.0635 * 60
        public static let defaultShortBreakDuration: TimeInterval = 0.5 * 60
        public static let defaultLongBreakDuration: TimeInterval = 0.0635 * 60
        public static let defaultCyclesBeforeLongBreak: Int = 2
    }
    
    // MARK: - Container for UI and Design constants.
    struct UI {
        static let standardPadding: CGFloat = 24
        static let flipClockSpacing: CGFloat = 12
        static let interDigitSpacing: CGFloat = 2
    }
    
    // MARK: - Container for general, non-specific application constants.
    struct GeneralConstants {
        static let defaultTimeScaleFactor: CGFloat = 1.5
        static let maxRetryRate: CGFloat = 2.5
        // Settings defaults
        static let defaultAutoStartFocus: Bool = false
        static let defaultAutoStartBreaks: Bool = false
        static let defaultNotificationsEnabled: Bool = false
    }
    
}
