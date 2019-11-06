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

    var state = CalculatorStateMachine()
    
    override func setUp() {
        self.state = CalculatorStateMachine()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Numerals
    
    func testDisplayingNumerals() {
        XCTAssertEqual(state.updateState(input: .numeral("9")), "9")
        XCTAssertEqual(state.updateState(input: .numeral("0")), "90")
        XCTAssertEqual(state.updateState(input: .numeral("2")), "902")
    }
    
    func testLeadingZeroes() {
        XCTAssertEqual(state.updateState(input: .numeral("0")), "0")
        XCTAssertEqual(state.updateState(input: .numeral("0")), "0")
        XCTAssertEqual(state.updateState(input: .numeral("0")), "0")
        XCTAssertEqual(state.updateState(input: .numeral("2")), "2")
        XCTAssertEqual(state.updateState(input: .numeral("0")), "20")
    }
    
    // MARK: - Decimal places
    
    func testDecimalPlace() {
        XCTAssertEqual(state.updateState(input: .numeral("2")), "2")
        XCTAssertEqual(state.updateState(input: .numeral(".")), "2.")
        XCTAssertEqual(state.updateState(input: .numeral("7")), "2.7")
    }
    
    func testLeadingZeroOnDecimalPlace() {
        XCTAssertEqual(state.updateState(input: .numeral(".")), "0.")
        XCTAssertEqual(state.updateState(input: .numeral("2")), "0.2")
        XCTAssertEqual(state.updateState(input: .numeral("3")), "0.23")
    }
    
    func testMultipleDecimalPlaces() {
        XCTAssertEqual(state.updateState(input: .numeral("2")), "2")
        XCTAssertEqual(state.updateState(input: .numeral(".")), "2.")
        XCTAssertEqual(state.updateState(input: .numeral("3")), "2.3")
        XCTAssertEqual(state.updateState(input: .numeral(".")), "2.3")
        XCTAssertEqual(state.updateState(input: .numeral("4")), "2.34")
    }
    
    func testOperatorWithDecimalPlace() {
        XCTAssertEqual(state.updateState(input: .numeral(".")), "0.")
        XCTAssertEqual(state.updateState(input: .numeral("2")), "0.2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)), "0.2")
        XCTAssertEqual(state.updateState(input: .numeral(".")), "0.")
        XCTAssertEqual(state.updateState(input: .numeral("3")), "0.3")
        XCTAssertEqual(state.updateState(input: .equals), "0.5")
    }
    
    // MARK: - Test operators
    
    func testBasicAddition() {
        XCTAssertEqual(state.updateState(input: .numeral("8")), "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)), "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")), "4")
        XCTAssertEqual(state.updateState(input: .equals), "12")
    }
    
    func testBasicSubtraction() {
        XCTAssertEqual(state.updateState(input: .numeral("8")), "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)), "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")), "4")
        XCTAssertEqual(state.updateState(input: .equals), "4")
    }
    
    func testBasicMultiplication() {
        XCTAssertEqual(state.updateState(input: .numeral("8")), "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.multiply)), "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")), "4")
        XCTAssertEqual(state.updateState(input: .equals), "32")
    }
    
    func testBasicDivision() {
        XCTAssertEqual(state.updateState(input: .numeral("8")), "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.divide)), "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")), "4")
        XCTAssertEqual(state.updateState(input: .equals), "2")
    }
    
    
    // MARK: - Test combinations
    

    
    func testRunOnAddition() {
        XCTAssertEqual(state.updateState(input: .numeral("8")), "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)), "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")), "4")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)), "12")
        XCTAssertEqual(state.updateState(input: .numeral("7")), "7")
        XCTAssertEqual(state.updateState(input: .equals), "19")
    }
    
    func testMultipleEqualsAddition() {
        XCTAssertEqual(state.updateState(input: .numeral("8")), "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)), "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")), "4")
        XCTAssertEqual(state.updateState(input: .equals), "12")
        XCTAssertEqual(state.updateState(input: .equals), "16")
        XCTAssertEqual(state.updateState(input: .equals), "20")
        XCTAssertEqual(state.updateState(input: .equals), "24")
    }
    
    func testAdditionFirst() {
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)), "0")
        XCTAssertEqual(state.updateState(input: .numeral("8")), "8")
        XCTAssertEqual(state.updateState(input: .equals), "8")
        XCTAssertEqual(state.updateState(input: .equals), "16")
    }
    
    // MARK: - Clear
    
    func testEmptyClear() {
        XCTAssertEqual(state.updateState(input: .clear), "0")
    }
    
    func testClearNumber() {
        XCTAssertEqual(state.updateState(input: .numeral("2")), "2")
        XCTAssertEqual(state.updateState(input: .clear), "0")
    }
    
    // MARK: - Reverse sign
    
    func testReverseSign() {
        XCTAssertEqual(state.updateState(input: .numeral("2")), "2")
        XCTAssertEqual(state.updateState(input: .reverseSign), "-2")
        XCTAssertEqual(state.updateState(input: .reverseSign), "2")
    }

}