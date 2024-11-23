import Foundation

struct Event2023Day05 {
    static func part1(_ input: String) -> Int {
        let (seeds, mapping) = parse(input)

        var values = seeds
        var current = "seed"
        while current != "location" {
            let mappings = mapping.filter { $0.from == current }
            values = values.map { value in
                let mapping = mappings.first(where: { mapping in
                    value >= mapping.source && value <= mapping.source + mapping.range
                }) ?? Mapping(from: "", to: "", source: value, destination: value, range: 0)
                return value + (mapping.destination - mapping.source)
            }
            current = mappings[0].to
        }
        return values.min()!
    }
    
    static func part2(_ input: String) -> Int {
        let (seeds, mapping) = parse(input)

        var values = [Value]()
        for i in stride(from: 0, to: seeds.count, by: 2) {
            values.append(Value(start: seeds[i], range: seeds[i + 1]))
        }

        var current = "seed"
        while current != "location" {
            let mappings = mapping.filter { $0.from == current }

            var bag = values
            var pile = [Value]()
            while !bag.isEmpty {
                var value = bag.removeFirst()
                var mappingToUse = Mapping(from: "", to: "", source: value.start, destination: value.start, range: value.range)
                for mapping in mappings {
                    if value.start >= mapping.source && value.start < mapping.source + mapping.range {
                        if value.start + value.range > mapping.source + mapping.range {
                            // split
                            let newStart = mapping.source + mapping.range
                            let newRange = (value.start + value.range) - newStart
                            let newValue = Value(start: newStart, range: newRange)
                            bag.append(newValue)
                            let oldValue = Value(start: value.start, range: value.range - newRange)
                            value = oldValue
                        }
                        mappingToUse = mapping
                        break
                    }
                }
                let converted = Value(start: value.start + (mappingToUse.destination - mappingToUse.source), range: value.range)
                pile.append(converted)
            }
            current = mappings[0].to
            values = pile
        }
        return values.map { $0.start }.min()!
    }

    struct Value {
        let start: Int
        let range: Int
    }

    struct Mapping {
        let from: String
        let to: String
        let source: Int
        let destination: Int
        let range: Int
    }

    private static func parse(_ input: String) -> ([Int], [Mapping]) {
        var input = input.split(separator: /\n\n/)
        let seeds = seeds(input.removeFirst().str)
        let mappings = input.flatMap { mapping($0.str) }
        return (seeds, mappings)
    }

    private static func seeds(_ input: String) -> [Int] {
        let regex = /seeds: (.+)/
        guard let match = input.firstMatch(of: regex) else { fatalError() }
        return match.output.1.split(separator: " ").map { $0.int }
    }

    private static func mapping(_ input: String) -> [Mapping] {
        let regex = /(.+)-to-(.+) map:/
        var input = input.multi
        let match = input.removeFirst().matches(of: regex)[0]
        let from = match.output.1.str
        let to = match.output.2.str

        return input.map {
            let mapping = $0.split(separator: " ").map { $0.int }
            guard mapping.count == 3 else { fatalError() }
            return Mapping(from: from, to: to, source: mapping[1], destination: mapping[0], range: mapping[2])
        }
    }
}
