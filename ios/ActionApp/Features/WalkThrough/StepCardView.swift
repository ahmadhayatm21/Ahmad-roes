import SwiftUI

/// The current step: what to do, and the first line to say.
struct StepCardView: View {
    let step: PlanStep

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(step.title)
                .font(.largeTitle.bold())
                .fixedSize(horizontal: false, vertical: true)

            Text(step.action)
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)

            if !step.firstLine.isEmpty {
                QuoteCard(label: "Say", text: step.firstLine)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
