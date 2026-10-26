import Foundation

/// Local steps so the app works before the backend is live, and when it fails.
/// The backend builds steps from the user's own picture; these are only a stand-in.
struct SampleCoachService: CoachService {
    var delay: Duration = .milliseconds(450)

    func nextStep(_ request: StepRequest) async throws -> StepResponse {
        try await Task.sleep(for: delay)
        return StepResponse(step: Self.step(for: request))
    }

    static func step(for request: StepRequest) -> String {
        switch request.event {
        case .start:
            return ladder[0]
        case .tooBig:
            guard let current = request.current, let first = current.first else { return ladder[0] }
            return "Do only the first move of this: \(first.lowercased())\(current.dropFirst())"
        case .done:
            return ladder[(request.done.count + 1) % ladder.count]
        case .thought:
            return ladder[request.done.count % ladder.count]
        }
    }

    private static let ladder = [
        "Write down the name of one person who needs what you offer.",
        "Find that person's phone number or email.",
        "Write the first sentence you'll say to them.",
        "Send them that sentence.",
        "Write down the name of the next person who needs it.",
    ]
}
