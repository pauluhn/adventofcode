import Foundation

struct Event2023Day03 {
    static func part1(_ input: String) -> Int {
        let (grid, parts) = parse(input)

        var partSet = Set<Part>()
        let symbols = grid.nodes.filter { !$0.value.isNumber }
        for symbol in symbols {
            let symbolSet = Set(symbol.adjacent)
            let partNumbers = parts
                .filter { !Set($0.points).intersection(symbolSet).isEmpty }
            partSet.formUnion(partNumbers)
        }

        return partSet.map { $0.number }.reduce(0, +)
    }

    static func part2(_ input: String) -> Int {
        let (grid, parts) = parse(input)

        var sum = 0
        let gears = grid.nodes.filter { $0.value == "*" }
        for gear in gears {
            let gearSet = Set(gear.adjacent)
            let partNumbers = parts
                .filter { !Set($0.points).intersection(gearSet).isEmpty }
            guard partNumbers.count == 2 else { continue }
            let ratio = partNumbers.map { $0.number }.reduce(1, *)
            sum += ratio
        }

        return sum
    }

    struct Part: Hashable {
        var number: Int
        var points: [Point]
    }

    private static func parse(_ input: String) -> (Grid<Character>, [Part]) {
        let grid = Grid(input.gridInput, empty: ".")

        var part = Part(number: 0, points: [])
        var parts = [Part]()

        var numbers = grid.nodes.filter { $0.value.isNumber }
        while !numbers.isEmpty {
            let number = numbers.removeFirst()
            if number.point == part.points.last?.offset(.e) {
                part.number = part.number * 10 + number.value.int
                part.points.append(number.point)
            } else {
                parts.append(part)
                part = Part(number: number.value.int, points: [number.point])
            }
        }
        parts.removeFirst()
        parts.append(part)

        return (grid, parts)
    }
}
