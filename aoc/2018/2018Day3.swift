//
//  2018Day3.swift
//  aoc
//
//  Created by Paul Uhn on 12/4/18.
//  Copyright © 2018 Rightpoint. All rights reserved.
//

import Foundation

struct Y2018Day3 {
    static func Part1(_ data: [String]) -> Int {
        assert(Rect("#123 @ 3,2: 5x4")!.description == "#123 @ 3,2: 5x4")
        
        let rects = data.compactMap(Rect.init)
        
        var maxX = Int.min
        var maxY = Int.min
        for rect in rects {
            maxX = max(maxX, rect.maxX)
            maxY = max(maxY, rect.maxY)
        }
        
        // hit map
        var hitMap = Array(repeating: Array(repeating: 0, count: maxY), count: maxX)
        for rect in rects {
            for x in rect.minX..<rect.maxX {
                for y in rect.minY..<rect.maxY {
                    hitMap[x][y] += 1
                }
            }
        }
        return hitMap.flatMap { $0 }.filter { $0 > 1 }.count
    }
    static func Part2(_ data: [String]) -> Int {
        let rects = data.compactMap(Rect.init)
        
        for index in 0..<rects.count {
            var aRects = rects
            let rect = aRects.remove(at: index)
            if aRects.filter({ $0.intersects(rect) }).isEmpty {
                return rect.id
            }
        }
        fatalError()
    }
}
