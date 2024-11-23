//

import Foundation

struct Grid<T: Equatable> {
    struct Node {
        let point: Point
        var value: T
    }

    var nodes = [Node]()
    private(set) var minX: Int = 0
    private(set) var maxX: Int = 0
    private(set) var minY: Int = 0
    private(set) var maxY: Int = 0

    init(_ input: [[T]], empty: T? = nil) {
        for (y, row) in input.enumerated() {
            for (x, value) in row.enumerated() where value != empty {
                let point = Point(x: x, y: y)
                let node = Node(point: point, value: value)
                nodes.append(node)

                minX = min(minX, x)
                maxX = max(maxX, x)
                minY = min(minY, y)
                maxY = max(maxY, y)
            }
        }
    }

    init(_ nodes: [Node]) {
        self.nodes = nodes

        minX = nodes.map { $0.point.x }.min()!
        maxX = nodes.map { $0.point.x }.max()!
        minY = nodes.map { $0.point.y }.min()!
        maxY = nodes.map { $0.point.y }.max()!
    }

    mutating func append(_ node: Node) {
        guard self.node(for: node.point) == nil else { return }
        nodes.append(node)

        minX = min(minX, node.point.x)
        maxX = max(maxX, node.point.x)
        minY = min(minY, node.point.y)
        maxY = max(maxY, node.point.y)
    }

    func node(for point: Point) -> Node? {
        nodes.first(where: { $0.point == point })
    }

    mutating func set(_ node: Node, to point: Point) {
        guard let index = nodes.firstIndex(where: { $0.point == point }) else { return }
        nodes[index] = node
    }
}

extension Grid.Node {
    var adjacent: [Point] {
        point.cardinal + point.ordinal
    }
}

extension Grid: CustomStringConvertible {
    var description: String {
        var description = ""
        let xs = nodes.map { $0.point.x }
        let ys = nodes.map { $0.point.y }
        for y in (ys.min()!...ys.max()!) {
            for x in xs.min()!...xs.max()! {
                if let node = self.node(for: .init(x: x, y: y)) {
                    description += "\(node.value)".first!.str
                } else {
                    description += "."
                }
            }
            description += "\n"
        }
        return description
    }
}
