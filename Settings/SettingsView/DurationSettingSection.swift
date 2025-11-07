import SwiftUI

struct DurationSettingSection<Unit: Hashable & CustomStringConvertible>: View {
    let title: String
    @Binding var valueString: String
    @Binding var unit: Unit
    let focusedField: FocusState<FocusField?>.Binding
    let equalsField: FocusField
    let finalDuration: TimeInterval
    let unitOptions: [Unit]
    
    var body: some View {
        Section(header: Text(title)) {
            HStack(spacing: 12) {
                TextField("0", text: $valueString)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .modifier(DurationFieldStyle())
                    .focused(focusedField, equals: equalsField)
                Picker("Unit", selection: $unit) {
                    ForEach(unitOptions, id: \.self) { unitOption in
                        Text(unitOption.description)
                            .tag(unitOption)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            HStack {
                Text("Tempo Final:")
                Spacer()
                Text(finalDuration.asTimerString)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct DurationFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color(.secondarySystemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.separator), lineWidth: 1)
            )
            .cornerRadius(10)
    }
}
