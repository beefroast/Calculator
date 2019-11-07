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



enum CalculatorInput {
    case numeral(String)
    case dyadic(DyadicOperator)
    case reverseSign
    case percent
    case equals
    case clear
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

class CalculatorStateMachineOutput {
    
    let display: String
    let clearButtonText: String
    let highlightedButton: DyadicOperator?
    
    init(display: String, clearButtonText: String = "C", highlightedButton: DyadicOperator? = nil) {
        self.display = display
        self.clearButtonText = clearButtonText
        self.highlightedButton = highlightedButton
    }
}


class CalculatorStateMachine {
    
    enum CalculatorError: Error {
        case invalidInput
        case divisionByZero
    }
    
    private var state = CalculatorState.awaitingInput
    
    func updateState(input: CalculatorInput) -> CalculatorStateMachineOutput {
    
        do {
            switch input {
            case .numeral(let numeral): return self.handle(numeral: numeral)
            case .dyadic(let dyadic): return try self.handle(dyadic: dyadic)
            case .reverseSign: return self.handleReverseSign()
            case .percent: return try self.handlePercent()
            case .equals: return try self.handleEquals()
            case .clear: return self.handleClear()
            }
        } catch (let error) {
            self.state = .error
            return CalculatorStateMachineOutput(display: "Error")
        }
    }
    
    private func handle(numeral: String) -> CalculatorStateMachineOutput {
        
        switch self.state {
            
        case .error:
            return CalculatorStateMachineOutput(display: "Error")
         
         case .awaitingInput:
            
            switch numeral {
            
            case "0":
                return CalculatorStateMachineOutput(display: numeral)
                
            case ".":
                self.state = .inputtingFirstNumber("0.")
                return CalculatorStateMachineOutput(display: "0.")
                
            default:
                self.state = .inputtingFirstNumber(numeral)
                return CalculatorStateMachineOutput(display: numeral)
                
            }
             
         case .inputtingFirstNumber(let currentNum):
            
            guard (currentNum.contains(".") && numeral == ".") == false else {
                return CalculatorStateMachineOutput(display: currentNum)
            }
            
            let result = currentNum + numeral
            self.state = .inputtingFirstNumber(result)
            return CalculatorStateMachineOutput(display: result)
             
         case .inputtedDyadic(let previousNumber, let op):
            
            switch numeral {
                
            case "0":
                self.state = .inputtingSecondNumber(previousNumber, op, numeral)
                return CalculatorStateMachineOutput(display: numeral, clearButtonText: "C", highlightedButton: op)
                
                 
             case ".":
                self.state = .inputtingSecondNumber(previousNumber, op, "0.")
                return CalculatorStateMachineOutput(display: "0.", clearButtonText: "C", highlightedButton: op)
                 
             default:
                 self.state = .inputtingSecondNumber(previousNumber, op, numeral)
                 return CalculatorStateMachineOutput(display: numeral, clearButtonText: "C", highlightedButton: op)
            }
             
         case .inputtingSecondNumber(let previousNumber, let op, let currentNum):
            let result = currentNum + numeral
            self.state = .inputtingSecondNumber(previousNumber, op, result)
            return CalculatorStateMachineOutput(display: result, clearButtonText: "C", highlightedButton: op)
             
         case .showingResult(_, _, _):
             self.state = .inputtingFirstNumber(numeral)
            return CalculatorStateMachineOutput(display: numeral)
         
         }
    }
    
    private func handle(dyadic: DyadicOperator) throws -> CalculatorStateMachineOutput {
        
         switch state {
             
         case .awaitingInput:
            self.state = .inputtedDyadic("0", dyadic)
            return CalculatorStateMachineOutput(display: "0", clearButtonText: "C", highlightedButton: dyadic)
             
         case .inputtingFirstNumber(let a):
            self.state = .inputtedDyadic(a, dyadic)
            return CalculatorStateMachineOutput(display: a, clearButtonText: "C", highlightedButton: dyadic)
             
         case .inputtedDyadic(let a, let op):
             self.state = .inputtedDyadic(a, dyadic)
            return CalculatorStateMachineOutput(display: a, clearButtonText: "C", highlightedButton: dyadic)
             
         case .inputtingSecondNumber(let a, let op, let b):
                let calculatedValue = try self.performOperation(a: a, b: b, dyadic: op)
                self.state = .inputtedDyadic(calculatedValue, dyadic)
                return CalculatorStateMachineOutput(display: calculatedValue, clearButtonText: "C", highlightedButton: dyadic)
             
         case .showingResult(let a, _, let b):
            self.state = .inputtedDyadic(a, dyadic)
            return CalculatorStateMachineOutput(display: a)
            
         case .error:
            return CalculatorStateMachineOutput(display: "Error")
            
         }
    }
    
    private func performOperation(a: String, b: String, dyadic: DyadicOperator) throws -> String {
        
        // TODO: Conversions could be better
        guard let aDouble = Double(a), let bDouble = Double(b) else {
            throw CalculatorError.invalidInput
        }
        
        let value = try self.performOperation(a: aDouble, b: bDouble, dyadic: dyadic)
        let stringValue = String(value)
        
        // Remove the trailing .0 if we've got an integer value
        if stringValue.suffix(2) == ".0" {
            return String(stringValue.dropLast(2))
        } else {
            return stringValue
        }
    }
    
    private func performOperation(a: Double, b: Double, dyadic: DyadicOperator) throws -> Double {
        switch dyadic {
        case .plus: return a + b
        case .minus: return a - b
        case .multiply: return a * b
        case .divide:
            guard b != 0 else { throw CalculatorError.divisionByZero }
            return a / b
        }
    }
    
    private func handleReverseSign() -> CalculatorStateMachineOutput {
        
        switch state {

        case .error:
            return CalculatorStateMachineOutput(display: "Error")

        case .awaitingInput:
            return CalculatorStateMachineOutput(display: "0")

        case .inputtingFirstNumber(let a):
            
            guard a != "0." else {
                // -0 is the same as zero, so we're still awaiting input
                self.state = .awaitingInput
                return CalculatorStateMachineOutput(display: "0")
            }
            
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtingFirstNumber(result)
            return CalculatorStateMachineOutput(display: result)

        case .inputtedDyadic(let a, let op):
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtedDyadic(result, op)
            return CalculatorStateMachineOutput(display: result)

        case .inputtingSecondNumber(let a, let op, let b):
            
            guard b != "0." else {
                // -0 is the same as zero, so we're still awaiting input
                self.state = .inputtedDyadic(a, op)
                return CalculatorStateMachineOutput(display: "0")
            }
            
            let result = b.withLeadingMinusSignToggled()
            self.state = .inputtingSecondNumber(a, op, result)
            return CalculatorStateMachineOutput(display: result)

        case .showingResult(let a, let op, let b):
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtingSecondNumber(result, op, b)
            return CalculatorStateMachineOutput(display: result)
        }
        
    }
    
    
    private func handlePercent() throws -> CalculatorStateMachineOutput {
        
        switch self.state {
            
        case .error:
            return CalculatorStateMachineOutput(display: "Error")
            
        case .awaitingInput:
            return CalculatorStateMachineOutput(display: "0")
            
        case .inputtingFirstNumber(let a):
            let result = try self.performOperation(a: a, b: "100", dyadic: .divide)
            self.state = .inputtingFirstNumber(result)
            return CalculatorStateMachineOutput(display: result)
            
        case .inputtedDyadic(let a, let op):
            let percent = try self.performOperation(a: a, b: "100", dyadic: .divide)
            let result = try self.performOperation(a: a, b: percent, dyadic: .multiply)
            self.state = .inputtedDyadic(result, op)
            return CalculatorStateMachineOutput(display: result)
            
        case .inputtingSecondNumber(let a, let op, let b):
            self.state = .error
            return CalculatorStateMachineOutput(display: "Error")
            
        case .showingResult(let a, let op, let b):
            self.state = .error
            return CalculatorStateMachineOutput(display: "Error")
            
        }
        
    }
    
    private func handleEquals() throws -> CalculatorStateMachineOutput {
        switch self.state {
        
        case .error:
            return CalculatorStateMachineOutput(display: "Error")
        
        case .awaitingInput:
            return CalculatorStateMachineOutput(display: "0")
            
        case .inputtingFirstNumber(let num):
            return CalculatorStateMachineOutput(display: num)
            
        case .inputtedDyadic(let a, let dyadic):
            let result = try self.performOperation(a: a, b: a, dyadic: dyadic)
            self.state = .showingResult(result, dyadic, a)
            return CalculatorStateMachineOutput(display: result)
            
        case .inputtingSecondNumber(let a, let op, let b):
            let result = try self.performOperation(a: a, b: b, dyadic: op)
            self.state = .showingResult(result, op, b)
            return CalculatorStateMachineOutput(display: result)
            
        case .showingResult(let a, let op, let b):
            let result = try self.performOperation(a: a, b: b, dyadic: op)
            self.state = .showingResult(result, op, b)
            return CalculatorStateMachineOutput(display: result)
            
        }
    }
    
    private func handleClear() -> CalculatorStateMachineOutput {
        
        switch self.state {
            
        case .error:
            self.state = .awaitingInput
            return CalculatorStateMachineOutput(display: "0")
            
        case .awaitingInput:
            return CalculatorStateMachineOutput(display: "0")
            
        case .inputtingFirstNumber(_):
            self.state = .awaitingInput
            return CalculatorStateMachineOutput(display: "0")
            
        case .inputtedDyadic(let a, _):
            self.state = .inputtingFirstNumber(a)
            return CalculatorStateMachineOutput(display: a)
            
        case .inputtingSecondNumber(let a, let op, _):
            self.state = .inputtedDyadic(a, op)
            return CalculatorStateMachineOutput(display: "0")
            
        case .showingResult(_, _, _):
            return CalculatorStateMachineOutput(display: "0")
            
        }

    }
}



extension String {
    func withLeadingMinusSignToggled() -> String {
        if self.prefix(1) == "-" {
            return String(self.suffix(1))
        } else {
            return "-" + self
        }
    }
}
