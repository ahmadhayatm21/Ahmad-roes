import SwiftUI

/// Shows one question at a time with voice or text input.
struct QuestionStepView: View {
    let question: StartQuestion
    let number: Int
    let total: Int
    @Binding var answer: String
    let buttonTitle: String
    var isLoading = false
    let onNext: () -> Void

    private var isEmpty: Bool {
        answer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("\(number) of \(total)")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(question.title)
                .font(.largeTitle.bold())
                .fixedSize(horizontal: false, vertical: true)

            VoiceTextField(prompt: question.placeholder, text: $answer)

            Spacer()

            PrimaryButton(buttonTitle, isLoading: isLoading, action: onNext)
                .disabled(isEmpty)
        }
    }
}
