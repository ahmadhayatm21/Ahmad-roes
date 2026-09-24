import SwiftUI

/// A text field with a mic button. Speech is transcribed on device.
struct VoiceTextField: View {
    let prompt: String
    @Binding var text: String

    @Environment(\.transcriber) private var transcriber
    @State private var isListening = false
    @State private var listenTask: Task<Void, Never>?
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            TextField(prompt, text: $text, axis: .vertical)
                .font(.title3)
                .lineLimit(2...6)
                .focused($isFocused)

            Button(action: toggle) {
                Image(systemName: isListening ? "stop.circle.fill" : "mic.circle.fill")
                    .font(.system(size: 34))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(isListening ? Color.red : Color.primary)
                    .symbolEffect(.pulse, isActive: isListening)
            }
            .accessibilityLabel(isListening ? "Stop listening" : "Speak")
        }
        .padding(16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .onDisappear(perform: stop)
    }

    private func toggle() {
        isListening ? stop() : start()
    }

    private func start() {
        isFocused = false
        isListening = true
        let base = text.trimmingCharacters(in: .whitespacesAndNewlines)
        listenTask = Task {
            do {
                for try await partial in transcriber.transcribe() {
                    text = base.isEmpty ? partial : base + " " + partial
                }
            } catch {
                // Mic or speech permission denied: typing still works.
            }
            isListening = false
        }
    }

    private func stop() {
        listenTask?.cancel()
        listenTask = nil
        transcriber.stop()
        isListening = false
    }
}

#Preview {
    @Previewable @State var text = ""
    VoiceTextField(prompt: "Say it or type it", text: $text).padding()
}
