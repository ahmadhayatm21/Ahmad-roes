import SwiftUI

/// Voice first: a big mic, with what the user said shown above it.
/// Typing is a small fallback. Speech is transcribed on device.
struct SpeakInput: View {
    @Binding var text: String
    let placeholder: String
    var micSize: CGFloat = 96
    /// Starts listening as soon as the view appears.
    var listensOnAppear = false

    @Environment(\.transcriber) private var transcriber
    @State private var isListening = false
    @State private var listenTask: Task<Void, Never>?
    @State private var isTyping = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 24) {
            if isTyping {
                TextField(placeholder, text: $text, axis: .vertical)
                    .font(.title3)
                    .lineLimit(3...8)
                    .focused($isFocused)
                    .padding(16)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            } else {
                ScrollView {
                    Text(text.isEmpty ? placeholder : text)
                        .font(.title3)
                        .foregroundStyle(text.isEmpty ? .secondary : .primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .defaultScrollAnchor(.bottom)
                .frame(minHeight: 60, maxHeight: 220)
            }

            Button(action: toggle) {
                Image(systemName: isListening ? "stop.fill" : "mic.fill")
                    .font(.system(size: micSize * 0.38, weight: .semibold))
                    .foregroundStyle(Color(.systemBackground))
                    .frame(width: micSize, height: micSize)
                    .background(isListening ? Color.red : Color.primary, in: Circle())
                    .symbolEffect(.pulse, isActive: isListening)
            }
            .accessibilityLabel(isListening ? "Stop listening" : "Speak")
            .sensoryFeedback(.impact, trigger: isListening)

            if !isTyping {
                Button("Type instead") {
                    stop()
                    isTyping = true
                    isFocused = true
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .onAppear { if listensOnAppear { start() } }
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
                isTyping = true
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
    SpeakInput(text: $text, placeholder: "Say it.").padding()
}
