import Foundation

struct Event2024Day03 {
    static func part1(_ input: String) -> Int {
        let regex = /mul\((\d+),(\d+)\)/
        return input.multi.flatMap {
            $0.matches(of: regex).map {
                $0.output.1.int * $0.output.2.int
            }
        }
        .reduce(0, +)
    }
    static func part2(_ input: String) -> Int {
        enum Instruction {
            case mul(Int, Int)
            case `do`
            case dont
        }
        let regex = /mul\((\d+),(\d+)\)|do\(\)|don't\(\)/
        let instructions = input.multi.flatMap {
            return $0.matches(of: regex).map { match -> Instruction in
                switch match.output.0.prefix(3) {
                case "mul":
                    return .mul(
                        match.output.1!.int,
                        match.output.2!.int
                    )
                case "do(": return .do
                case "don": return .dont
                default: fatalError()
                }
            }
        }

        var execute = true
        var sum = 0
        for instruction in instructions {
            switch instruction {
            case let .mul(a, b):
                sum += execute ? a * b : 0
            case .do:
                execute = true
            case .dont:
                execute = false
            }
        }
        return sum
    }
}
