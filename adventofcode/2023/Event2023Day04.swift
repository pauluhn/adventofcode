import Foundation
import Numerics

struct Event2023Day04 {
    static func part1(_ input: String) -> Int {
        let regex = /(\d{1,3})/
        return input.multi.map {
            let line = $0.split(separator: "|")

            let winning = line[0].matches(of: regex).map { $0.output.1.int }.dropFirst()
            let winningSet = Set(winning)

            let have = line[1].matches(of: regex).map { $0.output.1.int }
            let haveSet = Set(have)

            let matching = winningSet.intersection(haveSet).count
            guard matching > 0 else { return 0 }
            return Int(Float.pow(2, matching - 1))
        }
        .reduce(0, +)
    }
    
    static func part2(_ input: String) -> Int {
        let regex = /(\d{1,3})/
        var deck = input.multi.map {
            let line = $0.split(separator: "|")

            let prefix = line[0].matches(of: regex).map { $0.output.1.int }
            let card = prefix[0]
            let winningSet = Set(prefix.dropFirst())

            let have = line[1].matches(of: regex).map { $0.output.1.int }
            let haveSet = Set(have)

            let matching = winningSet.intersection(haveSet).count
            return Card(id: card, win: matching, copies: 1)
        }

        var count = 0
        for i in 0..<deck.count {
            let card = deck[i]
            count += card.copies

            let copies = (0..<card.win).compactMap {
                let id = $0 + card.id + 1
                return id < deck.count ? id : nil
            }
            for copy in copies {
                deck[copy - 1].copies += card.copies
            }
        }
        return count
    }

    struct Card {
        let id: Int
        let win: Int
        var copies: Int
    }
}
