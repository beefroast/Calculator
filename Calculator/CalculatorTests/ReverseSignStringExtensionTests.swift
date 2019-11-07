//
//  ReverseSignStringExtensionTests.swift
//  CalculatorTests
//
//  Created by Benjamin Frost on 7/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import XCTest
@testable import Calculator

class ReverseSignStringExtensionTests: XCTestCase {

    var state: ICalculator!
    
    override func setUp() {
        self.state = CalculatorStateMachine()
    }


    // MARK: - Numerals
    
    func testReversingSign() {
        XCTAssertEqual("Hello".withLeadingMinusSignToggled(), "-Hello")
        XCTAssertEqual("Hello".withLeadingMinusSignToggled().withLeadingMinusSignToggled(), "Hello")
    }
    
    func testEmptyString() {
        XCTAssertEqual("".withLeadingMinusSignToggled(), "-")
        XCTAssertEqual("".withLeadingMinusSignToggled().withLeadingMinusSignToggled(), "")
    }

}
