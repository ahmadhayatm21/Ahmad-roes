import SwiftUI

/// The plan's steps as a numbered structure. Titles only: the details unlock in the walk-through.
struct PlanStructureList: View {
    let steps: [PlanStep]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("The structure")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(spacing: 14) {
                    Text("\(index + 1)")
                        .font(.subheadline.weight(.semibold).monospacedDigit())
                        .frame(width: 28, height: 28)
                        .background(Color(.secondarySystemBackground), in: Circle())
                    Text(step.title)
                        .font(.body.weight(.medium))
                }
            }
        }
    }
}
