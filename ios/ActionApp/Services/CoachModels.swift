import Foundation

// Request and response bodies for the backend. Field names match the JSON exactly.

enum StepEvent: String, Codable {
    /// The first step, right after the user describes their picture.
    case start
    /// The current step is done.
    case done
    /// The current step is too big. Split it.
    case tooBig
    /// The user said something new. The last picture entry is the newest.
    case thought
}

struct StepRequest: Codable {
    var picture: [String]
    var done: [String]
    var current: String?
    var event: StepEvent
    /// Optional one word after Done, e.g. "scared", "easy", "rejected".
    var said: String?
}

struct StepResponse: Codable, Hashable {
    var step: String
}
