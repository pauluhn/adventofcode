import Foundation

struct Event2023Day12 {
    static func part1(_ input: String) -> Int {
        let count = input.multi.map {
            let records = $0.split(separator: " ")
            let springs = records[0].map { Spring(rawValue: $0)! }
            let sizes = records[1].split(separator: ",").map { $0.int }

            let unknowns = springs.filter { $0 == .unknown }.count
            let combinations = recursive([], length: unknowns)
            var count = 0
            for var combo in combinations {
                var copy = springs
                for i in 0..<copy.count {
                    if copy[i] == .unknown {
                        copy[i] = combo.removeFirst()
                    }
                }
                if validate(springs: copy, sizes: sizes) {
                    count += 1
                }
            }
            return count
        }
        let sum = count.reduce(0, +)
        return sum
    }

    static func part2(_ input: String) -> Int {
        0
    }

    enum Spring: Character {
        case operational = "."
        case damaged = "#"
        case unknown = "?"
    }

    private static func recursive(_ input: [Spring], length: Int) -> [[Spring]] {
        guard input.count < length else { return [input] }
        let operational = recursive(input + [.operational], length: length)
        let damaged = recursive(input + [.damaged], length: length)
        return operational + damaged
    }

    private static func validate(springs: [Spring], sizes: [Int]) -> Bool {
        guard springs.first(where: { $0 == .unknown} ) == nil else { fatalError() }
        var isDamaged = false
        var count = 0
        var counts = [Int]()
        for spring in springs {
            switch (spring, isDamaged) {
            case (.damaged, false):
                isDamaged = true
                count += 1
            case (.damaged, true):
                count += 1
            case (.operational, true):
                counts.append(count)
                count = 0
                isDamaged = false
            case (.operational, false):
                break
            default:
                fatalError()
            }
        }
        if isDamaged {
            counts.append(count)
        }
        return counts == sizes
    }
}
