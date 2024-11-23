import Foundation

struct Event2023Day10 {
    static func part1(_ input: String) -> Int {
        let (_, path, _) = gridPath(input)
        return path.count / 2
    }

    static func part2(_ input: String) -> Int {
        var (grid, _, c) = gridPath(input)
        var start = grid.nodes.first { $0.value == "S" }!
        start.value = c
        grid.set(start, to: start.point)

        var inside = [Point]()
        for y in grid.minY...grid.maxY {
            var count = 0
            var priorValue: Character = " "
            for x in grid.minX...grid.maxX {
                let point = Point(x: x, y: y)
                let node = grid.node(for: point)
                switch node?.value {
                case "F":
                    count += 1
                    priorValue = node!.value
                case "L":
                    count += 1
                    priorValue = node!.value
                case "7":
                    guard priorValue != "L" else { break }
                    count += 1
                    priorValue = node!.value
                case "J":
                    guard priorValue != "F" else { break }
                    count += 1
                    priorValue = node!.value
                case "|":
                    count += 1
                    priorValue = node!.value
                case "-":
                    break
                case ".", nil:
                    if count % 2 == 1 {
                        inside.append(point)
                    }
                default:
                    fatalError()
                }
            }
        }
        return inside.count
    }

    private static func gridPath(_ input: String) -> (Grid<Character>, [Point], Character) {
        let input = input.multi.map { $0.map { $0 }}
        var grid = Grid(input, empty: ".")
        let start = grid.nodes.first { $0.value == "S" }!
        var (next, facing) = Direction.cardinal
            .map { (start.point.offset($0), $0) }
            .first {
                if let node = grid.node(for: $0.0) {
                    switch ($0.1, node.value) {
                    case (.n, "|"), (.n, "7"), (.n, "F"):
                        return true
                    case (.s, "|"), (.s, "L"), (.s, "J"):
                        return true
                    case (.w, "-"), (.w, "L"), (.w, "F"):
                        return true
                    case (.e, "-"), (.e, "J"), (.e, "7"):
                        return true
                    default:
                        return false
                    }
                }
                return false
            }!
        let startFacing = facing
        var path = [start.point, next]

        loop: while true {
            let node = grid.node(for: next)!
            switch node.value {
            case "|": // is a vertical pipe connecting north and south.
                guard facing == .n || facing == .s else { fatalError() }
                next = next.offset(facing)
            case "-": // is a horizontal pipe connecting east and west.
                guard facing == .w || facing == .e else { fatalError() }
                next = next.offset(facing)
            case "L": // is a 90-degree bend connecting north and east.
                guard facing == .s || facing == .w else { fatalError() }
                if facing == .s {
                    facing = .e
                    next = next.offset(facing)
                } else {
                    facing = .n
                    next = next.offset(facing)
                }
            case "J": // is a 90-degree bend connecting north and west.
                guard facing == .s || facing == .e else { fatalError() }
                if facing == .s {
                    facing = .w
                    next = next.offset(facing)
                } else {
                    facing = .n
                    next = next.offset(facing)
                }
            case "7": // is a 90-degree bend connecting south and west.
                guard facing == .n || facing == .e else { fatalError() }
                if facing == .n {
                    facing = .w
                    next = next.offset(facing)
                } else {
                    facing = .s
                    next = next.offset(facing)
                }
            case "F": // is a 90-degree bend connecting south and east.
                guard facing == .n || facing == .w else { fatalError() }
                if facing == .n {
                    facing = .e
                    next = next.offset(facing)
                } else {
                    facing = .s
                    next = next.offset(facing)
                }
            case ".": // is ground; there is no pipe in this tile.
                fatalError()
            case "S": // is the starting position of the animal;
                break loop
            default:
                fatalError()
            }
            path.append(next)
        }

        for i in 0..<grid.nodes.count {
            let node = grid.nodes[i]
            if !path.contains(node.point) && node.value != "." {
                grid.nodes[i].value = "."
            }
        }

        var s = "S"
        switch (startFacing, facing) {
        case (.n, .n), (.s, .s): s = "|"
        case (.w, .w), (.e, .e): s = "-"
        case (.w, .n), (.s, .e): s = "7"
        case (.e, .n), (.s, .w): s = "F"
        case (.e, .s), (.n, .w): s = "L"
        case (.w, .s), (.n, .e): s = "J"
        default: fatalError()
        }
        return (grid, path.dropLast(), s.first!)
    }
}
