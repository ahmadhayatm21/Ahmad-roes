import SwiftData
import SwiftUI

/// First run: tell. After that: one step.
struct RootView: View {
    @Query(sort: \Journey.createdAt, order: .reverse) private var journeys: [Journey]

    var body: some View {
        if let journey = journeys.first {
            StepView(journey: journey)
        } else {
            TellView()
        }
    }
}
