import Foundation
import SwiftData

/// The user's answer to "What happened?" after an action.
@Model
final class ActionReport {
    var createdAt: Date
    var stepTitle: String
    var whatHappened: String
    var outcomeRaw: String
    var mission: Mission?

    init(stepTitle: String, whatHappened: String, outcome: Outcome) {
        createdAt = .now
        self.stepTitle = stepTitle
        self.whatHappened = whatHappened
        outcomeRaw = outcome.rawValue
    }

    var outcome: Outcome {
        get { Outcome(rawValue: outcomeRaw) ?? .did }
        set { outcomeRaw = newValue.rawValue }
    }
}

enum Outcome: String, Codable, CaseIterable, Identifiable {
    case did, partly, didnt

    var id: String { rawValue }

    var label: String {
        switch self {
        case .did: "I did it"
        case .partly: "Partly"
        case .didnt: "Not yet"
        }
    }
}
