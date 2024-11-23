import Foundation

struct Event2023Day01 {
    static func part1(_ input: String) -> Int {
        let regex = /(\d{1})/ // single digit
        return compute(input, regex: regex)
    }

    static func part2(_ input: String) -> Int {
        let regex = /(\d{1}|one|two|three|four|five|six|seven|eight|nine)/ // single digit or digit-word
        return compute(input, regex: regex)
    }

    private static func compute(_ input: String, regex: some RegexComponent<(Substring, Substring)>) -> Int {
        let input = input.multi
        var sum = Int.zero

        for line in input {
            guard let first = line.firstMatch(of: regex)?.1,
                  let last = line.lastMatch(of: regex)
            else { fatalError() }

            sum += (first.int.str + last.int.str).int
        }
        return sum
    }
}
