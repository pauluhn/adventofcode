import Foundation

struct Event2023Day09 {
    static func part1(_ input: String) -> Int {
        let (_, input) = parse(input)
        return input.map { $0.reduce(0, +) }.reduce(0, +)
    }
    
    static func part2(_ input: String) -> Int {
        let (input, _) = parse(input)
        return input.map {
            var temp = $0
            var result = temp.removeLast()
            while !temp.isEmpty {
                let next = temp.removeLast()
                result = next - result
            }
            return result
        }
        .reduce(0, +)
    }

    private static func parse(_ input: String) -> ([[Int]], [[Int]]) {
        let input = input.multi.map { $0.split(separator: " ").map { $0.int }}

        var results1 = [[Int]]()
        var results2 = [[Int]]()

        for var line in input {
            var first = [line.first!]
            var last = [line.last!]
            loop: while true {
                var temp = [Int]()
                for i in 0..<line.count - 1 {
                    let diff = line[i + 1] - line[i]
                    temp.append(diff)
                }
                first.append(temp.first!)
                last.append(temp.last!)
                if Set(temp).count == 1, temp.first == 0 {
                    break loop
                }
                line = temp
            }
            results1.append(first)
            results2.append(last)
        }
        return (results1, results2)
    }
}
