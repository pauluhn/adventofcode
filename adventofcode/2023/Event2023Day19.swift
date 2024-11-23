import Foundation

struct Event2023Day19 {
    static func part1(_ input: String) -> Int {
        let (workflows, parts) = parse(input)

        var sum = 0
        for part in parts {
            var workflow = workflows.first { $0.name == "in" }!
            var accepted: Bool?

            let closure: (Rule) -> Void = { rule in
                if rule.result == "A" {
                    accepted = true
                } else if rule.result == "R" {
                    accepted = false
                } else {
                    workflow = workflows.first { $0.name == rule.result }!
                }
            }
            while accepted == nil {
                ruleloop: for rule in workflow.rules {
                    if let category = rule.category, let compare = rule.compare, let value = rule.value {
                        let current = part.ratings[category]!
                        if compare == ">" {
                            if current > value {
                                closure(rule)
                                break ruleloop
                            }
                        } else {
                            if current < value {
                                closure(rule)
                                break ruleloop
                            }
                        }
                    } else {
                        closure(rule)
                        break ruleloop
                    }
                }
            }
            if accepted == true {
                sum += part.ratings.values.reduce(0, +)
            }
        }
        return sum
    }

    static func part2(_ input: String) -> Int {
        return 0
    }

    struct Workflow {
        let name: String
        let rules: [Rule]
    }

    struct Rule {
        let category: Part.Category?
        let compare: String?
        let value: Int?
        let result: String

        init(category: Part.Category? = nil, compare: String? = nil, value: Int? = nil, result: String) {
            self.category = category
            self.compare = compare
            self.value = value
            self.result = result
        }
    }

    struct Part {
        enum Category: String { case x, m, a, s }
        let ratings: [Category: Int]
    }

    private static func parse(_ input: String) -> ([Workflow], [Part]) {
        let a = input.split(separator: "\n\n").map(String.init)
        assert(a.count == 2)
        return (workflows(a[0]), parts(a[1]))
    }

    private static func workflows(_ input: String) -> [Workflow] {
        return input.multi.map { input in
            let a = input.split(separator: "{").map(String.init)
            assert(a.count == 2)
            let name = a[0]
            let rules = a[1]
                .split(separator: "}")[0]
                .split(separator: ",")
                .map(rule)
            return .init(name: name, rules: rules)
        }
    }

    private static func rule(_ input: Substring) -> Rule {
        if let rule = rule1(input) {
            return rule
        } else if let rule = rule2(input) {
            return rule
        } else {
            fatalError()
        }
    }

    private static func rule1(_ input: Substring) -> Rule? {
        let regex = /([xmas])([<>])(\d+):([a-zA-Z]+)/
        guard let match = input.matches(of: regex).first else { return nil }
        let category = match.output.1.str.cat
        let compare = match.output.2.str
        let value = match.output.3.int
        let result = match.output.4.str
        return .init(category: category, compare: compare, value: value, result: result)
    }

    private static func rule2(_ input: Substring) -> Rule? {
        let regex = /([a-zA-Z]+)/
        guard let match = input.matches(of: regex).first else { return nil }
        let result = match.output.1.str
        return .init(result: result)
    }

    private static func parts(_ input: String) -> [Part] {
        let regex = /{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}/
        return input.multi.map {
            let match = $0.matches(of: regex)[0]
            let x = match.output.1.int
            let m = match.output.2.int
            let a = match.output.3.int
            let s = match.output.4.int
            return .init(ratings: [.x:x, .m:m, .a:a, .s:s])
        }
    }
}

private extension String {
    var cat: Event2023Day19.Part.Category {
        assert(count == 1)
        return Event2023Day19.Part.Category(rawValue: self)!
    }
}
