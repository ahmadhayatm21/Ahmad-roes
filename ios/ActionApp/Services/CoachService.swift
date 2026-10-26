import Foundation

/// Everything the app asks the AI coach. Implemented by the backend client and by local sample data.
protocol CoachService {
    func nextStep(_ request: StepRequest) async throws -> StepResponse
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
