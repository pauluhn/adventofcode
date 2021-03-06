//
//  2019Day4.swift
//  aoc
//
//  Created by Paul Uhn on 12/4/19.
//  Copyright © 2019 Rightpoint. All rights reserved.
//

import Foundation

struct Y2019Day4 {
    
    static func Part1(_ lower: Int, _ upper: Int) -> Int {
        assert(valid(122345) == true)
        assert(valid(111123) == true)
        assert(valid(111111) == true)
        assert(valid(223450) == false)
        assert(valid(123789) == false)

        return (lower...upper)
            .map { valid($0) }
            .filter { $0 }
            .count
    }
    
    static func Part2(_ lower: Int, _ upper: Int) -> Int {
        assert(valid2(112233) == true)
        assert(valid2(123444) == false)
        assert(valid2(111122) == true)
        
        return (lower...upper)
            .map { valid2($0) }
            .filter { $0 }
            .count
    }

    private static func valid(_ password: Int) -> Bool {
        let password = String(password)
        
        // six digit
        guard password.count == 6 else { return false }
        
        // two adjacent digist are same (atleast)
        let same = Dictionary(grouping: password) { $0 }
        guard !same.filter({ $1.count >= 2 }).isEmpty else {
            return false }
        
        // never decrease
        var previous: Character = "0"
        for c in password {
            guard c >= previous else { return false}
            previous = c
        }
        
        return true
    }
    
    private static func valid2(_ password: Int) -> Bool {
        guard valid(password) else { return false }
        let password = String(password)

        // adjacent not part of larger group
        let same = Dictionary(grouping: password) { $0 }
        return !same.filter { $1.count == 2 }.isEmpty
    }
}
