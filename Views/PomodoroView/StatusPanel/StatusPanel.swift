import SwiftUI

struct StatusPanel: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    var isLandscape: Bool = false

    var body: some View {
        HStack {
            Text(pomodoroViewModel.statusText)
                .font(isLandscape ? .footnote : .subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
            Spacer()
            Text(pomodoroViewModel.nextBreakText)
                .font(isLandscape ? .footnote : .subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
        }
        .padding(.horizontal, isLandscape ? 10 : 12)
        .padding(.vertical, isLandscape ? 8 : 12)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
