import Foundation

/// Talks to the Next.js backend. The Claude API key lives only on the server.
struct RemoteCoachService: CoachService {
    let baseURL: URL
    let token: String?
    var session: URLSession = .shared

    enum RemoteError: Error {
        case badStatus(Int)
    }

    func gamePlan(_ request: GamePlanRequest) async throws -> GamePlan {
        try await post("api/game-plan", request)
    }

    func sayIt(_ request: SayItRequest) async throws -> SayItResponse {
        try await post("api/say-it", request)
    }

    func objection(_ request: ObjectionRequest) async throws -> ObjectionResponse {
        try await post("api/objection", request)
    }

    func practice(_ request: PracticeRequest) async throws -> PracticeResponse {
        try await post("api/practice", request)
    }

    func script(_ request: ScriptRequest) async throws -> ScriptResponse {
        try await post("api/script", request)
    }

    private func post<Body: Encodable, Response: Decodable>(_ path: String, _ body: Body) async throws -> Response {
        var request = URLRequest(url: baseURL.appending(path: path))
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token {
            request.setValue(token, forHTTPHeaderField: "x-app-token")
        }
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(status) else { throw RemoteError.badStatus(status) }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
