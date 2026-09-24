import Foundation

/// The small plan the user acts on. Mirrors the backend's `/api/game-plan` response.
struct GamePlan: Codable, Hashable {
    var title: String
    var opener: String
    var steps: [PlanStep]
    var summary: String
    var dayPlan: [DayBlock]

    static let empty = GamePlan(title: "", opener: "", steps: [], summary: "", dayPlan: [])
}

struct PlanStep: Codable, Hashable {
    var title: String
    /// What to physically do now.
    var action: String
    /// The first words to say in this step. Empty when nothing is said.
    var firstLine: String
}

struct DayBlock: Codable, Hashable {
    /// 24h "HH:mm".
    var time: String
    var title: String
}
