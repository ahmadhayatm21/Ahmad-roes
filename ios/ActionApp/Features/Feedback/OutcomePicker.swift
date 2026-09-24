import SwiftUI

/// Three quick answers: did it, partly, not yet. No judgement either way.
struct OutcomePicker: View {
    @Binding var selection: Outcome?

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Outcome.allCases) { outcome in
                let isSelected = selection == outcome
                Button {
                    selection = outcome
                } label: {
                    Text(outcome.label)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .foregroundStyle(isSelected ? Color(.systemBackground) : Color.primary)
                        .background(
                            isSelected ? Color.primary : Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }
}
