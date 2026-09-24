import Foundation

/// Backend settings, read from Info.plist. The values come from ios/Config/Secrets.xcconfig.
enum AppConfig {
    /// Base URL of the deployed backend. Nil runs fully on local sample data.
    static let backendURL: URL? = infoValue("ActionBackendHost").flatMap { URL(string: "https://\($0)") }

    /// Must match the backend's APP_TOKEN when that is set.
    static let appToken: String? = infoValue("ActionAppToken")

    private static func infoValue(_ key: String) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
