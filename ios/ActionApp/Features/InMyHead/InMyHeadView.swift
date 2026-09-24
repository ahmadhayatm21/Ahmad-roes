import SwiftUI

/// Tells deep thinking from a random thought.
///
/// Deep thinking is left alone. A random thought gets movement first, then a return to the task.
/// The thought itself is never discussed.
struct InMyHeadView: View {
    /// What the user was doing.
    let task: String
    /// The step they were on, if any.
    let step: String?
    /// Takes the user back to the walk-through where they left off.
    let onBackToStep: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var phase = Phase.ask

    enum Phase {
        case ask, deep, move, back
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            switch phase {
            case .ask: ask
            case .deep: deep
            case .move: move
            case .back: back
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .animation(.snappy, value: phase)
        .sensoryFeedback(.impact, trigger: phase)
        .interactiveDismissDisabled(phase != .ask)
    }

    private var ask: some View {
        VStack(spacing: 28) {
            Text("Is this thought about what you're doing right now?")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Spacer()
            VStack(spacing: 12) {
                PrimaryButton("Yes, I'm thinking about the work") { phase = .deep }
                PrimaryButton("No, it just came") { phase = .move }
            }
        }
    }

    private var deep: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 56, weight: .light))
            Text("Good. That's deep work.")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("Keep going.")
                .font(.title3)
                .foregroundStyle(.secondary)
            Spacer()
            PrimaryButton("Back to it", action: returnToTask)
        }
    }

    private var move: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.walk")
                .font(.system(size: 64, weight: .light))
                .symbolEffect(.pulse)
            Text("Stand up.")
                .font(.largeTitle.bold())
            Text("Walk around the room. Step away from the desk.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Spacer()
            PrimaryButton("I moved") { phase = .back }
        }
    }

    private var back: some View {
        VStack(spacing: 16) {
            Text("You were doing")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(task)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            if let step {
                Text("Step: \(step)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            PrimaryButton("Back to the step", action: returnToTask)
        }
    }

    private func returnToTask() {
        dismiss()
        onBackToStep()
    }
}

#Preview {
    Color.clear.sheet(isPresented: .constant(true)) {
        InMyHeadView(task: "First 10 calls", step: "Logic") {}
    }
}
