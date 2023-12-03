//

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
    
    func offset(_ direction: Direction) -> Point {
        self + direction.offset
    }
}
