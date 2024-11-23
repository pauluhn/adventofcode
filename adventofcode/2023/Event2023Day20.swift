import Foundation

struct Event2023Day20 {
    static func part1(_ input: String) -> Int {
        lows = 0
        highs = 0

        var modules = parse(input)
        var broadcaster: BroadcastModule!
        var unknowns: [UnknownModule] = []

        for i in 0..<modules.count {
            let module = modules[i]
            switch module.type {
            case .broadcast:
                let b = (module as! BroadcastModule)
                for d in b.destinations {
                    let m = modules.firstIndex { $0.id == d }!
                    b.add(destination: modules[m])
                    modules[m].notify(from: b.id)
                }
                broadcaster = b
            case .flipFlop:
                let f = (module as! FlipflopModule)
                for d in f.destinations {
                    let m = modules.firstIndex { $0.id == d }!
                    f.add(destination: modules[m])
                    modules[m].notify(from: f.id)
                }
            case .conjunction:
                let c = (module as! ConjunctionModule)
                for d in c.destinations {
                    if let m = modules.firstIndex(where: { $0.id == d }) {
                        c.add(destination: modules[m])
                        modules[m].notify(from: c.id)
                    }
                    else {
                        let u = UnknownModule(id: d)
                        unknowns.append(u)
                        c.add(destination: u)
                    }
                }
            case .unknown:
                fatalError()
            }
        }
        modules.append(contentsOf: unknowns)

        Array(repeating: Pulse.low, count: 1000).forEach { pulse in
            lows += 1
            broadcaster.receive(pulse)
            while modules.first(where: { !$0.isEmpty }) != nil {
                for module in modules {
                    module.process()
                }
            }
//            print("\n")
        }

        return lows * highs
    }
    static func part2(_ input: String) -> Int {
        return 0
    }

    private static var lows = 0
    private static var highs = 0

    enum Pulse: String { case high, low }
    enum ModuleType { case flipFlop, conjunction, broadcast, unknown }

    protocol Module {
        var id: String { get }
        var type: ModuleType { get }
        var isEmpty: Bool { get }
        func receive(_ pulse: Pulse, from moduleId: String)
        func process()
        func notify(from moduleId: String)
    }

    class UnknownModule: Module {
        let id: String
        let type: ModuleType = .unknown
        let isEmpty = true
        private var buffer: [Pulse] = []

        init(id: String) {
            self.id = id
        }

        func receive(_ pulse: Pulse, from moduleId: String = "") {
            buffer.append(pulse)
        }
        
        func process() {
            //
        }
        
        func notify(from moduleId: String) {
            fatalError()
        }
    }

    class FlipflopModule: Module { // %
        let id: String
        let type: ModuleType = .flipFlop
        let destinations: [String]
        private(set) var modules: [Module] = []
        private var isOn: Bool
        private var buffer: [Pulse] = []
        var isEmpty: Bool { buffer.isEmpty }

        init(id: String, destinations: [String]) {
            self.id = id
            self.destinations = destinations
            self.isOn = false
        }

        func add(destination module: Module) {
            modules.append(module)
        }

        func receive(_ pulse: Pulse, from moduleId: String = "") {
            guard pulse == .low else { return }
            buffer.append(pulse)
        }

        func process() {
            while !buffer.isEmpty {
                _ = buffer.removeFirst()
                isOn = !isOn
                let output: Pulse = switch isOn {
                case true: .high
                case false: .low
                }
                for module in modules {
//                    print("\(id) -\(output.rawValue)-> \(module.id)")
                    if output == .high { highs += 1 } else { lows += 1 }
                    module.receive(output, from: id)
                }
            }
        }

        func notify(from moduleId: String) {
            // ignore
        }
    }
    class ConjunctionModule: Module { // &
        let id: String
        let type: ModuleType = .conjunction
        let destinations: [String]
        private(set) var modules: [Module] = []
        private(set) var inputs: [String: Pulse] = [:]
        private var buffer: [(Pulse, String)] = []
        var isEmpty: Bool { buffer.isEmpty }

        func add(destination module: Module) {
            modules.append(module)
        }

        init(id: String, destinations: [String]) {
            self.id = id
            self.destinations = destinations
        }

        func receive(_ pulse: Pulse, from moduleId: String) {
            buffer.append((pulse, moduleId))
        }

        func process() {
            while !buffer.isEmpty {
                let (pulse, moduleId) = buffer.removeFirst()
                inputs[moduleId] = pulse
                let s = Set(inputs.values)
                let output: Pulse = if s.count == 1, s.first == .high {
                    .low
                } else {
                    .high
                }
                for module in modules {
//                    print("\(id) -\(output.rawValue)-> \(module.id)")
                    if output == .high { highs += 1 } else { lows += 1 }
                    module.receive(output, from: id)
                }
            }
        }

        func notify(from moduleId: String) {
            inputs[moduleId] = .low
        }
    }
    class BroadcastModule: Module {
        let id: String
        let type: ModuleType = .broadcast
        let destinations: [String]
        private(set) var modules: [Module] = []
        let isEmpty = true

        init(id: String, destinations: [String]) {
            self.id = id
            self.destinations = destinations
        }

        func add(destination module: Module) {
            modules.append(module)
        }

        func receive(_ pulse: Pulse, from moduleId: String = "") {
            for module in modules {
//                print("\(id) -\(pulse.rawValue)-> \(module.id)")
                if pulse == .high { highs += 1 } else { lows += 1 }
                module.receive(pulse, from: id)
            }
        }

        func process() {}

        func notify(from moduleId: String) {
            fatalError()
        }
    }

    private static func parse(_ input: String) -> [Module] {
        input.multi.compactMap { broadcaster($0) ?? flipflop($0) ?? conjunction($0) }
    }

    private static func broadcaster(_ input: String) -> Module? {
        let regex = /broadcaster -> ([a-z, ]+)/
        guard let match = input.matches(of: regex).first else { return nil }
        let modules = match.output.1.str
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return BroadcastModule(id: "broadcaster", destinations: modules)
    }

    private static func flipflop(_ input: String) -> Module? {
        let regex = /%([a-z]+) -> ([a-z, ]+)/
        guard let match = input.matches(of: regex).first else { return nil }
        let id = match.output.1.str
        let modules = match.output.2.str
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return FlipflopModule(id: id, destinations: modules)
    }

    private static func conjunction(_ input: String) -> Module? {
        let regex = /&([a-z]+) -> ([a-z, ]+)/
        guard let match = input.matches(of: regex).first else { return nil }
        let id = match.output.1.str
        let modules = match.output.2.str
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return ConjunctionModule(id: id, destinations: modules)
    }
}
