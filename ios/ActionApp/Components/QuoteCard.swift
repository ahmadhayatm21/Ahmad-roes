import SwiftUI

/// Words to say out loud.
struct QuoteCard: View {
    let label: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text("“\(text)”")
                .font(.title3.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    QuoteCard(label: "Say", text: "Hi, it's Sam. Got two minutes? I'll be quick.").padding()
}
