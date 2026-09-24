import SwiftUI

/// The app throws realistic objections, the user answers, the app shows a better way to say it.
struct PracticeView: View {
    let context: MissionContext

    @Environment(\.coach) private var coach

    @State private var objection: String?
    @State private var reply = ""
    @State private var better: String?
    @State private var nextObjection: String?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let objection {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("They say")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        Text("“\(objection)”")
                            .font(.largeTitle.bold())
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if let better {
                        QuoteCard(label: "Better", text: better)
                    } else {
                        VoiceTextField(prompt: "Answer like you're at the door", text: $reply)
                    }
                } else if isLoading {
                    ProgressView().frame(maxWidth: .infinity)
                }

                if let errorMessage { ErrorLine(message: errorMessage) }
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            primaryButton
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
        }
        .navigationTitle("Practice")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if objection == nil { await send(objection: nil, reply: nil) }
        }
    }

    @ViewBuilder
    private var primaryButton: some View {
        if better != nil {
            PrimaryButton("Next objection") {
                withAnimation {
                    objection = nextObjection
                    better = nil
                    reply = ""
                }
            }
        } else {
            PrimaryButton("Answer", isLoading: isLoading && objection != nil) {
                Task { await send(objection: objection, reply: reply) }
            }
            .disabled(objection == nil || reply.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    private func send(objection current: String?, reply: String?) async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await coach.practice(
                PracticeRequest(context: context, objection: current, reply: reply)
            )
            withAnimation {
                if current == nil {
                    objection = response.nextObjection
                } else {
                    better = response.better.isEmpty ? "That works. Say it just like that." : response.better
                    nextObjection = response.nextObjection
                }
            }
        } catch {
            errorMessage = "Couldn't reach the coach. Try again."
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        PracticeView(context: SampleContent.salesContext)
    }
}
