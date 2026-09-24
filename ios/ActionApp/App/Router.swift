import Observation
import SwiftUI

enum Route: Hashable {
    case start
    case plan(Mission)
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
