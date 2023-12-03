//

import Foundation

struct Grid<T: Equatable> {
    struct Node {
        let point: Point
        let value: T
    }

    var nodes = [Node]()

    init(_ input: [[T]], empty: T) {
        for (y, row) in input.enumerated() {
            for (x, value) in row.enumerated() where value != empty {
                let point = Point(x: x, y: y)
                let node = Node(point: point, value: value)
                nodes.append(node)
            }
        }
    }
}

extension Grid.Node {
    var adjacent: [Point] {
        point.cardinal + point.ordinal
    }
}
