import SwiftUI

/// The goal everything on the screen is working toward, with rounds done so far.
struct GoalHeader: View {
    let goal: String
    let wins: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(goal, systemImage: "scope")
                .font(.subheadline.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
            if wins > 0 {
                Text(wins == 1 ? "1 round done toward it" : "\(wins) rounds done toward it")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    GoalHeader(goal: "Close 3 new clients this month", wins: 2).padding()
}
