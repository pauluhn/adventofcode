import Foundation

struct Event2023Day06 {
    static func part1(_ input: String) -> Int {
        let regex = /\d{1,4}/
        let input = input.matches(of: regex).map { $0.int }
        let time = 0
        let distance = input.count / 2
        var wins = [Int]()

        for i in 0..<distance {
            let t = input[time + i]
            let d = input[distance + i]
            wins.append(win(t, d))
        }
        return wins.reduce(1, *)
    }

    static func part2(_ input: String) -> Int {
        let regex = /\d{1,4}/
        let input = input.matches(of: regex).map { $0.str }
        let half = input.count / 2

        let t = input[0..<half].joined().int
        let d = input[half..<input.count].joined().int
        return win(t, d)
    }

    private static func win(_ t: Int, _ d: Int) -> Int {
        (0...t).map {
            let speed = $0
            let timeLeft = t - $0
            let distance = speed * timeLeft
            return distance > d ? 1 : 0
        }
        .reduce(0, +)
    }
}
