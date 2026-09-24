import Foundation
import SwiftData

/// One goal the user is acting on, with its game plan and progress.
@Model
final class Mission {
    var goal: String
    var avoiding: String
    var mustDo: String
    var createdAt: Date
    var isActive: Bool
    /// Index of the step the user is on in the walk-through.
    var currentStep: Int
    var planData: Data

    @Relationship(deleteRule: .cascade, inverse: \RoutineItem.mission)
    var routine: [RoutineItem] = []

    @Relationship(deleteRule: .cascade, inverse: \ActionReport.mission)
    var reports: [ActionReport] = []

    init(context: MissionContext, plan: GamePlan) {
        goal = context.goal
        avoiding = context.avoiding
        mustDo = context.mustDo
        createdAt = .now
        isActive = true
        currentStep = 0
        planData = (try? JSONEncoder().encode(plan)) ?? Data()
    }

    var context: MissionContext {
        MissionContext(goal: goal, avoiding: avoiding, mustDo: mustDo)
    }

    var plan: GamePlan {
        get { (try? JSONDecoder().decode(GamePlan.self, from: planData)) ?? .empty }
        set { planData = (try? JSONEncoder().encode(newValue)) ?? planData }
    }

    /// The current step, clamped to the plan.
    var step: PlanStep? {
        let steps = plan.steps
        guard !steps.isEmpty else { return nil }
        return steps[min(max(currentStep, 0), steps.count - 1)]
    }
}
