import Foundation

/// One of the three onboarding questions.
struct StartQuestion {
    let title: String
    let placeholder: String

    static let all = [
        StartQuestion(title: "What do you want to achieve?", placeholder: "Close 3 new clients this month"),
        StartQuestion(title: "What are you avoiding?", placeholder: "Calling people I don't know"),
        StartQuestion(title: "What do you have to do?", placeholder: "Call 20 local gyms today"),
    ]
}
