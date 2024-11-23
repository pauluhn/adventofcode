import Foundation

struct Event2023Day07 {
    static func part1(_ input: String) -> Int {
        compute(input)
    }
    static func part2(_ input: String) -> Int {
        let input = input.map { $0 == "J" ? "*" : $0.str }.joined()
        return compute(input)
    }

    private static func compute(_ input: String) -> Int {
        let hands = input.multi.map {
            let input = $0.split(separator: " ")
            let cards = input[0].map { Card(c: $0) }
            let bid = input[1].int
            let type = HandType(cards: cards)
            return Hand(cards: cards, bid: bid, type: type)
        }

        let sorted = hands.sorted {
            if $0.type == $1.type {
                for i in 0..<5 {
                    if $0.cards[i] != $1.cards[i] {
                        return $0.cards[i].rawValue < $1.cards[i].rawValue
                    }
                }
            } else {
                return $0.type.rawValue < $1.type.rawValue
            }
            fatalError()
        }

        return zip(1...sorted.count, sorted).reduce(0) {
            $0 + $1.0 * $1.1.bid
        }
    }

    struct Hand {
        let cards: [Card]
        let bid: Int
        let type: HandType
    }

    enum HandType: Int {
        case fiveKind = 6
        case fourKind = 5
        case fullHouse = 4
        case threeKind = 3
        case twoPair = 2
        case onePair = 1
        case highCard = 0

        init(cards: [Card]) {
            guard cards.count == 5 else { fatalError() }

            let set = Set(cards)
            let counts = NSCountedSet(array: cards)
            let jokers = counts.count(for: Card.joker)
            let setCount = set.count - (jokers > 0 ? 1 : 0)
            let max = set
                .filter { $0 != .joker }
                .map { counts.count(for: $0) }
                .max() ?? 0

            switch (setCount, max + jokers) {
            case (0, _),
                 (1, _): self = .fiveKind
            case (2, 4): self = .fourKind
            case (2, 3): self = .fullHouse
            case (3, 3): self = .threeKind
            case (3, 2): self = .twoPair
            case (4, _): self = .onePair
            case (5, _): self = .highCard
            default: fatalError()
            }
        }
    }

    enum Card: Int {
        case ace = 13
        case king = 12
        case queen = 11
        case jack = 10
        case ten = 9
        case nine = 8
        case eight = 7
        case seven = 6
        case six = 5
        case five = 4
        case four = 3
        case three = 2
        case two = 1
        case joker = 0

        init(c: Character) {
            switch c {
            case "A": self = .ace
            case "K": self = .king
            case "Q": self = .queen
            case "J": self = .jack
            case "T": self = .ten
            case "9": self = .nine
            case "8": self = .eight
            case "7": self = .seven
            case "6": self = .six
            case "5": self = .five
            case "4": self = .four
            case "3": self = .three
            case "2": self = .two
            case "*": self = .joker
            default: fatalError()
            }
        }
    }
}
