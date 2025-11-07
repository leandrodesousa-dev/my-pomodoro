public enum BreakUnit: String, CaseIterable, Identifiable, CustomStringConvertible {
    case seconds, minutes;
    public var id: String { rawValue }

    public var description: String {
        switch self {
        case .seconds: return "Seg"
        case .minutes: return "Min"
        }
    }
}
