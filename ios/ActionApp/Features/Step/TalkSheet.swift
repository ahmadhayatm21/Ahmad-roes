import SwiftUI

/// The mic on the step screen: a new thought at any time, or one word after Done.
struct TalkSheet: View {
    enum Mode: String, Identifiable {
        case thought, reply
        var id: String { rawValue }
    }

    let mode: Mode
    let onSend: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var text = ""

    private var said: String { text.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        VStack(spacing: 24) {
            Text(mode == .thought ? "What's on your mind?" : "One word. How was it?")
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            SpeakInput(
                text: $text,
                placeholder: mode == .thought ? "A new idea, a worry, or \"too big\"." : "Scared, easy, rejected…",
                micSize: 80,
                listensOnAppear: true
            )

            PrimaryButton("OK") {
                onSend(said)
                dismiss()
            }
            .disabled(said.isEmpty)
        }
        .padding(24)
        .presentationDetents([.medium, .large])
    }
}
