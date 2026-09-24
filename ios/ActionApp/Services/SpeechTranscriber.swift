import Foundation

/// Turns live speech into text.
///
/// Returns a stream of partial transcripts so a future live microphone coach
/// can consume the same stream while the user talks at the door.
protocol SpeechTranscriber: AnyObject {
    func transcribe() -> AsyncThrowingStream<String, Error>
    func stop()
}

enum SpeechError: Error {
    case notAuthorized
    case unavailable
}
