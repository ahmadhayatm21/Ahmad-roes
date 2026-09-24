import Foundation

/// Helpers the user can open without leaving the current step.
enum WalkSheet: String, Identifiable {
    case sayIt, objection, script

    var id: String { rawValue }
}
