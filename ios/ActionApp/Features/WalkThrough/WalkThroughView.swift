import SwiftUI

/// Shows one step at a time. The user does it in real life, taps NEXT, and the next step unlocks.
/// DONE on the last step asks "What happened?".
struct WalkThroughView: View {
    let mission: Mission
    /// The routine block this run belongs to, if started from the NOW screen.
    let routineItem: RoutineItem?

    @Environment(Router.self) private var router
    @State private var sheet: WalkSheet?

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

            StepToolsBar { sheet = $0 }

            PrimaryButton(isLast ? "DONE" : "NEXT") {
                advance(isLast: isLast)
            }
        }
        .padding(20)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                InMyHeadButton { sheet = .inMyHead }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button { sheet = .script } label: {
                        Label("Full script", systemImage: "doc.text")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityLabel("More")
            }
        }
        .sheet(item: $sheet) { sheet in
            switch sheet {
            case .sayIt:
                SayItView(context: mission.context, stepTitle: mission.step?.title)
            case .objection:
                ObjectionView(context: mission.context, stepTitle: mission.step?.title)
            case .script:
                ScriptView(context: mission.context, plan: mission.plan)
            case .inMyHead:
                InMyHeadView(task: routineItem?.title ?? mission.plan.title, step: mission.step?.title) {}
            }
        }
    }

    private func advance(isLast: Bool) {
        if isLast {
            router.push(.feedback(mission, routineItem))
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
