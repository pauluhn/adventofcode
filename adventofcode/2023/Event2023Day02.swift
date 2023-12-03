//

import Foundation

struct Event2023Day02 {
    static func part1(_ input: String) -> Int {
        parse(input).compactMap {
            let impossible = $0.rounds
                .flatMap { $0 }
                .map {
                    switch $0 {
                    case .red(let count): count <= 12
                    case .green(let count): count <= 13
                    case .blue(let count): count <= 14
                    }
                }
                .first(where: { !$0 })
            return impossible == nil ? $0.number : nil
        }
        .reduce(0, +)
    }
    
    static func part2(_ input: String) -> Int {
        parse(input).map {
            let cubes = $0.rounds.flatMap { $0 }
            var red = 0
            var green = 0
            var blue = 0

            for cube in cubes {
                switch cube {
                case .red(let count): red = max(red, count)
                case .green(let count): green = max(green, count)
                case .blue(let count): blue = max(blue, count)
                }

            }
            return red * blue * green
        }
        .reduce(0, +)
    }

    struct Game {
        let number: Int
        let rounds: [[Cube]]
    }

    enum Cube {
        case red(Int)
        case green(Int)
        case blue(Int)

        init(color: String, count: Int) {
            switch color {
            case "red": self = .red(count)
            case "green": self = .green(count)
            case "blue": self = .blue(count)
            default: fatalError()
            }
        }
    }

    private static func parse(_ input: String) -> [Game] {
        let regex = /^Game (\d+): (.+)$/
        let cubeRegex = /(\d+) (\w+)/
        return input.multi.map {
            let match = $0.matches(of: regex)[0]
            let number = match.output.1.int
            let rounds = match.output.2
                .split(separator: ";")
                .map {
                    $0.split(separator: ",")
                        .map {
                            let match = $0.matches(of: cubeRegex)[0]
                            let count = match.output.1.int
                            let color = match.output.2.str
                            return Cube(color: color, count: count)
                        }
                }
            return Game(number: number, rounds: rounds)
        }
    }
}
