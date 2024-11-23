import Foundation

struct Event2023Day14 {
    static func part1(_ input: String) -> Int {
        var grid = Grid(input.gridInput, empty: ".")
        rollN(grid: &grid)
        return load(grid: grid)
    }

    static func part2(_ input: String) -> Int {
        var grid = Grid(input.gridInput, empty: ".")
        var repeater = Repeat()

        let cycles = 1000000000
        for i in 0..<cycles {
            rollN(grid: &grid)
            rollW(grid: &grid)
            rollS(grid: &grid)
            rollE(grid: &grid)

            let seq = repeater.add(load: load(grid: grid))
            if seq.count > 2 {
                let length = cycles - i - 1
                let offset = length % seq.count
                return seq[offset - 1]
            }
        }
        fatalError()
    }

    private static func rollN(grid: inout Grid<Character>) {
        let roundedRocks = grid.nodes
            .filter { $0.value == "O" }
            .sorted { $0.point.y < $1.point.y }
        for r in roundedRocks {
            var p = r.point
            loop: for y in (grid.minY..<p.y).reversed() {
                let n = Point(x: p.x, y: y)
                if grid.node(for: n) == nil {
                    p = n
                } else {
                    break loop
                }
            }
            grid.removeNode(at: r.point)
            grid.append(.init(point: p, value: "O"))
        }
    }

    private static func rollS(grid: inout Grid<Character>) {
        let roundedRocks = grid.nodes
            .filter { $0.value == "O" }
            .sorted { $0.point.y > $1.point.y }
        for r in roundedRocks {
            var p = r.point
            if p.y + 1 > grid.maxY {
                continue
            }
            loop: for y in (p.y + 1) ... grid.maxY {
                let n = Point(x: p.x, y: y)
                if grid.node(for: n) == nil {
                    p = n
                } else {
                    break loop
                }
            }
            grid.removeNode(at: r.point)
            grid.append(.init(point: p, value: "O"))
        }
    }

    private static func rollW(grid: inout Grid<Character>) {
        let roundedRocks = grid.nodes
            .filter { $0.value == "O" }
            .sorted { $0.point.x < $1.point.x }
        for r in roundedRocks {
            var p = r.point
            loop: for x in (grid.minX..<p.x).reversed() {
                let n = Point(x: x, y: p.y)
                if grid.node(for: n) == nil {
                    p = n
                } else {
                    break loop
                }
            }
            grid.removeNode(at: r.point)
            grid.append(.init(point: p, value: "O"))
        }
    }

    private static func rollE(grid: inout Grid<Character>) {
        let roundedRocks = grid.nodes
            .filter { $0.value == "O" }
            .sorted { $0.point.x > $1.point.x }
        for r in roundedRocks {
            var p = r.point
            if p.x + 1 > grid.maxX {
                continue
            }
            loop: for x in (p.x + 1) ... grid.maxX {
                let n = Point(x: x, y: p.y)
                if grid.node(for: n) == nil {
                    p = n
                } else {
                    break loop
                }
            }
            grid.removeNode(at: r.point)
            grid.append(.init(point: p, value: "O"))
        }
    }

    private static func load(grid: Grid<Character>) -> Int {
        return grid.nodes
            .filter { $0.value == "O" }
            .reduce(0) { $0 + grid.maxY - $1.point.y + 1 }
    }
}

private struct Repeat {
    private var loads: [Int] = []

    mutating func add(load: Int) -> [Int] {
        defer { loads.append(load) }
        if let index = loads.lastIndex(of: load) {
            let a = loads[index + 1..<loads.endIndex].map { $0 } + [load]
            if index - a.count >= loads.startIndex {
                let b = loads[index - a.count + 1 ... index].map { $0 }
                if a == b {
                    return a
                }
            }
        }
        return []
    }
}
