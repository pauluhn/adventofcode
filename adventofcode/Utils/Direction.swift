import Foundation

enum Direction {
    case n
    case s
    case w
    case e
    case ne
    case se
    case sw
    case nw
}

extension Direction {
    static var cardinal: [Direction] { [.n, .s, .w, .e] }
    static var ordinal: [Direction] { [.ne, .se, .sw, .nw] }

    var offset: Point {
        switch self {
        case .n: Point(x: 0, y: -1)
        case .s: Point(x: 0, y: 1)
        case .w: Point(x: -1, y: 0)
        case .e: Point(x: 1, y: 0)
        case .ne: Point(x: 1, y: -1)
        case .se: Point(x: 1, y: 1)
        case .sw: Point(x: -1, y: 1)
        case .nw: Point(x: -1, y: -1)
        }
    }
}
