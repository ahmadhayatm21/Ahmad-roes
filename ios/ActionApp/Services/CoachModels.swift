import Foundation

// Request and response bodies for the backend. Field names match the JSON exactly.

struct FeedbackEntry: Codable, Hashable {
    var step: String
    var whatHappened: String
    var outcome: Outcome
}

struct GamePlanRequest: Codable {
    var goal: String
    var avoiding: String
    var mustDo: String
    var feedback: [FeedbackEntry]

    init(context: MissionContext, feedback: [FeedbackEntry] = []) {
        goal = context.goal
        avoiding = context.avoiding
        mustDo = context.mustDo
        self.feedback = feedback
    }

    var context: MissionContext { MissionContext(goal: goal, avoiding: avoiding, mustDo: mustDo) }
}

struct SayItRequest: Codable {
    var intent: String
    var context: MissionContext
    var step: String?
}

struct SayItResponse: Codable, Hashable {
    var line: String
}

struct ObjectionRequest: Codable {
    var objection: String
    var context: MissionContext
    var step: String?
}

struct ObjectionResponse: Codable, Hashable {
    var answer: String
}

struct PracticeRequest: Codable {
    var context: MissionContext
    var objection: String?
    var reply: String?
}

struct PracticeResponse: Codable, Hashable {
    /// A stronger way to say the user's reply. Empty on the first round.
    var better: String
    var nextObjection: String
}

struct ScriptRequest: Codable {
    var context: MissionContext
    var plan: GamePlan
}

struct ScriptResponse: Codable, Hashable {
    var sections: [ScriptSection]
}

struct ScriptSection: Codable, Hashable {
    var title: String
    var lines: [String]
}
