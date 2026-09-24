import Foundation

/// The three answers from the start flow. Sent with every coach request.
struct MissionContext: Codable, Hashable {
    var goal: String
    var avoiding: String
    var mustDo: String
}
