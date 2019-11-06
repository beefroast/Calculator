//
//  CalculatorStateMachine.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation

// Dyadic Operators work on two numbers
enum DyadicOperator {
    case plus
    case minus
    case multiply
    case divide
}

enum CalculatorState {
    
    // The calculator has attempted to divide by zero, or some other error has occured
    case error
    
    // We've inputted nothing, so we're awaiting input
    case awaitingInput
    
    // We're inputting our first number
    case inputtingFirstNumber(String)
    
    // We've inputted a number and a dyadic operator
    case inputtedDyadic(String, DyadicOperator)
    
    // We're inputting our second number
    case inputtingSecondNumber(String, DyadicOperator, String)
    
    // We're showing the result of a calculation with a dyadic operator
    case showingResult(String, DyadicOperator, String)
}

enum CalculatorInput {
    case numeral(String)
    case dyadic(DyadicOperator)
    case reverseSign
    case percent
    case equals
    case clear
}


class CalculatorStateMachine {
    
    private var state = CalculatorState.awaitingInput
    
    func updateState(input: CalculatorInput) -> String {
    
        switch input {
        case .numeral(let numeral): return self.handle(numeral: numeral)
        case .dyadic(let dyadic): return self.handle(dyadic: dyadic)
        case .reverseSign: return self.handleReverseSign()
        case .percent: return self.handlePercent()
        case .equals: return self.handleEquals()
        case .clear: return self.handleClear()
        }
        
    }
    
    private func handle(numeral: String) -> String {
        
        switch self.state {
            
        case .error:
            return "Error"
         
         case .awaitingInput:
            self.state = .inputtingFirstNumber(numeral)
            return numeral
             
         case .inputtingFirstNumber(let currentNum):
            let result = currentNum + numeral
            self.state = .inputtingFirstNumber(result)
            return result
             
         case .inputtedDyadic(let previousNumber, let op):
            self.state = .inputtingSecondNumber(previousNumber, op, numeral)
            return numeral
             
         case .inputtingSecondNumber(let previousNumber, let op, let currentNum):
            let result = currentNum + numeral
            self.state = .inputtingSecondNumber(previousNumber, op, result)
            return result
             
         case .showingResult(_, _, _):
             self.state = .inputtingFirstNumber(numeral)
            return numeral
         
         }
    }
    
    private func handle(dyadic: DyadicOperator) -> String {
        
         switch state {
             
         case .awaitingInput:
            self.state = .inputtedDyadic("0", dyadic)
            return "0"
             
         case .inputtingFirstNumber(let a):
            self.state = .inputtedDyadic(a, dyadic)
            return a
             
         case .inputtedDyadic(let a, let op):
             self.state = .inputtedDyadic(a, dyadic)
            return a
             
         case .inputtingSecondNumber(let a, let op, let b):
            let calculatedValue = self.performOperation(a: a, b: b, dyadic: dyadic)
            self.state = .showingResult(calculatedValue, op, b)
            return calculatedValue
             
         case .showingResult(let a, _, let b):
            self.state = .inputtedDyadic(b, dyadic)
            return b
            
         case .error:
            return "Error"
            
         }
    }
    
    private func performOperation(a: String, b: String, dyadic: DyadicOperator) -> String {
        // TODO: Conversion needs to be better so we don't get weird
        // floating point number inaccuracies
        let value = self.performOperation(a: Double(a)!, b: Double(b)!, dyadic: dyadic)
        return String(value)
    }
    
    private func performOperation(a: Double, b: Double, dyadic: DyadicOperator) -> Double {
        switch dyadic {
        case .plus: return a + b
        case .minus: return a - b
        case .multiply: return a * b
        case .divide: return a / b
        }
    }
    
    private func handleReverseSign() -> String {
        
//        switch state {
//
//        case .error:
//            return "Error"
//
//        case .awaitingInput:
//            return "0"
//
//        case .inputtingFirstNumber(let a):
//            self.state = .inputtingFirstNumber(a.withLeadingMinusSignToggled())
//            return
//
//        case .inputtedDyadic(let a, let op):
//            self.state = .inputtedDyadic(a.withLeadingMinusSignToggled(), op)
//
//        case .inputtingSecondNumber(let a, let op, let b):
//            self.state = .inputtingSecondNumber(a, op, b.withLeadingMinusSignToggled())
//
//        case .showingResult(let a, let op, let b):
//            self.state = .inputtingSecondNumber(a, op, b.withLeadingMinusSignToggled())
//
//        }
        
        return ""
    }
    
    private func handlePercent() -> String {
        fatalError()
    }
    
    private func handleEquals() -> String {
        fatalError()
    }
    
    private func handleClear() -> String {
        self.state = .awaitingInput
        return "0"
    }
    
    
    
    
    
}
