import Observation
import SwiftUI

enum Route: Hashable {
    case start
    case plan(Mission)
    case walk(Mission, RoutineItem?)
    case practice(Mission)
}

@Observable
final class Router {
    var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func popToRoot() {
        path.removeAll()
    }
}
