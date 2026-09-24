import SwiftUI

/// The user reports what was said, gets a short answer, and goes straight back to the step.
struct ObjectionView: View {
    let context: MissionContext
    let stepTitle: String?

    @Environment(\.coach) private var coach
    @Environment(\.dismiss) private var dismiss

    @State private var objection = ""
    @State private var answer: String?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                if let answer {
                    Text("Say this back")
                        .font(.largeTitle.bold())
                    QuoteCard(label: "They said: \(objection)", text: answer)
                    Spacer()
                    PrimaryButton("Back to the step") { dismiss() }
                } else {
                    Text("What did they say?")
                        .font(.largeTitle.bold())
                    VoiceTextField(prompt: "“It's too expensive.”", text: $objection)
                    if let errorMessage { ErrorLine(message: errorMessage) }
                    Spacer()
                    PrimaryButton("What do I say?", isLoading: isLoading) {
                        Task { await ask() }
                    }
                    .disabled(objection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func ask() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await coach.objection(
                ObjectionRequest(objection: objection, context: context, step: stepTitle)
            )
            withAnimation { answer = response.answer }
        } catch {
            errorMessage = "Couldn't get an answer. Tap again."
        }
        isLoading = false
    }
}

#Preview {
    ObjectionView(context: SampleContent.salesContext, stepTitle: "Close or book")
}
