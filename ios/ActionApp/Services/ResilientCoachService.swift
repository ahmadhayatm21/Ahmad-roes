import Foundation

/// Uses the backend, and falls back to local answers when it fails,
/// so the user is never left without a next step.
struct ResilientCoachService: CoachService {
    let primary: any CoachService
    let fallback: any CoachService

    func nextStep(_ request: StepRequest) async throws -> StepResponse {
        do { return try await primary.nextStep(request) } catch { return try await fallback.nextStep(request) }
    }
}
