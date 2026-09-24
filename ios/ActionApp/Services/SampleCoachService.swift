import Foundation

/// Realistic local answers so every screen is usable before the backend is live.
struct SampleCoachService: CoachService {
    var delay: Duration = .milliseconds(450)

    func gamePlan(_ request: GamePlanRequest) async throws -> GamePlan {
        try await Task.sleep(for: delay)
        return SampleContent.plan(for: request.context)
    }

    func sayIt(_ request: SayItRequest) async throws -> SayItResponse {
        try await Task.sleep(for: delay)
        return SayItResponse(line: SampleContent.cleanLine(from: request.intent))
    }

    func objection(_ request: ObjectionRequest) async throws -> ObjectionResponse {
        try await Task.sleep(for: delay)
        return ObjectionResponse(answer: SampleContent.answer(to: request.objection))
    }

    func practice(_ request: PracticeRequest) async throws -> PracticeResponse {
        try await Task.sleep(for: delay)
        let better = request.objection.map(SampleContent.answer(to:)) ?? ""
        let next = SampleContent.objections(for: request.context)
            .filter { $0 != request.objection }
            .randomElement() ?? "I need to think about it."
        return PracticeResponse(better: request.reply?.isEmpty == false ? better : "", nextObjection: next)
    }

    func script(_ request: ScriptRequest) async throws -> ScriptResponse {
        try await Task.sleep(for: delay)
        return SampleContent.script(for: request.plan)
    }
}
