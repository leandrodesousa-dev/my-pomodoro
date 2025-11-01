import SwiftUI

struct StatusPanel: View {
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel

    var body: some View {
        HStack {
            Text(pomodoroViewModel.statusText)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            Spacer()
            Text(pomodoroViewModel.nextBreakText)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
