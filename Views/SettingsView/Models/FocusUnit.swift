enum FocusUnit: String, CaseIterable, Hashable, CustomStringConvertible {
    case seconds, minutes, hours

    var description: String {
        switch self {
        case .seconds: return "Seg"
        case .minutes: return "Min"
        case .hours: return "Hrs"
        }
    }
}
