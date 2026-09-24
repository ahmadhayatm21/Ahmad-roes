import Foundation

/// Uses the backend, and falls back to local answers when it fails,
/// so the user is never left without a next step.
struct ResilientCoachService: CoachService {
    let primary: any CoachService
    let fallback: any CoachService

    func gamePlan(_ request: GamePlanRequest) async throws -> GamePlan {
        do { return try await primary.gamePlan(request) } catch { return try await fallback.gamePlan(request) }
    }

    func sayIt(_ request: SayItRequest) async throws -> SayItResponse {
        do { return try await primary.sayIt(request) } catch { return try await fallback.sayIt(request) }
    }

    func objection(_ request: ObjectionRequest) async throws -> ObjectionResponse {
        do { return try await primary.objection(request) } catch { return try await fallback.objection(request) }
    }

    func practice(_ request: PracticeRequest) async throws -> PracticeResponse {
        do { return try await primary.practice(request) } catch { return try await fallback.practice(request) }
    }

    func script(_ request: ScriptRequest) async throws -> ScriptResponse {
        do { return try await primary.script(request) } catch { return try await fallback.script(request) }
    }
}
