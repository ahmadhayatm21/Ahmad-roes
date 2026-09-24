import Foundation

/// Hand-written sample plans, objections and lines.
enum SampleContent {
    enum Kind { case sales, door, general }

    static func kind(of context: MissionContext) -> Kind {
        let text = "\(context.goal) \(context.avoiding) \(context.mustDo)".lowercased()
        if ["door", "knock", "canvass", "d2d"].contains(where: { text.contains($0) }) { return .door }
        if ["sell", "sale", "client", "customer", "call", "prospect", "deal", "lead"].contains(where: { text.contains($0) }) {
            return .sales
        }
        return .general
    }

    // MARK: Game plans

    static func plan(for context: MissionContext) -> GamePlan {
        switch kind(of: context) {
        case .sales: salesPlan
        case .door: doorPlan
        case .general: generalPlan(mustDo: context.mustDo)
        }
    }

    static let salesContext = MissionContext(
        goal: "Close 3 new clients this month",
        avoiding: "Calling people I don't know",
        mustDo: "Call 20 local gyms today"
    )

    static let salesPlan = GamePlan(
        title: "Make the calls",
        opener: "Hi, it's [your name]. Got two minutes? I'll be quick.",
        steps: [
            PlanStep(
                title: "Opener",
                action: "Dial the first number. Say the first line before you think.",
                firstLine: "Hi, it's [your name]. Got two minutes? I'll be quick."
            ),
            PlanStep(
                title: "Product with emotion",
                action: "Say the one thing it changes for them. How it feels, not what it is.",
                firstLine: "Most owners I talk to are tired of chasing members who stop showing up."
            ),
            PlanStep(
                title: "Logic",
                action: "Give one number. Then stop talking.",
                firstLine: "Gyms using it keep about one in five members they'd have lost."
            ),
            PlanStep(
                title: "Close or book",
                action: "Ask for the yes or for a meeting. Then stay quiet.",
                firstLine: "Want to try it this month, or should we book 20 minutes Thursday?"
            ),
            PlanStep(
                title: "Follow-up if no",
                action: "Get a date for the next touch. Write it down.",
                firstLine: "No problem. Can I check back with you next Tuesday?"
            ),
        ],
        summary: "Opener → Product with emotion → Logic → Close or book → Follow-up",
        dayPlan: [
            DayBlock(time: "09:00", title: "First 10 calls"),
            DayBlock(time: "11:00", title: "Follow-ups from yesterday"),
            DayBlock(time: "14:00", title: "Next 10 calls"),
            DayBlock(time: "16:30", title: "Log what happened"),
        ]
    )

    static let doorPlan = GamePlan(
        title: "Knock on doors",
        opener: "Hi, I'm [your name]. I'm working with a few of your neighbours on this street today.",
        steps: [
            PlanStep(
                title: "Knock",
                action: "Walk up. Knock twice. Step back one pace and smile.",
                firstLine: ""
            ),
            PlanStep(
                title: "Opener",
                action: "Say the first line as the door opens.",
                firstLine: "Hi, I'm [your name]. I'm working with a few of your neighbours on this street today."
            ),
            PlanStep(
                title: "Product with emotion",
                action: "Say what it changes for their home. Keep it to one sentence.",
                firstLine: "Most people here were sick of the bill going up every winter."
            ),
            PlanStep(
                title: "Logic",
                action: "One number, one proof. Point at a neighbour's house if you can.",
                firstLine: "The Smiths at number 12 cut theirs by about a third."
            ),
            PlanStep(
                title: "Close or book",
                action: "Ask for the yes or a time to come back.",
                firstLine: "Can I take a quick look now, or is Saturday morning better?"
            ),
            PlanStep(
                title: "Follow-up if no",
                action: "Leave the card. Note the house number and walk to the next door.",
                firstLine: "No worries. I'll leave this here. I'm back on the street next week."
            ),
        ],
        summary: "Knock → Opener → Product with emotion → Logic → Close or book → Follow-up",
        dayPlan: [
            DayBlock(time: "10:00", title: "First street: 20 doors"),
            DayBlock(time: "12:30", title: "Second street: 20 doors"),
            DayBlock(time: "15:00", title: "Callbacks from yesterday"),
            DayBlock(time: "17:30", title: "Evening round, people are home"),
        ]
    )

    static func generalPlan(mustDo: String) -> GamePlan {
        GamePlan(
            title: "Do it now",
            opener: "Open it and do the first visible piece.",
            steps: [
                PlanStep(
                    title: "Set up",
                    action: "Open only what you need for this. Close everything else.",
                    firstLine: ""
                ),
                PlanStep(
                    title: "First move",
                    action: mustDo,
                    firstLine: ""
                ),
                PlanStep(
                    title: "Keep going",
                    action: "Push through the next 10 minutes. Imperfect is fine.",
                    firstLine: ""
                ),
                PlanStep(
                    title: "Send or ask",
                    action: "Send it, show it, or ask the one person you need.",
                    firstLine: "Here's where I'm at. Can you look at it today?"
                ),
                PlanStep(
                    title: "Next touch",
                    action: "Put the next move in your calendar before you close this.",
                    firstLine: ""
                ),
            ],
            summary: "Set up → First move → Keep going → Send or ask → Next touch",
            dayPlan: [
                DayBlock(time: "09:00", title: "First move"),
                DayBlock(time: "13:00", title: "Second push"),
                DayBlock(time: "17:00", title: "Send it"),
            ]
        )
    }

    // MARK: Objections

    static func objections(for context: MissionContext) -> [String] {
        switch kind(of: context) {
        case .door:
            [
                "We're not interested, thanks.",
                "I'm busy right now.",
                "We already have someone for that.",
                "How much does it cost?",
                "Just leave a leaflet.",
                "I need to talk to my partner first.",
            ]
        case .sales:
            [
                "It's too expensive.",
                "Send me an email.",
                "We're already using something.",
                "I need to think about it.",
                "Now's not a good time.",
                "I'm not the one who decides.",
            ]
        case .general:
            [
                "This isn't ready yet.",
                "Can we do this next week?",
                "I'm not sure it's a good idea.",
                "Why should I care?",
            ]
        }
    }

    static func answer(to objection: String) -> String {
        let text = objection.lowercased()
        let answers: [([String], String)] = [
            (["expensive", "price", "cost", "afford", "money"],
             "Fair. If it paid for itself in a month, would it still feel expensive?"),
            (["think about", "think it over", "consider"],
             "Sure. What's the part you want to think over? Let's look at it now."),
            (["not interested", "no thanks", "no thank"],
             "No problem. Quick question before I go: how are you handling it right now?"),
            (["busy", "time", "not a good"],
             "I'll be thirty seconds. If it's not for you, I'm gone."),
            (["already", "using", "someone for"],
             "Good. If you could change one thing about it, what would it be?"),
            (["email", "leaflet", "info", "brochure"],
             "Happy to. What should it answer so it's worth opening?"),
            (["partner", "wife", "husband", "boss", "decide", "decides"],
             "Makes sense. When are you both around? I'll come back then."),
            (["ready", "next week", "later"],
             "It doesn't need to be ready. Show the rough version today."),
        ]
        for (keys, reply) in answers where keys.contains(where: { text.contains($0) }) {
            return reply
        }
        return "Got it. What would make this a yes for you?"
    }

    // MARK: Lines and scripts

    /// Turns a messy intent into one clean spoken line.
    static func cleanLine(from intent: String) -> String {
        var text = " " + intent.trimmingCharacters(in: .whitespacesAndNewlines) + " "
        let fillers = [
            "um", "uh", "like", "i guess", "kind of", "sort of", "basically", "maybe",
            "i want to say that", "i want to say", "i need to tell them that", "i need to tell them",
            "i want to tell them that", "i want to tell them", "just",
        ]
        for filler in fillers {
            text = text.replacingOccurrences(of: " \(filler) ", with: " ", options: .caseInsensitive)
        }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines.union(.punctuationCharacters))
        guard let first = trimmed.first else { return "Say it plainly, then ask a question." }
        return first.uppercased() + String(trimmed.dropFirst()) + ". What do you think?"
    }

    static func script(for plan: GamePlan) -> ScriptResponse {
        ScriptResponse(sections: plan.steps.map { step in
            var lines: [String] = []
            if !step.firstLine.isEmpty { lines.append(step.firstLine) }
            lines.append(followUpLine(for: step.title))
            return ScriptSection(title: step.title, lines: lines)
        })
    }

    private static func followUpLine(for title: String) -> String {
        switch title.lowercased() {
        case let t where t.contains("opener"): "I'm calling because I think I can help with something you deal with every week."
        case let t where t.contains("emotion"): "It's the thing that keeps you up at night. This takes it off your plate."
        case let t where t.contains("logic"): "It takes a day to set up, and you'll see the difference in the first month."
        case let t where t.contains("close"): "What would stop you from starting this week?"
        case let t where t.contains("follow"): "I'll put it in my calendar now. Talk then."
        case let t where t.contains("knock"): "(Wait. Count to five. Knock once more if no one comes.)"
        default: "Keep it short. Then ask a question."
        }
    }
}
