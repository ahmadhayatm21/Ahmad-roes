import SwiftUI

/// Quiet helpers under the step. They never compete with NEXT.
struct StepToolsBar: View {
    let onSelect: (WalkSheet) -> Void

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 10) { buttons }
            VStack(alignment: .leading, spacing: 10) { buttons }
        }
        .buttonStyle(.quiet)
    }

    @ViewBuilder
    private var buttons: some View {
        Button { onSelect(.sayIt) } label: {
            Label("How do I say this?", systemImage: "text.bubble")
        }
        Button { onSelect(.objection) } label: {
            Label("I got an objection", systemImage: "hand.raised")
        }
    }
}
