import Foundation

enum AppConfig {
    /// Base URL of the deployed backend, e.g. https://your-app.vercel.app.
    /// Leave nil to run fully on local sample data.
    static let backendURL: URL? = nil

    /// Must match the backend's APP_TOKEN when that is set.
    static let appToken: String? = nil
}
