import SwiftUI

/// Shows one step at a time. The user does it in real life, taps NEXT, and the next step unlocks.
struct WalkThroughView: View {
    let mission: Mission
    /// The routine block this run belongs to, if started from the NOW screen.
    let routineItem: RoutineItem?

    @Environment(Router.self) private var router

    var body: some View {
        let steps = mission.plan.steps
        let index = min(max(mission.currentStep, 0), max(steps.count - 1, 0))
        let isLast = index >= steps.count - 1

        VStack(alignment: .leading, spacing: 24) {
            StepProgressView(current: index, total: steps.count)

            if let step = mission.step {
                StepCardView(step: step)
                    .id(index)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
            }

            Spacer()

            PrimaryButton(isLast ? "DONE" : "NEXT") {
                advance(isLast: isLast)
            }
        }
        .padding(20)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(mission.plan.title)
    }

    private func advance(isLast: Bool) {
        if isLast {
            mission.currentStep = 0
            routineItem?.lastDoneAt = .now
            router.popToRoot()
        } else {
            withAnimation(.snappy) { mission.currentStep += 1 }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        WalkThroughView(mission: PreviewData.mission, routineItem: nil)
    }
    .modelContainer(PreviewData.container)
    .environment(Router())
}
#endif
