import Foundation

struct Event2023Day16 {
    static func part1(_ input: String) -> Int {
        let tiles = input.multi.map { $0.map { Tile(rawValue: $0)! }}
        let board = Board(tiles: tiles)
//        display(board)

        let beam = Beam(position: .init(x: -1, y: 0), heading: .e)
        return compute(board, start: beam)
    }

    static func part2(_ input: String) -> Int {
        let tiles = input.multi.map { $0.map { Tile(rawValue: $0)! }}
        let board = Board(tiles: tiles)
        let maxX = tiles[0].count - 1
        let maxY = tiles.count - 1

        var mostEnergized = 0

        for x in 0...maxX {
            // top down
            let beam = Beam(position: .init(x: x, y: -1), heading: .s)
            let result = compute(board, start: beam)
            mostEnergized = max(mostEnergized, result)

            // bottom up
            let beam2 = Beam(position: .init(x: x, y: maxY + 1), heading: .n)
            let result2 = compute(board, start: beam2)
            mostEnergized = max(mostEnergized, result2)
        }

        for y in 0...maxY {
            // left right
            let beam = Beam(position: .init(x: -1, y: y), heading: .e)
            let result = compute(board, start: beam)
            mostEnergized = max(mostEnergized, result)

            // right left
            let beam2 = Beam(position: .init(x: maxX + 1, y: y), heading: .w)
            let result2 = compute(board, start: beam2)
            mostEnergized = max(mostEnergized, result2)
        }
        
        return mostEnergized
    }

    private static func compute(_ board: Board, start: Beam) -> Int {
        var beams = [start]
        var energized = Set<Beam>()

        while !beams.isEmpty {
            var nextBeams = [Beam]()
            for var beam in beams {
                beam.step()
                guard board.isValid(point: beam.position) else { continue }

                guard !energized.contains(beam) else { continue }
                energized.insert(beam)

                switch board.tile(at: beam.position) {
                case .empty:
                    nextBeams.append(beam)

                case .mirror1: // /
                    let heading: Direction = switch beam.heading {
                    case .n: .e
                    case .s: .w
                    case .w: .s
                    case .e: .n
                    default: fatalError()
                    }
                    nextBeams.append(Beam(position: beam.position, heading: heading))

                case .mirror2: // \
                    let heading: Direction = switch beam.heading {
                    case .n: .w
                    case .s: .e
                    case .w: .n
                    case .e: .s
                    default: fatalError()
                    }
                    nextBeams.append(Beam(position: beam.position, heading: heading))

                case .hsplit:
                    if beam.heading == .w || beam.heading == .e {
                        nextBeams.append(Beam(position: beam.position, heading: .n))
                        nextBeams.append(Beam(position: beam.position, heading: .s))
                    } else {
                        nextBeams.append(beam)
                    }

                case .vsplit:
                    if beam.heading == .n || beam.heading == .s {
                        nextBeams.append(Beam(position: beam.position, heading: .w))
                        nextBeams.append(Beam(position: beam.position, heading: .e))
                    } else {
                        nextBeams.append(beam)
                    }
                }
            }
            beams = nextBeams
        }
        let points = energized.map { $0.position }
        return Set(points).count
    }

    struct Beam: Hashable {
        var position: Point
        var heading: Direction

        mutating func step() {
            position = position.offset(heading)
        }
    }

    struct Board {
        let tiles: [[Tile]]

        func isValid(point: Point) -> Bool {
            guard !tiles.isEmpty, !tiles[0].isEmpty else { return false }
            return point.x >= 0 && point.x < tiles[0].count &&
                   point.y >= 0 && point.y < tiles.count
        }

        func tile(at point: Point) -> Tile {
            tiles[point.y][point.x]
        }
    }

    enum Tile: Character {
        case empty = "."
        case mirror1 = "/"
        case mirror2 = "\\"
        case hsplit = "|"
        case vsplit = "-"
    }

    private static func display(_ board: Board) {
        let description = board.tiles.map { row in
            row.map { $0.rawValue }.map(String.init).joined()
        }
        .joined(separator: "\n")
        print(description)
    }
}
