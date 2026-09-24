#if DEBUG
import SwiftData
import SwiftUI

/// In-memory sample data for SwiftUI previews.
@MainActor
enum PreviewData {
    static let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Mission.self, RoutineItem.self, ActionReport.self,
            configurations: config
        )
        let mission = Mission(context: SampleContent.salesContext, plan: SampleContent.salesPlan)
        container.mainContext.insert(mission)
        mission.routine = RoutineItem.items(from: SampleContent.salesPlan.dayPlan)
        return container
    }()

    static var mission: Mission {
        try! container.mainContext.fetch(FetchDescriptor<Mission>()).first!
    }
}
#endif
