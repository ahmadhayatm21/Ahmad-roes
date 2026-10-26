import SwiftUI

/// The main screen: one step, Done, and the mic. Nothing else.
struct StepView: View {
    let journey: Journey

    @Environment(\.coach) private var coach
    /// The step after this one, fetched ahead so Done is instant.
    @State private var upcoming: Task<String?, Never>?
    @State private var isWorking = false
    @State private var failed = false
    /// After Done, offer an optional one-word reply.
    @State private var offersReply = false
    @State private var talk: TalkSheet.Mode?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text(journey.step)
                .font(.largeTitle.bold())
                .fixedSize(horizontal: false, vertical: true)
                .opacity(isWorking ? 0.3 : 1)
                .id(journey.step)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))

            Spacer()

            if failed {
                ErrorLine(message: "Couldn't reach the coach. Try again.")
            }

            HStack {
                Button("Too big") { Task { await shrink() } }
                    .buttonStyle(.quiet)
                if offersReply {
                    Button("How was it?") { talk = .reply }
                        .buttonStyle(.quiet)
                }
                Spacer()
                Button { talk = .thought } label: {
                    Image(systemName: "mic.fill")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Color(.systemBackground))
                        .frame(width: 56, height: 56)
                        .background(Color.primary, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Talk")
            }
            .disabled(isWorking)

            PrimaryButton("DONE", isLoading: isWorking) {
                Task { await finish() }
            }
        }
        .padding(20)
        .animation(.snappy, value: journey.step)
        .sensoryFeedback(.success, trigger: journey.done.count)
        .onAppear(perform: prefetch)
        .sheet(item: $talk) { mode in
            TalkSheet(mode: mode) { said in
                Task { await heard(said, mode: mode) }
            }
        }
    }

    // MARK: Actions

    private func finish() async {
        guard !isWorking else { return }
        let finished = journey.step
        isWorking = true
        var step = await upcoming?.value
        isWorking = false
        if step == nil {
            step = await fetch(journey.request(.done))
        }
        guard let step else { return }
        journey.done.append(finished)
        show(step)
        offersReply = true
    }

    private func shrink() async {
        offersReply = false
        if let step = await fetch(journey.request(.tooBig)) { show(step) }
    }

    private func heard(_ said: String, mode: TalkSheet.Mode) async {
        offersReply = false
        switch mode {
        case .reply:
            // Re-choose the step that followed the one just done, using the word.
            var request = journey.request(.done, said: said)
            request.current = journey.done.last
            request.done = Array(request.done.dropLast())
            if let step = await fetch(request) { show(step) }
        case .thought:
            if Self.meansTooBig(said) {
                await shrink()
            } else {
                journey.picture.append(said)
                if let step = await fetch(journey.request(.thought)) { show(step) }
            }
        }
    }

    // MARK: Coach

    private func show(_ step: String) {
        journey.step = step
        prefetch()
    }

    /// Fetches the step after the current one in the background.
    private func prefetch() {
        upcoming?.cancel()
        let request = journey.request(.done)
        let coach = coach
        upcoming = Task { try? await Self.step(from: coach.nextStep(request)) }
    }

    private func fetch(_ request: StepRequest) async -> String? {
        isWorking = true
        failed = false
        let step = try? await Self.step(from: coach.nextStep(request))
        isWorking = false
        failed = step == nil
        return step
    }

    private static func step(from response: StepResponse) -> String? {
        let step = response.step.trimmingCharacters(in: .whitespacesAndNewlines)
        return step.isEmpty ? nil : step
    }

    /// A short "too big" said out loud splits the step instead of becoming part of the picture.
    static func meansTooBig(_ said: String) -> Bool {
        let text = said.lowercased()
        guard text.split(separator: " ").count <= 6 else { return false }
        return ["too big", "too much", "too hard", "smaller", "can't do"].contains { text.contains($0) }
    }
}

#if DEBUG
#Preview {
    StepView(journey: Journey(
        picture: "A gym software business. Local gyms call me first.",
        step: "Write down the name of one gym owner you know."
    ))
    .modelContainer(for: Journey.self, inMemory: true)
}
#endif
