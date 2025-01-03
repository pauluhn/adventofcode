import Foundation

/// greatest common divisor
func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

/// least common multiple
func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}
