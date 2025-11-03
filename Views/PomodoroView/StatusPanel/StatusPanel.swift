import SwiftUI

struct StatusPanel: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel

    var body: some View {
        HStack {
            Text(pomodoroViewModel.statusText)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .allowsTightening(true)
            Spacer()
            Text(pomodoroViewModel.nextBreakText)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .allowsTightening(true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
