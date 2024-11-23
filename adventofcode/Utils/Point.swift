import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

extension Point {
    var cardinal: [Point] { Direction.cardinal.map { offset($0) }}
    var ordinal: [Point] { Direction.ordinal.map { offset($0) }}

    static func +(lhs: Point, rhs: Point) -> Point {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func *(lhs: Point, rhs: Int) -> Point {
        .init(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func /(lhs: Point, rhs: Int) -> Point {
        .init(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    func offset(_ direction: Direction) -> Point {
        self + direction.offset
    }
}
