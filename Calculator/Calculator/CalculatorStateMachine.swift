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
            
            switch numeral {
            
            case "0":
                return numeral
                
            case ".":
                self.state = .inputtingFirstNumber("0.")
                return "0."
                
            default:
                self.state = .inputtingFirstNumber(numeral)
                return numeral
                
            }
             
         case .inputtingFirstNumber(let currentNum):
            
            guard (currentNum.contains(".") && numeral == ".") == false else {
                return currentNum
            }
            
            let result = currentNum + numeral
            self.state = .inputtingFirstNumber(result)
            return result
             
         case .inputtedDyadic(let previousNumber, let op):
            
            switch numeral {
                
            case "0":
                 return numeral
                 
             case ".":
                self.state = .inputtingSecondNumber(previousNumber, op, "0.")
                return "0."
                 
             default:
                 self.state = .inputtingSecondNumber(previousNumber, op, numeral)
                 return numeral   
            }
             
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
            let calculatedValue = self.performOperation(a: a, b: b, dyadic: op)
            self.state = .inputtedDyadic(calculatedValue, dyadic)
            return calculatedValue
             
         case .showingResult(let a, _, let b):
            self.state = .inputtedDyadic(a, dyadic)
            return a
            
         case .error:
            return "Error"
            
         }
    }
    
    private func performOperation(a: String, b: String, dyadic: DyadicOperator) -> String {
        
        // TODO: Conversions could be better
        let value = self.performOperation(a: Double(a)!, b: Double(b)!, dyadic: dyadic)
        let stringValue = String(value)
        
        // Remove the trailing .0 if we've got an integer value
        if stringValue.suffix(2) == ".0" {
            return String(stringValue.dropLast(2))
        } else {
            return stringValue
        }
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
        
        switch state {

        case .error:
            return "Error"

        case .awaitingInput:
            return "0"

        case .inputtingFirstNumber(let a):
            
            guard a != "0." else {
                // -0 is the same as zero, so we're still awaiting input
                self.state = .awaitingInput
                return "0"
            }
            
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtingFirstNumber(result)
            return result

        case .inputtedDyadic(let a, let op):
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtedDyadic(result, op)
            return result

        case .inputtingSecondNumber(let a, let op, let b):
            
            guard b != "0." else {
                // -0 is the same as zero, so we're still awaiting input
                self.state = .inputtedDyadic(a, op)
                return "0"
            }
            
            let result = b.withLeadingMinusSignToggled()
            self.state = .inputtingSecondNumber(a, op, result)
            return result

        case .showingResult(let a, let op, let b):
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtingSecondNumber(result, op, b)
            return result
        }
        
    }
    
    
    private func handlePercent() -> String {
        
        switch self.state {
            
        case .error:
            return "Error"
            
        case .awaitingInput:
            return "0"
            
        case .inputtingFirstNumber(let a):
            let result = self.performOperation(a: a, b: "100", dyadic: .divide)
            self.state = .inputtingFirstNumber(result)
            return result
            
        case .inputtedDyadic(let a, let op):
            let percent = self.performOperation(a: a, b: "100", dyadic: .divide)
            let result = self.performOperation(a: a, b: percent, dyadic: .multiply)
            self.state = .inputtedDyadic(result, op)
            return result
            
        case .inputtingSecondNumber(let a, let op, let b):
            self.state = .error
            return "Error"
            
        case .showingResult(let a, let op, let b):
            self.state = .error
            return "Error"
            
        }
        
    }
    
    private func handleEquals() -> String {
        switch self.state {
        
        case .error:
            return "Error"
        
        case .awaitingInput:
            return "0"
            
        case .inputtingFirstNumber(let num):
            return num
            
        case .inputtedDyadic(let a, let dyadic):
            let result = self.performOperation(a: a, b: a, dyadic: dyadic)
            self.state = .showingResult(result, dyadic, a)
            return result
            
        case .inputtingSecondNumber(let a, let op, let b):
            let result = self.performOperation(a: a, b: b, dyadic: op)
            self.state = .showingResult(result, op, b)
            return result
            
        case .showingResult(let a, let op, let b):
            let result = self.performOperation(a: a, b: b, dyadic: op)
            self.state = .showingResult(result, op, b)
            return result
            
        }
    }
    
    private func handleClear() -> String {
        self.state = .awaitingInput
        return "0"
    }
    
    
    
    
    
}
