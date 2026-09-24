import SwiftUI

struct GamePlanView: View {
    let mission: Mission

    var body: some View {
        Text(mission.plan.summary)
            .padding()
            .navigationTitle(mission.plan.title)
    }
}
