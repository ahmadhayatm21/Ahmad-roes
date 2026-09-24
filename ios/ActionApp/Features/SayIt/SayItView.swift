import SwiftUI

/// The user speaks or types a messy intent and gets back exactly how to say it.
struct SayItView: View {
    let context: MissionContext
    let stepTitle: String?

    @Environment(\.coach) private var coach
    @Environment(\.dismiss) private var dismiss

    @State private var intent = ""
    @State private var line: String?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                if let line {
                    Text("Say this")
                        .font(.largeTitle.bold())
                    QuoteCard(label: "Out loud", text: line)
                    Button("Say something else") {
                        self.line = nil
                        intent = ""
                    }
                    .buttonStyle(.quiet)
                    Spacer()
                    PrimaryButton("Back to the step") { dismiss() }
                } else {
                    Text("What do you want to say?")
                        .font(.largeTitle.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    VoiceTextField(prompt: "Messy is fine. Just say it.", text: $intent)
                    if let errorMessage { ErrorLine(message: errorMessage) }
                    Spacer()
                    PrimaryButton("Give me the words", isLoading: isLoading) {
                        Task { await ask() }
                    }
                    .disabled(intent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
            let response = try await coach.sayIt(SayItRequest(intent: intent, context: context, step: stepTitle))
            withAnimation { line = response.line }
        } catch {
            errorMessage = "Couldn't get the words. Tap again."
        }
        isLoading = false
    }
}

#Preview {
    SayItView(context: SampleContent.salesContext, stepTitle: "Opener")
}
