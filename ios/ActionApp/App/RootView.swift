import SwiftData
import SwiftUI

struct RootView: View {
    @Query(filter: #Predicate<Mission> { $0.isActive }, sort: \Mission.createdAt, order: .reverse)
    private var missions: [Mission]

    @State private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if let mission = missions.first {
                    GamePlanView(mission: mission)
                } else {
                    StartFlowView()
                }
            }
            .navigationDestination(for: Route.self, destination: destination)
        }
        .environment(router)
    }

    @ViewBuilder
    private func destination(_ route: Route) -> some View {
        switch route {
        case .start:
            StartFlowView()
        case .plan(let mission):
            GamePlanView(mission: mission)
        case .walk:
            Text("Walk-through")
        }
    }
}
