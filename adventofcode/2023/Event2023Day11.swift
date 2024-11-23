import Foundation

struct Event2023Day11 {
    static func part1(_ input: String) -> Int {
        compute(input, multiply: 2)
    }

    static func part2(_ input: String, multiply: Int) -> Int {
        compute(input, multiply: multiply)
    }

    private static func compute(_ input: String, multiply: Int) -> Int {
        let input = input.multi.map { $0.map { $0 }}
        var grid = Grid(input, empty: ".")

        let c = multiply - 1
        // vertical
        var x = grid.minX
        while x <= grid.maxX {
            if grid.nodes.filter({ $0.point.x == x }).isEmpty {
                let nodes = grid.nodes.filter { $0.point.x > x }
                for node in nodes {
                    grid.removeNode(at: node.point)
                    let point = node.point + Point(x: c, y: 0)
                    let node = Grid.Node(point: point, value: node.value)
                    grid.append(node)
                }
                x += c
            }
            x += 1
        }
        // horizontal
        var y = grid.minY
        while y <= grid.maxY {
            if grid.nodes.filter({ $0.point.y == y }).isEmpty {
                let nodes = grid.nodes.filter { $0.point.y > y }
                for node in nodes {
                    grid.removeNode(at: node.point)
                    let point = node.point + Point(x: 0, y: c)
                    let node = Grid.Node(point: point, value: node.value)
                    grid.append(node)
                }
                y += c
            }
            y += 1
        }

        var distances = [Int]()
        for i in 0..<grid.nodes.count - 1 {
            for j in i..<grid.nodes.count {
                let distance = manhattanDistance(grid.nodes[i].point, grid.nodes[j].point)
                distances.append(distance)
            }
        }
        let sum = distances.reduce(0, +)
        return sum
    }

}

private func manhattanDistance(_ s: Point, _ t: Point) -> Int {
    Int(abs(s.x - t.x) + abs(s.y - t.y))
}

