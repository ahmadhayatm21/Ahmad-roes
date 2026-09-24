import SwiftData
import SwiftUI

/// Three questions, then a game plan. Onboarding ends in real action.
struct StartFlowView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.coach) private var coach
    @Environment(Router.self) private var router

    @Query(sort: \ActionReport.createdAt, order: .reverse) private var reports: [ActionReport]

    @State private var index = 0
    @State private var answers = ["", "", ""]
    @State private var isBuilding = false
    @State private var errorMessage: String?

    private let questions = StartQuestion.all

    private var isLast: Bool { index == questions.count - 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            QuestionStepView(
                question: questions[index],
                number: index + 1,
                total: questions.count,
                answer: $answers[index],
                buttonTitle: isLast ? "Make my plan" : "Next",
                isLoading: isBuilding,
                onNext: next
            )
            .id(index)
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))

            if let errorMessage {
                ErrorLine(message: errorMessage)
            }
        }
        .padding(20)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if index > 0 && !isBuilding {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") { withAnimation { index -= 1 } }
                }
            }
        }
        .navigationBarBackButtonHidden(index > 0)
    }

    private func next() {
        if isLast {
            Task { await buildPlan() }
        } else {
            withAnimation(.snappy) { index += 1 }
        }
    }

    private func buildPlan() async {
        isBuilding = true
        errorMessage = nil
        let context = MissionContext(
            goal: answers[0].trimmingCharacters(in: .whitespacesAndNewlines),
            avoiding: answers[1].trimmingCharacters(in: .whitespacesAndNewlines),
            mustDo: answers[2].trimmingCharacters(in: .whitespacesAndNewlines)
        )
        let feedback = reports.prefix(5).map {
            FeedbackEntry(step: $0.stepTitle, whatHappened: $0.whatHappened, outcome: $0.outcome)
        }

        do {
            let plan = try await coach.gamePlan(GamePlanRequest(context: context, feedback: Array(feedback)))
            let mission = createMission(context: context, plan: plan)
            router.path = [.plan(mission)]
        } catch {
            errorMessage = "Couldn't make the plan. Tap again."
        }
        isBuilding = false
    }

    private func createMission(context: MissionContext, plan: GamePlan) -> Mission {
        let active = (try? modelContext.fetch(FetchDescriptor<Mission>(predicate: #Predicate { $0.isActive }))) ?? []
        active.forEach { $0.isActive = false }

        let mission = Mission(context: context, plan: plan)
        modelContext.insert(mission)

        var items = RoutineItem.items(from: plan.dayPlan)
        if items.isEmpty {
            let now = Calendar.current.dateComponents([.hour, .minute], from: .now)
            items = [RoutineItem(title: plan.title, minuteOfDay: (now.hour ?? 9) * 60 + (now.minute ?? 0))]
        }
        mission.routine = items
        return mission
    }
}
