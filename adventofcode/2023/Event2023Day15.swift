import Foundation

struct Event2023Day15 {
    static func part1(_ input: String) -> Int {
        input.split(separator: ",")
            .map {
                let input = $0.map { $0.unicode }
                var currentValue = 0
                for i in input {
                    currentValue += i
                    currentValue *= 17
                    currentValue = currentValue % 256
                }
                return currentValue
            }
            .reduce(0, +)
    }
    
    static func part2(_ input: String) -> Int {
        let input = input.split(separator: ",")
        var hashmap: [Int: [Lens]] = [:]

        for i in input {
            if i.first(where: { $0 == "=" }) != nil {
                // equal
                let op = i.split(separator: "=")
                assert(op.count == 2)
                let label = op[0].str
                let box = part1(label)
                let focalLength = op[1].int
                let lens = Lens(label: label, focalLength: focalLength)
                if var lenses = hashmap[box] {
                    // check if same label
                    if let index = lenses.firstIndex(where: { $0.label == label }) {
                        lenses.remove(at: index)
                        lenses.insert(lens, at: index)
                    } else {
                        lenses.append(lens)
                    }
                    hashmap[box] = lenses
                } else {
                    hashmap[box] = [lens]
                }

            } else {
                // minus
                let op = i.split(separator: "-")
                assert(op.count == 1)
                let label = op[0].str
                let box = part1(label)
                if var lenses = hashmap[box] {
                    // remove lens from box
                    if let index = lenses.firstIndex(where: { $0.label == label }) {
                        lenses.remove(at: index)
                        hashmap[box] = lenses
                    }
                }
            }
        }

        return hashmap.map {
            let box = $0.key + 1
            return $0.value.enumerated().map {
                box * ($0.offset + 1) * $0.element.focalLength
            }
            .reduce(0, +)
        }
        .reduce(0, +)
    }

    private struct Lens {
        let label: String
        let focalLength: Int
    }
}
