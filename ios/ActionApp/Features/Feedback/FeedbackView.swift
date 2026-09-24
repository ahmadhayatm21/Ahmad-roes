import SwiftData
import SwiftUI

/// "What happened?" after an action. The answer shapes the next plan.
struct FeedbackView: View {
    let mission: Mission
    let routineItem: RoutineItem?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.coach) private var coach
    @Environment(Router.self) private var router

    @State private var outcome: Outcome?
    @State private var whatHappened = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("What happened?")
                    .font(.largeTitle.bold())

                OutcomePicker(selection: $outcome)

                VoiceTextField(prompt: "They said no to price. Two booked a call.", text: $whatHappened)
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton("Next") { save() }
                .disabled(outcome == nil)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }

    private func save() {
        guard let outcome else { return }
        let report = ActionReport(
            stepTitle: mission.plan.title,
            whatHappened: whatHappened.trimmingCharacters(in: .whitespacesAndNewlines),
            outcome: outcome
        )
        modelContext.insert(report)
        report.mission = mission
        routineItem?.lastDoneAt = .now
        mission.currentStep = 0

        refreshPlan()
        router.popToRoot()
    }

    /// Rebuilds the steps in the background using the latest feedback. The routine stays as it is.
    private func refreshPlan() {
        let recent = mission.reports
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(5)
            .map { FeedbackEntry(step: $0.stepTitle, whatHappened: $0.whatHappened, outcome: $0.outcome) }
        let request = GamePlanRequest(context: mission.context, feedback: Array(recent))
        let mission = mission
        let coach = coach
        Task {
            guard let plan = try? await coach.gamePlan(request), !plan.steps.isEmpty else { return }
            var updated = mission.plan
            updated.opener = plan.opener
            updated.steps = plan.steps
            updated.summary = plan.summary
            mission.plan = updated
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        FeedbackView(mission: PreviewData.mission, routineItem: nil)
    }
    .modelContainer(PreviewData.container)
    .environment(Router())
}
#endif
