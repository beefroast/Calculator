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

    var state: ICalculator!
    
    override func setUp() {
        self.state = CalculatorNodeStateMachine()
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
    
    func testHugeNumber() {
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "10")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "100")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "1000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "10000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "100000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "1000000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "10000000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "100000000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "1000000000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "10000000000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "100000000000")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "1000000000000")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "1E12")
        XCTAssertEqual(state.updateState(input: .clear).display, "1000000000000")
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
    
    func testRunOnSubtraction() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "7")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "6")
    }
    
    func testOrderOfOperationsWithRunOnSubtraction() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.multiply)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "7")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "6")
    }
    
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
    
    func testOperatorOverridesLast() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.multiply)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("6")).display, "6")
        XCTAssertEqual(state.updateState(input: .equals).display, "12")
    }
    
    func testOperationOfApplicationMultiplication() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
        XCTAssertEqual(state.updateState(input: .dyadic(.multiply)).display, "3")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "4")
        XCTAssertEqual(state.updateState(input: .equals).display, "14")
    }
    
    func testOperationOfApplicationDivision() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "10")
        XCTAssertEqual(state.updateState(input: .dyadic(.divide)).display, "10")
        XCTAssertEqual(state.updateState(input: .numeral("5")).display, "5")
        XCTAssertEqual(state.updateState(input: .equals).display, "4")
    }
    
    func testEqualsDoesNotMuchAfterAlreadyPressedWithoutDyadic() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .equals).display, "2")
        XCTAssertEqual(state.updateState(input: .equals).display, "2")
        XCTAssertEqual(state.updateState(input: .equals).display, "2")
    }
    
    func testPressingOperatorWithoutInputShouldPrefixZero() {
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).calculation, "0 + ")
    }
    
    func testEqualsAfterOperator() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).calculation, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).calculation, "2 + ")
        XCTAssertEqual(state.updateState(input: .equals).calculation, "2 + ")
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
    
    func testRunOnAdditionWithEqualsPressed() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "4")
        XCTAssertEqual(state.updateState(input: .equals).display, "12")
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
    
    func testDoubleClear() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("7")).display, "7")
        XCTAssertEqual(state.updateState(input: .clear).display, "0")
        XCTAssertEqual(state.updateState(input: .clear).calculation, "")
    }
    
    func testClearAfterFunctionalOperator() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .percent).display, "0.02")
        XCTAssertEqual(state.updateState(input: .clear).display, "2")
    }
    
    func testClearingOperator() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).calculation, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).calculation, "2 + ")
        XCTAssertEqual(state.updateState(input: .clear).calculation, "2")
    }
    
    func testClearResult() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .equals).display, "4")
        XCTAssertEqual(state.updateState(input: .clear).calculation, "")
    }
    
    func testClearBackToPreviousOperator() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "5")
        XCTAssertEqual(state.updateState(input: .clear).display, "3")
    }
    
    // MARK: - Reverse sign
    
    func testReverseSign() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "-2")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "2")
    }
    
    func testMultipleReverseSign() {
        // NOTE: This deviates from the MacOS calculator implementation, but I find it more convenient.
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "-2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "-23")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "23")
        XCTAssertEqual(state.updateState(input: .numeral("4")).display, "234")
    }
    
    func testReverseSignOnNoInput() {
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "0")
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
    }
    
    func testReverseSignAfterDecimal() {
        XCTAssertEqual(state.updateState(input: .numeral(".")).display, "0.")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "0.")
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "0.2")
    }
    
    func testReverseSignOnSecondValue() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "-3")
        XCTAssertEqual(state.updateState(input: .equals).display, "-1")
    }

    func testReverseAfterOperator() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "2")
        XCTAssertEqual(state.updateState(input: .reverseSign).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("3")).display, "3")
    }
    

    // MARK: - Test Percent
    
    func testPercentOnNoInput() {
        XCTAssertEqual(state.updateState(input: .percent).display, "0")
    }
    
    func testPercent() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .percent).display, "0.08")
    }
    
    func testPercentAfterMultiplication() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "80")
        XCTAssertEqual(state.updateState(input: .dyadic(.multiply)).display, "80")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "10")
        XCTAssertEqual(state.updateState(input: .percent).display, "0.1")
        XCTAssertEqual(state.updateState(input: .equals).display, "8")
    }
    
    func testPercentAfterAddition() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "80")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "80")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "10")
        XCTAssertEqual(state.updateState(input: .percent).display, "0.1")
        XCTAssertEqual(state.updateState(input: .equals).display, "88")
        XCTAssertEqual(state.updateState(input: .equals).display, "96.8")
    }
    
    func testSpecialPercentSubtractionCase() {
        XCTAssertEqual(state.updateState(input: .numeral("8")).display, "8")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "80")
        XCTAssertEqual(state.updateState(input: .dyadic(.minus)).display, "80")
        XCTAssertEqual(state.updateState(input: .numeral("1")).display, "1")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "10")
        XCTAssertEqual(state.updateState(input: .percent).display, "0.1")
        XCTAssertEqual(state.updateState(input: .equals).display, "72")
    }
    
    func testPercentAfterEqualsCalculation() {
        XCTAssertEqual(state.updateState(input: .numeral("5")).display, "5")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "50")
        XCTAssertEqual(state.updateState(input: .dyadic(.plus)).display, "50")
        XCTAssertEqual(state.updateState(input: .numeral("5")).display, "5")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "50")
        XCTAssertEqual(state.updateState(input: .equals).display, "100")
        XCTAssertEqual(state.updateState(input: .percent).calculation, "(50 + 50)%")
    }
    
    
    // MARK: - Test errors

    func testDividingByZero() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.divide)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("0")).display, "0")
        XCTAssertEqual(state.updateState(input: .equals).display, "Error")
    }
    
    func testInvalidInput() {
        XCTAssertEqual(state.updateState(input: .numeral("2")).display, "2")
        XCTAssertEqual(state.updateState(input: .dyadic(.divide)).display, "2")
        XCTAssertEqual(state.updateState(input: .numeral("Kittens")).display, "Kittens")
        XCTAssertEqual(state.updateState(input: .equals).display, "Error")
    }
    
    
}
