import SwiftData
import SwiftUI

@main
struct ActionApp: App {
    // Its own store, so data from the old plan-based app is never migrated.
    private let container = try! ModelContainer(for: Journey.self, configurations: ModelConfiguration("Steps"))

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
