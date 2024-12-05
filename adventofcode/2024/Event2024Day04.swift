import Foundation

struct Event2024Day04 {
    static func part1(_ input: String) -> Int {
        let words = parse(input)

        var count = 0
        for x in 0...maxX {
            for y in 0...maxY {
                if words[y][x] == "X" {
                    // find M
                    for m in next(x, y, Direction.cardinal + Direction.ordinal) {
                        if words[m.0.y][m.0.x] == "M" {
                            let direction = m.1
                            // find A
                            if let a = next(m.0.x, m.0.y, [direction]).first,
                               words[a.0.y][a.0.x] == "A" {
                                // find S
                                if let s = next(a.0.x, a.0.y, [direction]).first,
                                   words[s.0.y][s.0.x] == "S" {
                                    count += 1
                                }
                            }
                        }
                    }
                }
            }
        }
        return count
    }
    static func part2(_ input: String) -> Int {
        let words = parse(input)

        let permutations: [[Character]] = [
            ["M", "M", "S", "S"],
            ["M", "S", "S", "M"],
            ["S", "S", "M", "M"],
            ["S", "M", "M", "S"]
        ]

        var count = 0
        for x in 0...maxX {
            for y in 0...maxY {
                if words[y][x] == "A" {
                    // check four corners
                    let four = next(x, y, Direction.ordinal)
                        .map { words[$0.0.y][$0.0.x] }
                    count += permutations.contains(four) ? 1 : 0
                }
            }
        }
        return count
    }

    private static var maxX = 0
    private static var maxY = 0

    private static func next(_ x: Int, _ y: Int, _ directions: [Direction]) -> [(Point, Direction)] {
        directions
            .map { (Point(x: x, y: y).offset($0), $0) }
            .filter { $0.0.x >= 0 && $0.0.y >= 0 && $0.0.x <= maxX && $0.0.y <= maxY }
    }

    private static func parse(_ input: String) -> [[Character]] {
        let words = input.gridInput
        maxX = words[0].count - 1
        maxY = words.count - 1
        return words
    }
}
