import SwiftData
import SwiftUI

/// First run. The user pictures their business out loud; the app gives back one tiny first step.
struct TellView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.coach) private var coach

    @State private var text = ""
    @State private var isWorking = false
    @State private var failed = false

    private var picture: String { text.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Text("Tell me about your business and how you think it'll go.")
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            SpeakInput(text: $text, placeholder: "What you want. How the business looks. Who you'll be.")

            Spacer()

            if failed {
                ErrorLine(message: "Couldn't get your first step. Tap again.")
            }

            PrimaryButton("FIRST STEP", isLoading: isWorking) {
                Task { await start() }
            }
            .disabled(picture.isEmpty)
        }
        .padding(20)
    }

    private func start() async {
        let picture = picture
        guard !picture.isEmpty else { return }
        isWorking = true
        failed = false
        let request = StepRequest(picture: [String(picture.prefix(4000))], done: [], current: nil, event: .start, said: nil)
        if let step = try? await coach.nextStep(request).step.trimmingCharacters(in: .whitespacesAndNewlines), !step.isEmpty {
            modelContext.insert(Journey(picture: picture, step: step))
        } else {
            failed = true
        }
        isWorking = false
    }
}

#Preview {
    TellView()
        .modelContainer(for: Journey.self, inMemory: true)
}
