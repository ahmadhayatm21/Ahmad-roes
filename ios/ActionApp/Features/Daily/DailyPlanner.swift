import Foundation

/// Picks what to do now from today's routine.
///
/// Missed blocks are skipped silently: the user always sees the next thing, never a backlog.
enum DailyPlanner {
    /// The most recent block that has started and isn't done. Before the first block starts, the first block.
    static func current(in items: [RoutineItem], at date: Date, calendar: Calendar = .current) -> RoutineItem? {
        let pending = pendingItems(in: items, at: date, calendar: calendar)
        let minute = minuteOfDay(date, calendar: calendar)
        return pending.last { $0.minuteOfDay <= minute } ?? pending.first
    }

    /// The pending block after `item`, shown as a quiet "Then" line.
    static func upcoming(after item: RoutineItem, in items: [RoutineItem], at date: Date, calendar: Calendar = .current) -> RoutineItem? {
        pendingItems(in: items, at: date, calendar: calendar).first { $0.minuteOfDay > item.minuteOfDay }
    }

    private static func pendingItems(in items: [RoutineItem], at date: Date, calendar: Calendar) -> [RoutineItem] {
        items
            .filter { !$0.isDone(on: date, calendar: calendar) }
            .sorted { $0.minuteOfDay < $1.minuteOfDay }
    }

    private static func minuteOfDay(_ date: Date, calendar: Calendar) -> Int {
        let parts = calendar.dateComponents([.hour, .minute], from: date)
        return (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
    }
}
