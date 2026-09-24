import SwiftUI

/// Quiet helpers under the step. They never compete with NEXT.
struct StepToolsBar: View {
    let onSelect: (WalkSheet) -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button { onSelect(.sayIt) } label: {
                Label("How do I say this?", systemImage: "text.bubble")
            }
        }
        .buttonStyle(.quiet)
    }
}
