import AVFoundation
import Speech

/// On-device speech-to-text with Apple's Speech framework.
final class AppleSpeechTranscriber: SpeechTranscriber {
    private let recognizer = SFSpeechRecognizer(locale: .current)
    private let engine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    func transcribe() -> AsyncThrowingStream<String, Error> {
        stop()
        return AsyncThrowingStream { continuation in
            continuation.onTermination = { [weak self] _ in self?.stop() }
            Task { @MainActor in
                guard await Self.authorize() else {
                    continuation.finish(throwing: SpeechError.notAuthorized)
                    return
                }
                do {
                    try self.start(continuation)
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    func stop() {
        if engine.isRunning {
            engine.stop()
            engine.inputNode.removeTap(onBus: 0)
        }
        request?.endAudio()
        task?.finish()
        request = nil
        task = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    private func start(_ continuation: AsyncThrowingStream<String, Error>.Continuation) throws {
        guard let recognizer, recognizer.isAvailable else { throw SpeechError.unavailable }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        if recognizer.supportsOnDeviceRecognition {
            request.requiresOnDeviceRecognition = true
        }

        let input = engine.inputNode
        input.installTap(onBus: 0, bufferSize: 1024, format: input.outputFormat(forBus: 0)) { buffer, _ in
            request.append(buffer)
        }
        engine.prepare()
        try engine.start()

        self.request = request
        task = recognizer.recognitionTask(with: request) { result, error in
            if let result {
                continuation.yield(result.bestTranscription.formattedString)
                if result.isFinal { continuation.finish() }
            } else if error != nil {
                continuation.finish()
            }
        }
    }

    private static func authorize() async -> Bool {
        let status = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { continuation.resume(returning: $0) }
        }
        guard status == .authorized else { return false }
        return await AVAudioApplication.requestRecordPermission()
    }
}
