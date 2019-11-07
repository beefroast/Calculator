//
//  CalculatorStateMachineTests.swift
//  CalculatorTests
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorStateMachineTests: XCTestCase {

    var state: ICalculator = CalculatorStateMachine()
    
    override func setUp() {
        self.state = CalculatorStateMachine()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Numerals
    
    func testDisplayingNumerals() {
        XCTAssertEqual(state.updateState(input: .numeral("9")).display, "9")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "90")
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "902")
    }
    
    func testLeadingZeroes() {
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "0")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "0")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "0")
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "20")
    }
    
    // MARK: - Decimal places
    
    func testDecimalPlace() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral(".")).display, "2.")
        XCTAssertEqual(state.updateState(input: .numeral("7")).display, "2.7")
    }
    
    func testLeadingZeroOnDecimalPlace() {
        XCTAssertEqual(state.updateState(input: .numeral(".")).display, "0.")
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "0.2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "0.23")
    }
    
    func testMultipleDecimalPlaces() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral(".")).display, "2.")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "2.3")
        XCTAssertEqual(state.updateState(input: .numeral(".")).display, "2.3")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "2.34")
    }
    
    func testOperatorWithDecimalPlace() {
        XCTAssertEqual(state.updateState(input: .numeral(".")).display, "0.")
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "0.2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "0.2")
        XCTAssertEqual(state.updateState(input: .numeral(".")).display, "0.")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "0.3")
        XCTAssertEqual(state.updateState(input: .equals).display, "0.5")
    }
    
    // MARK: - Test operators
    
    func testBasicAddition() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "4")
        XCTAssertEqual(state.updateState(input: .equals).display, "12")
    }
    
    func testBasicSubtraction() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "4")
        XCTAssertEqual(state.updateState(input: .equals).display, "4")
    }
    
    func testBasicMultiplication() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.multiply)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "4")
        XCTAssertEqual(state.updateState(input: .equals).display, "32")
    }
    
    func testBasicDivision() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.divide)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "4")
        XCTAssertEqual(state.updateState(input: .equals).display, "2")
    }
    
    
    // MARK: - Test combinations
    

    
    func testRunOnAddition() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "4")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "12")
        XCTAssertEqual(state.updateState(input: .numeral("7")).display, "7")
        XCTAssertEqual(state.updateState(input: .equals).display, "19")
    }
    
    func testMultipleEqualsAddition() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "4")
        XCTAssertEqual(state.updateState(input: .equals).display, "12")
        XCTAssertEqual(state.updateState(input: .equals).display, "16")
        XCTAssertEqual(state.updateState(input: .equals).display, "20")
        XCTAssertEqual(state.updateState(input: .equals).display, "24")
    }
    
    func testAdditionFirst() {
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "0")
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .equals).display, "8")
        XCTAssertEqual(state.updateState(input: .equals).display, "16")
    }
    
    // MARK: - Clear
    
    func testEmptyClear() {
        XCTAssertEqual(state.updateState(input: .clear).display, "0")
    }
    
    func testClearNumber() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .clear).display, "0")
    }
    
    func testClearingCurrentNumber() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("7")).display, "7")
        XCTAssertEqual(state.updateState(input: .clear).display, "0")
        XCTAssertEqual(state.updateState(input: .numeral("9")).display, "9")
        XCTAssertEqual(state.updateState(input: .equals).display, "11")
    }
    
    // MARK: - Reverse sign
    
    func testReverseSign() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "-2")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "2")
    }
    
    func testInputAfterReversingSign() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "-2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
    }
    
    func testInputResettingAfterReverseSignOnSecondInput() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.multiply)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("6")).display, "6")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "-6")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
        XCTAssertEqual(state.updateState(input: .equals).display, "24")
    }

    
    
    // MARK: - Test Highlighting
    
    func testOperatorIsHighlighted() {
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).highlightedButton, .plus)
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).highlightedButton, .minus)
        XCTAssertEqual(state.updateState(input: .dyadic(.multiply)).highlightedButton, .multiply)
        XCTAssertEqual(state.updateState(input: .dyadic(.divide)).highlightedButton, .divide)
    }
    
    func testOperatorIsHighlightedUntilEquals() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).highlightedButton, nil)
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).highlightedButton, .plus)
        XCTAssertEqual(state.updateState(input: .numeral("2")).highlightedButton, .plus)
        XCTAssertEqual(state.updateState(input: .equals).highlightedButton, nil)
    }
    
    func testRunonOperatorHighlighting() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).highlightedButton, nil)
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).highlightedButton, .plus)
        XCTAssertEqual(state.updateState(input: .numeral("2")).highlightedButton, .plus)
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).highlightedButton, .minus)
        XCTAssertEqual(state.updateState(input: .numeral("1")).highlightedButton, .minus)
        XCTAssertEqual(state.updateState(input: .equals).highlightedButton, nil)
    }
    
    // MARK: - Assorted Weird Cases
    
    func testTwoResultsBackToBack() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
        XCTAssertEqual(state.updateState(input: .equals).display, "5")
        XCTAssertEqual(state.updateState(input: .numeral("9")).display, "9")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "9")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .equals).display, "8")
    }
    
    func testWeird() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("9")).display, "9")
        XCTAssertEqual(state.updateState(input: .equals).display, "17")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
        XCTAssertEqual(state.updateState(input: .equals).display, "12")
    }
    
    func testPushingInvalidCharacters() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("c")).display, "2c")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2c")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
        XCTAssertEqual(state.updateState(input: .equals).display, "Error")
    }
    
    func testDividingByZero() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.divide)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "0")
        XCTAssertEqual(state.updateState(input: .equals).display, "Error")
    }
    
}
