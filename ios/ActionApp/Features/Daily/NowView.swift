import SwiftUI

/// Opening the app shows what to do now. One thing, one button.
struct NowView: View {
    let mission: Mission

    @Environment(Router.self) private var router
    @State private var showInMyHead = false

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { timeline in
            let item = DailyPlanner.current(in: mission.routine, at: timeline.date)
            let then = item.flatMap { DailyPlanner.upcoming(after: $0, in: mission.routine, at: timeline.date) }

            VStack(alignment: .leading, spacing: 16) {
                Text("Now")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                if let item {
                    Text(item.title)
                        .font(.largeTitle.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(item.timeLabel) · \(mission.plan.title)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Today's list is done.")
                        .font(.largeTitle.bold())
                    Text("Go one more round while you're warm.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let step = mission.step, mission.currentStep > 0 {
                    Label("You're on: \(step.title)", systemImage: "arrow.turn.down.right")
                        .font(.subheadline)
                }

                Spacer()

                if let then {
                    Text("Then \(then.timeLabel): \(then.title)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                PrimaryButton(item == nil ? "ONE MORE ROUND" : "DO IT") {
                    router.push(.walk(mission, item))
                }
            }
            .padding(20)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Button { router.push(.plan(mission)) } label: {
                        Label("Game plan", systemImage: "list.number")
                    }
                    Button { router.push(.practice(mission)) } label: {
                        Label("Practice objections", systemImage: "figure.boxing")
                    }
                    Button { router.push(.start) } label: {
                        Label("New goal", systemImage: "plus")
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
                .accessibilityLabel("Menu")
            }
            ToolbarItem(placement: .topBarTrailing) {
                InMyHeadButton { showInMyHead = true }
            }
        }
        .sheet(isPresented: $showInMyHead) {
            let item = DailyPlanner.current(in: mission.routine, at: .now)
            InMyHeadView(task: item?.title ?? mission.plan.title, step: mission.step?.title) {
                router.push(.walk(mission, item))
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        NowView(mission: PreviewData.mission)
    }
    .modelContainer(PreviewData.container)
    .environment(Router())
}
#endif
