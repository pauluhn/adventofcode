import Foundation

struct Event2023Day13 {
    static func part1(_ input: String) -> Int {
        let grids = input
            .split(separator: "\n\n")
            .map { String($0) }
            .map { Grid($0.gridInput, empty: ".") }

        var sum = 0
        for grid in grids {
            sum += checkColumns(grid)
            sum += checkRows(grid)
        }
        return sum
    }

    static func part2(_ input: String) -> Int {
        let grids = input
            .split(separator: "\n\n")
            .map { String($0) }
            .map { Grid($0.gridInput, empty: ".") }

        var sum = 0
        for grid in grids {
            let a = checkRowsSmudge(grid)
            let b = checkColumnsSmudge(grid)
            sum += a + b
        }
        return sum
    }

    private static func checkColumns(_ grid: Grid<Character>) -> Int {
        for x in grid.minX..<grid.maxX {
            let y1 = grid.nodes.filter { $0.point.x == x }.map { $0.point.y }
            let y2 = grid.nodes.filter { $0.point.x == x + 1 }.map { $0.point.y }
            if Set(y1) == Set(y2), checkMirrorVertical(grid, x, x + 1) {
                return x + 1
            }
        }
        return 0
    }

    private static func checkRows(_ grid: Grid<Character>) -> Int {
        for y in grid.minY..<grid.maxY {
            let x1 = grid.nodes.filter { $0.point.y == y }.map { $0.point.x }
            let x2 = grid.nodes.filter { $0.point.y == y + 1 }.map { $0.point.x }
            if Set(x1) == Set(x2), checkMirrorHorizontal(grid, y, y + 1) {
                return 100 * (y + 1)
            }
        }
        return 0
    }

    private static func checkMirrorVertical(_ grid: Grid<Character>, _ x1: Int, _ x2: Int) -> Bool {
        let a = (grid.minX...x1).map { x in grid.nodes.filter { $0.point.x == x }.map { $0.point.y }}
        let b = (x2...grid.maxX).map { x in grid.nodes.filter { $0.point.x == x }.map { $0.point.y }}
        return zip(a.reversed(), b).first { a, b in Set(a) != Set(b) } == nil
    }

    private static func checkMirrorHorizontal(_ grid: Grid<Character>, _ y1: Int, _ y2: Int) -> Bool {
        let a = (grid.minY...y1).map { y in grid.nodes.filter { $0.point.y == y }.map { $0.point.x }}
        let b = (y2...grid.maxY).map { y in grid.nodes.filter { $0.point.y == y }.map { $0.point.x }}
        return zip(a.reversed(), b).first { a, b in Set(a) != Set(b) } == nil
    }

    private static func checkColumnsSmudge(_ grid: Grid<Character>) -> Int {
        var best = 0
        for x in grid.minX..<grid.maxX {
            let y1 = grid.nodes.filter { $0.point.x == x }.map { $0.point.y }
            let y2 = grid.nodes.filter { $0.point.x == x + 1 }.map { $0.point.y }
            if Set(y1) == Set(y2), checkMirrorVerticalSmudge(grid, x, x + 1) {
                best = max(best, x + 1)
            } else if smudge(y1, y2) == 1, checkMirrorVerticalSmudge(grid, x, x + 1) {
                best = max(best, x + 1)
            }
        }
        return best
    }

    private static func checkRowsSmudge(_ grid: Grid<Character>) -> Int {
        var best = 0
        for y in grid.minY..<grid.maxY {
            let x1 = grid.nodes.filter { $0.point.y == y }.map { $0.point.x }
            let x2 = grid.nodes.filter { $0.point.y == y + 1 }.map { $0.point.x }
            if Set(x1) == Set(x2), checkMirrorHorizontalSmudge(grid, y, y + 1) {
                best = max(best, 100 * (y + 1))
            } else if smudge(x1, x2) == 1, checkMirrorHorizontalSmudge(grid, y, y + 1) {
                best = max(best, 100 * (y + 1))
            }
        }
        return best
    }

    private static func smudge(_ a: some Collection<Int>, _ b: some Collection<Int>) -> Int {
        if a.count != b.count {
            let superset = a.count >= b.count ? Set(a) : Set(b)
            let subset = a.count >= b.count ? Set(b) : Set(a)
            return superset.subtracting(subset).count
        } else {
            let c = Set(a).subtracting(b).count
            let d = Set(b).subtracting(a).count
            return c + d
        }
    }

    private static func checkMirrorVerticalSmudge(_ grid: Grid<Character>, _ x1: Int, _ x2: Int) -> Bool {
        let a = (grid.minX...x1).map { x in grid.nodes.filter { $0.point.x == x }.map { $0.point.y }}
        let b = (x2...grid.maxX).map { x in grid.nodes.filter { $0.point.x == x }.map { $0.point.y }}
        let c = zip(a.reversed(), b)
            .map { a, b in smudge(a, b) }
            .filter { $0 > 0 }
        return c.count == 1 && c[0] == 1
    }

    private static func checkMirrorHorizontalSmudge(_ grid: Grid<Character>, _ y1: Int, _ y2: Int) -> Bool {
        let a = (grid.minY...y1).map { y in grid.nodes.filter { $0.point.y == y }.map { $0.point.x }}
        let b = (y2...grid.maxY).map { y in grid.nodes.filter { $0.point.y == y }.map { $0.point.x }}
        let c = zip(a.reversed(), b)
            .map { a, b in smudge(a, b) }
            .filter { $0 > 0 }
        return c.count == 1 && c[0] == 1
    }
}
