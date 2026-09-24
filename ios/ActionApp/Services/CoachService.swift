import Foundation

/// Everything the app asks the AI coach. Implemented by the backend client and by local sample data.
protocol CoachService {
    func gamePlan(_ request: GamePlanRequest) async throws -> GamePlan
    func sayIt(_ request: SayItRequest) async throws -> SayItResponse
    func objection(_ request: ObjectionRequest) async throws -> ObjectionResponse
    func practice(_ request: PracticeRequest) async throws -> PracticeResponse
    func script(_ request: ScriptRequest) async throws -> ScriptResponse
}

enum CoachServiceFactory {
    static func make() -> any CoachService {
        guard let url = AppConfig.backendURL else { return SampleCoachService() }
        return ResilientCoachService(
            primary: RemoteCoachService(baseURL: url, token: AppConfig.appToken),
            fallback: SampleCoachService()
        )
    }
}
