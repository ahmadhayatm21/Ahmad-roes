import SwiftUI

/// The one next step toward the goal: what it is and what to physically do.
struct NextStepCard: View {
    let step: PlanStep
    let number: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Next step · \(number) of \(total)")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(step.title)
                .font(.title3.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
            Text(step.action)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NextStepCard(
        step: PlanStep(title: "Dial the first number", action: "Pick the top gym on your list and call it now.", firstLine: ""),
        number: 1,
        total: 4
    )
    .padding()
}
