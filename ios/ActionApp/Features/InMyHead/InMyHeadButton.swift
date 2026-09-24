import SwiftUI

/// Available on the NOW screen and during the walk-through.
struct InMyHeadButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("I'm in my head", systemImage: "brain.head.profile")
                .labelStyle(.titleAndIcon)
                .font(.subheadline.weight(.medium))
        }
        .buttonStyle(.quiet)
    }
}
