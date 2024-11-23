import Foundation

struct Event2024Day01 {
    static func part1(_ input: String) -> Int {
        let (first, second) = parse(input)
        return zip(first.sorted(), second.sorted()).reduce(0) { $0 + abs($1.0 - $1.1) }
    }
    static func part2(_ input: String) -> Int {
        let (first, second) = parse(input)
        return first.map { f in
            let count = second.filter { $0 == f }.count
            return f * count
        }.reduce(0, +)
    }
    private static func parse(_ input: String) -> ([Int], [Int]) {
        let n = input.multi.map {
            let n = $0.split(separator: "   ")
            return (n[0].int, n[1].int)
        }
        let first = n.map { $0.0 }
        let second = n.map { $0.1 }
        return (first, second)
    }
}
