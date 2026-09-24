import SwiftUI

private struct CoachServiceKey: EnvironmentKey {
    static let defaultValue: any CoachService = CoachServiceFactory.make()
}

private struct SpeechTranscriberKey: EnvironmentKey {
    static let defaultValue: any SpeechTranscriber = AppleSpeechTranscriber()
}

extension EnvironmentValues {
    var coach: any CoachService {
        get { self[CoachServiceKey.self] }
        set { self[CoachServiceKey.self] = newValue }
    }

    var transcriber: any SpeechTranscriber {
        get { self[SpeechTranscriberKey.self] }
        set { self[SpeechTranscriberKey.self] = newValue }
    }
}
