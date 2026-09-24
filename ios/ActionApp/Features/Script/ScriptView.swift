import SwiftUI

/// The full script. Only shown when the user asks for it.
struct ScriptView: View {
    let context: MissionContext
    let plan: GamePlan

    @Environment(\.coach) private var coach
    @Environment(\.dismiss) private var dismiss

    @State private var sections: [ScriptSection] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    if sections.isEmpty && errorMessage == nil {
                        ProgressView().frame(maxWidth: .infinity).padding(.top, 40)
                    }
                    if let errorMessage { ErrorLine(message: errorMessage) }

                    ForEach(Array(sections.enumerated()), id: \.offset) { index, section in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(index + 1). \(section.title)")
                                .font(.headline)
                            ForEach(section.lines, id: \.self) { line in
                                Text(line)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .textSelection(.enabled)
            }
            .navigationTitle("Full script")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .task { await load() }
        }
    }

    private func load() async {
        do {
            sections = try await coach.script(ScriptRequest(context: context, plan: plan)).sections
        } catch {
            errorMessage = "Couldn't load the script."
        }
    }
}

#Preview {
    ScriptView(context: SampleContent.salesContext, plan: SampleContent.salesPlan)
}
