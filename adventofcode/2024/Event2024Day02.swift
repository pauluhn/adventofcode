import Foundation

struct Event2024Day02 {
    static func part1(_ input: String) -> Int {
        let reports = parse(input)

        var count = 0
        for report in reports where isSafe(report) {
            count += 1
        }
        return count
    }
    static func part2(_ input: String) -> Int {
        let reports = parse(input)

        var count = 0
        for report in reports where dampener(report) {
            count += 1
        }
        return count
    }

    private static func isSafe(_ report: [Int]) -> Bool {
        if report == report.sorted() || report == report.sorted().reversed() {
            return checkAdjacentLevels(report)
        } else {
            return false
        }
    }

    private static func checkAdjacentLevels(_ report: [Int]) -> Bool {
        zip(report, report.dropFirst())
            .map { abs($0 - $1) }
            .filter { $0 < 1 || $0 > 3 }
            .count == 0
    }

    private static func dampener(_ report: [Int]) -> Bool {
        for i in 0..<report.count {
            var r = report
            r.remove(at: i)
            if isSafe(r) {
                return true
            }
        }
        return false
    }

    private static func parse(_ input: String) -> [[Int]] {
        input.multi.map { $0.split(separator: " ").map { $0.int } }
    }
}
