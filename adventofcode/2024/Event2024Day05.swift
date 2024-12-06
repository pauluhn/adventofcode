import Foundation

struct Event2024Day05 {
    static func part1(_ input: String) -> Int {
        let (rules, updates) = parse(input)

        var sum = 0
        for update in updates {
            if isCorrect(update, rules: rules) {
                sum += update[middle(update)]
            }
        }
        return sum
    }
    static func part2(_ input: String) -> Int {
        let (rules, updates) = parse(input)

        var sum = 0
        for var update in updates {
            if isCorrect(update, rules: rules) { continue }

            var i = 0
            while !isCorrect(update, rules: rules) {
                if i >= rules.count { i = 0 }

                let rule = rules[i]
                if let l = update.firstIndex(of: rule[0]),
                   let r = update.firstIndex(of: rule[1]),
                   l > r {
                    update[l] = rule[1]
                    update[r] = rule[0]
                }
                i += 1
            }
            sum += update[middle(update)]
        }
        return sum
    }

    private static func isCorrect(_ update: [Int], rules: [[Int]]) -> Bool {
        var previous = Set<Int>()
        for page in update {
            let next = rules.filter { $0[0] == page }.map { $0[1] }
            if !previous.intersection(next).isEmpty {
                return false
            }
            previous.insert(page)
        }
        return true
    }

    private static func middle(_ update: [Int]) -> Int {
        (update.count / 2) + (update.count % 2 == 0 ? -1 : 0)
    }

    private static func parse(_ input: String) -> ([[Int]], [[Int]]) {
        let input = input.split(separator: "\n\n")
        let rules = input[0].multi.map { $0.split(separator: "|").map { $0.int } }
        let updates = input[1].multi.map { $0.split(separator: ",").map { $0.int } }
        return (rules, updates)
    }
}
