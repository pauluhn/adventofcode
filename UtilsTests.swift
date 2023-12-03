//
//  UtilsTests.swift
//  adventofcodeTests
//
//  Created by Paul U on 12/1/23.
//

@testable import adventofcode
import XCTest

final class UtilsTests: XCTestCase {

    func testStringToInt() {
        assert("one".int == 1)
        assert("two".int == 2)
        assert("three".int == 3)
        assert("four".int == 4)
        assert("five".int == 5)
        assert("six".int == 6)
        assert("seven".int == 7)
        assert("eight".int == 8)
        assert("nine".int == 9)
    }

    func testCharacterToUnicode() {
        assert("a".unicode == 97)
        assert("A".unicode == 65)
    }
}
