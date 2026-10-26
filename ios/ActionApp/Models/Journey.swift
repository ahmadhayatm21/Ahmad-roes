import Foundation
import SwiftData

/// The user's picture of their business and the one step they're on.
/// The app keeps the process here; the user only ever sees `step`.
@Model
final class Journey {
    var createdAt: Date
    /// How the user sees their business, its process and who they'll be. Their words, oldest first.
    var picture: [String]
    /// The one step on screen.
    var step: String
    /// Steps already done, oldest first. Never shown.
    var done: [String]

    init(picture: String, step: String) {
        createdAt = .now
        self.picture = [picture]
        self.step = step
        done = []
    }

    /// A request about the step on screen, trimmed to what the backend accepts.
    func request(_ event: StepEvent, said: String? = nil) -> StepRequest {
        StepRequest(
            picture: picture.suffix(30).map { String($0.prefix(4000)) },
            done: done.suffix(30).map { String($0.prefix(300)) },
            current: String(step.prefix(300)),
            event: event,
            said: said.map { String($0.prefix(200)) }
        )
    }
}
