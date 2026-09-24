import SwiftData
import SwiftUI

@main
struct ActionApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Mission.self, RoutineItem.self, ActionReport.self])
    }
}
