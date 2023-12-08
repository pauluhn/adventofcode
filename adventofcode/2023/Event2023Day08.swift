//

import Algorithms
import Foundation

struct Event2023Day08 {
    static func part1(_ input: String) -> Int {
        let (navigation, network) = parse(input)

        var pointer = "AAA"
        var steps = 0
        var n = 0

        while pointer != "ZZZ" {
            let node = network.first(where: { $0.id == pointer })!
            let navigate = navigation[n]
            switch navigate {
            case .left: pointer = node.left
            case .right: pointer = node.right
            }
            steps += 1
            n += 1
            if n == navigation.endIndex {
                n = navigation.startIndex
            }
        }
        return steps
    }
    
    static func part2(_ input: String) -> Int {
        let (navigation, network) = parse(input)

        var pointers = network.filter { $0.id.last == "A" }.map { $0.id }
        var steps = 0
        var n = 0
        var pattern = Array(repeating: -1, count: pointers.count)

        while true {
            let nodes = pointers.map { p in network.first(where: { $0.id == p })! }
            let navigate = navigation[n]
            switch navigate {
            case .left: pointers = nodes.map { $0.left }
            case .right: pointers = nodes.map { $0.right }
            }
            steps += 1
            n += 1
            if n == navigation.endIndex {
                n = navigation.startIndex
            }

            for i in 0..<pointers.count {
                guard pattern[i] == -1 else { continue }
                if pointers[i].last == "Z" {
                    pattern[i] = steps
                }
            }

            if pattern.min()! > -1 {
                var a = pattern.first!
                var rest = pattern.dropFirst()
                while !rest.isEmpty {
                    let b = rest.removeFirst()
                    a = lcm(a, b)
                }
                return a
            }
        }
    }

    enum Navigate: Character {
        case left = "L"
        case right = "R"
    }

    struct Node {
        let id: String
        let left: String
        let right: String
    }

    private static func parse(_ input: String) -> ([Navigate], [Node]) {
        let input = input.split(separator: "\n\n")
        let navigation = input[0].str.map { Navigate(rawValue: $0)! }

        let regex = /(\w{3}) = \((\w{3}), (\w{3})\)/
        let network = input[1].str.multi.map {
            let match = $0.matches(of: regex)[0]
            let id = match.output.1.str
            let left = match.output.2.str
            let right = match.output.3.str
            return Node(id: id, left: left, right: right)
        }
        return (navigation, network)
    }
}
