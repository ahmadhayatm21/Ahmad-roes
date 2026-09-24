import Foundation
import SwiftData

/// One block of the daily structure, e.g. "09:00 First 10 calls".
@Model
final class RoutineItem {
    var title: String
    var minuteOfDay: Int
    var lastDoneAt: Date?
    var mission: Mission?

    init(title: String, minuteOfDay: Int) {
        self.title = title
        self.minuteOfDay = minuteOfDay
    }

    func isDone(on date: Date, calendar: Calendar = .current) -> Bool {
        guard let lastDoneAt else { return false }
        return calendar.isDate(lastDoneAt, inSameDayAs: date)
    }

    var timeLabel: String {
        let date = Calendar.current.date(
            bySettingHour: minuteOfDay / 60, minute: minuteOfDay % 60, second: 0, of: .now
        )
        return date?.formatted(date: .omitted, time: .shortened) ?? ""
    }
}

extension RoutineItem {
    /// Turns the plan's day blocks into routine items. Blocks with unreadable times are skipped.
    static func items(from blocks: [DayBlock]) -> [RoutineItem] {
        blocks.compactMap { block in
            minute(from: block.time).map { RoutineItem(title: block.title, minuteOfDay: $0) }
        }
    }

    /// Parses "HH:mm" into minutes after midnight.
    static func minute(from time: String) -> Int? {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2, (0..<24).contains(parts[0]), (0..<60).contains(parts[1]) else { return nil }
        return parts[0] * 60 + parts[1]
    }
}
