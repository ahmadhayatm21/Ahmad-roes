import SwiftUI

/// "Step 2 of 5" with a thin segmented bar.
struct StepProgressView: View {
    let current: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step \(current + 1) of \(total)")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
            HStack(spacing: 4) {
                ForEach(0..<total, id: \.self) { index in
                    Capsule()
                        .fill(index <= current ? Color.primary : Color(.tertiarySystemFill))
                        .frame(height: 4)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}
