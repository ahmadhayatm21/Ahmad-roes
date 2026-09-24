import SwiftUI

/// Opener, structure and one-line summary. Ends in LET'S DO IT.
struct GamePlanView: View {
    let mission: Mission

    @Environment(Router.self) private var router

    var body: some View {
        let plan = mission.plan

        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(plan.title)
                        .font(.largeTitle.bold())
                    Text(plan.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                QuoteCard(label: "Open with", text: plan.opener)

                PlanStructureList(steps: plan.steps)
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton("LET'S DO IT") {
                mission.currentStep = 0
                router.push(.walk(mission, nil))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            .background(.bar)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        GamePlanView(mission: PreviewData.mission)
    }
    .modelContainer(PreviewData.container)
    .environment(Router())
}
#endif
