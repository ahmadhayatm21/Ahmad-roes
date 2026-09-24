import SwiftUI

/// A short, calm error message.
struct ErrorLine: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "exclamationmark.circle")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
}
