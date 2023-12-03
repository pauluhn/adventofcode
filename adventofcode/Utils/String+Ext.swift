//
//  String+Ext.swift
//  adventofcode
//
//  Created by Paul U on 12/1/23.
//

import Foundation

extension String {
    var int: Int {
        if let int = Int(self) {
            return int
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        if let int = formatter.number(from: self)?.intValue {
            return int
        }
        fatalError()
    }
    func lastMatch(of r: some RegexComponent<(Substring, Substring)>) -> Substring? {
        var pointer = endIndex
        while true {
            let substring = self[pointer..<endIndex]
            if let match = substring.firstMatch(of: r)?.1 {
                return match
            }
            if pointer == startIndex {
                return nil
            }
            pointer = index(before: pointer)
        }
    }
    var multi: [String] {
        split(whereSeparator: \.isNewline).map(String.init)
    }
    var reversed: String {
        String(reversed())
    }
    var unicode: Int {
        assert(count == 1)
        return unicodeScalars.first!.value.int
    }
}

extension Substring {
    var int: Int {
        str.int
    }
    var str: String {
        String(self)
    }
}

extension Character {
    var int: Int {
        str.int
    }
    var str: String {
        String(self)
    }
    var unicode: Int {
        str.unicode
    }
}
