//
//  CalculatorStateMachine.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation



/// Implementation of ICalculator that uses a state machine structure to process input events
class CalculatorStateMachine: ICalculator {
    
    /// Represents an error in the calculator state machine.
    enum CalculatorError: Error {
        
        /// An input to the state machine was invalid.
        case invalidInput
        
        /// Division by zero was attempted.
        case divisionByZero
    }
    
    
    /// The possible states of the CalculatorStateMachine
    enum CalculatorState {
        
        /// Error state representing bad input or division by zero
        case error
        
        /// Nothing has been inputted by the user
        case awaitingInput
        
        /// The user is inputting their first numerical value
        case inputtingFirstNumber(String)
        
        /// The user has inputted a numerical value and a dyadic operator
        case inputtedDyadic(String, DyadicOperator)
        
        /// The user has inputted a numerical value and a dyadic operator, and is inputting a second number.
        case inputtingSecondNumber(String, DyadicOperator, String)
        
        /// Showing the result of a calculation with the given values and dyadic operator.
        case showingResult(String, DyadicOperator, String)
    }
    
    /// The state of the state machine
    private var state = CalculatorState.awaitingInput
    
    
    /**
       Updates the state of the calculator
       - Parameter input: The input into the calculator.
       - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
    */
    func updateState(input: CalculatorInput) -> CalculatorOutput {
    
        let s = _updateState(input: input)
        switch self.state {
//        case .inputtingFirstNumber(let a): return s.with(calculation: a)
//        case .inputtedDyadic(let a, let op): return s.with(calculation: a + symbolForDyadic(op: op))
//        case .inputtingSecondNumber(let a, let op, let b): return s.with(calculation: a + symbolForDyadic(op: op) + b)
//        case .showingResult(let a, let op, let b): return s.with(calculation: a + symbolForDyadic(op: op) + b)
        default: return s
        }
    }

    func symbolForDyadic(op: DyadicOperator) -> String {
        switch op {
        case .divide: return "÷"
        case .minus: return "−"
        case .multiply: return "×"
        case .plus: return "+"
        }
    }
    
    func _updateState(input: CalculatorInput) -> CalculatorOutput {
    
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
            return CalculatorOutput(display: "Error")
        }
    }
    
    
    
    /**
        Handler for numerical input.
       - Parameter numeral: The numeral that was inputted.
       - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
    */
    private func handle(numeral: String) -> CalculatorOutput {
        
        switch self.state {
            
        case .error:
            return CalculatorOutput(display: "Error", clearButtonText: "AC")
         
         case .awaitingInput:
            
            switch numeral {
            
            case "0":
                return CalculatorOutput(display: numeral)
                
            case ".":
                self.state = .inputtingFirstNumber("0.")
                return CalculatorOutput(display: "0.")
                
            default:
                self.state = .inputtingFirstNumber(numeral)
                return CalculatorOutput(display: numeral)
                
            }
             
         case .inputtingFirstNumber(let currentNum):
            
            guard (currentNum.contains(".") && numeral == ".") == false else {
                return CalculatorOutput(display: currentNum)
            }
            
            let result = currentNum + numeral
            self.state = .inputtingFirstNumber(result)
            return CalculatorOutput(display: result)
             
         case .inputtedDyadic(let previousNumber, let op):
            
            switch numeral {
                
            case "0":
                self.state = .inputtingSecondNumber(previousNumber, op, numeral)
                return CalculatorOutput(display: numeral, clearButtonText: "C", highlightedButton: op)
                
                 
             case ".":
                self.state = .inputtingSecondNumber(previousNumber, op, "0.")
                return CalculatorOutput(display: "0.", clearButtonText: "C", highlightedButton: op)
                 
             default:
                 self.state = .inputtingSecondNumber(previousNumber, op, numeral)
                 return CalculatorOutput(display: numeral, clearButtonText: "C", highlightedButton: op)
            }
             
         case .inputtingSecondNumber(let previousNumber, let op, let currentNum):
            let result = currentNum + numeral
            self.state = .inputtingSecondNumber(previousNumber, op, result)
            return CalculatorOutput(display: result, clearButtonText: "C", highlightedButton: op)
             
         case .showingResult(_, _, _):
            self.state = .awaitingInput
            return self.handle(numeral: numeral)
         
         }
    }
    
    /**
        Handler for dyadic operator  input.
       - Parameter dyadic: The operator that was inputted
       - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
    */
    private func handle(dyadic: DyadicOperator) throws -> CalculatorOutput {
        
         switch state {
             
         case .awaitingInput:
            self.state = .inputtedDyadic("0", dyadic)
            return CalculatorOutput(display: "0", clearButtonText: "C", highlightedButton: dyadic)
             
         case .inputtingFirstNumber(let a):
            self.state = .inputtedDyadic(a, dyadic)
            return CalculatorOutput(display: a, clearButtonText: "C", highlightedButton: dyadic)
             
         case .inputtedDyadic(let a, let op):
             self.state = .inputtedDyadic(a, dyadic)
            return CalculatorOutput(display: a, clearButtonText: "C", highlightedButton: dyadic)
             
         case .inputtingSecondNumber(let a, let op, let b):
                let calculatedValue = try self.performOperation(a: a, b: b, dyadic: op)
                self.state = .inputtedDyadic(calculatedValue, dyadic)
                return CalculatorOutput(display: calculatedValue, clearButtonText: "C", highlightedButton: dyadic)
             
         case .showingResult(let a, _, let b):
            self.state = .inputtedDyadic(a, dyadic)
            return CalculatorOutput(display: a, clearButtonText: "C", highlightedButton: dyadic)
            
         case .error:
            return CalculatorOutput(display: "Error")
            
         }
    }
    
    /**
        Performs a dyadic operator on the given inputs and returns the result.
        - Parameter a: The left hand side of the equation.
        - Parameter a: The right hand side of the equation.
        - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
        - Throws: `CalculatorError.invalidInput` if either of the strings cannot be parsed as numbers.
        - Throws: `CalculatorError.divisionByZero` if division by zero was to be performed.
    */
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
    
    /**
        Performs a dyadic operator on the given inputs and returns the result.
        - Parameter a: The left hand side of the equation.
        - Parameter a: The right hand side of the equation.
        - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
        - Throws: `CalculatorError.invalidInput` if either of the strings cannot be parsed as numbers.
        - Throws: `CalculatorError.divisionByZero` if division by zero was to be performed.
    */
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
    
    /**
        Handler for the reverse sign input.
        - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
    */
    private func handleReverseSign() -> CalculatorOutput {
        
        switch state {

        case .error:
            return CalculatorOutput(display: "Error")

        case .awaitingInput:
            return CalculatorOutput(display: "0")

        case .inputtingFirstNumber(let a):
            
            guard a != "0." else {
                // -0 is the same as zero, so we're still awaiting input
                self.state = .awaitingInput
                return CalculatorOutput(display: "0")
            }
            
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtingFirstNumber(result)
            return CalculatorOutput(display: result)

        case .inputtedDyadic(let a, let op):
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtedDyadic(result, op)
            return CalculatorOutput(display: result)

        case .inputtingSecondNumber(let a, let op, let b):
            
            guard b != "0." else {
                // -0 is the same as zero, so we're still awaiting input
                self.state = .inputtedDyadic(a, op)
                return CalculatorOutput(display: "0")
            }
            
            let result = b.withLeadingMinusSignToggled()
            self.state = .inputtingSecondNumber(a, op, result)
            return CalculatorOutput(display: result, clearButtonText: "AC")

        case .showingResult(let a, let op, let b):
            let result = a.withLeadingMinusSignToggled()
            self.state = .inputtingSecondNumber(result, op, b)
            return CalculatorOutput(display: result)
        }
        
    }
    
    /**
        Handler for the user pressing the percent button
        - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
        - Throws: `CalculatorError.invalidInput` if either of the strings cannot be parsed as numbers.
        - Throws: `CalculatorError.divisionByZero` if division by zero was to be performed.
    */
    private func handlePercent() throws -> CalculatorOutput {
        
        switch self.state {
            
        case .error:
            return CalculatorOutput(display: "Error")
            
        case .awaitingInput:
            return CalculatorOutput(display: "0")
            
        case .inputtingFirstNumber(let a):
            let result = try self.performOperation(a: a, b: "100", dyadic: .divide)
            self.state = .inputtingFirstNumber(result)
            return CalculatorOutput(display: result)
            
        case .inputtedDyadic(let a, let op):
            let percent = try self.performOperation(a: a, b: "100", dyadic: .divide)
            let result = try self.performOperation(a: a, b: percent, dyadic: .multiply)
            self.state = .inputtedDyadic(result, op)
            return CalculatorOutput(display: result)
            
        case .inputtingSecondNumber(let a, let op, let b):
            let percent = try self.performOperation(a: b, b: "100", dyadic: .divide)
            let percentOfA = try self.performOperation(a: a, b: percent, dyadic: .multiply)
            self.state = .showingResult(a, op, percentOfA)
            return CalculatorOutput(display: percentOfA, clearButtonText: "AC")
            
        case .showingResult(let a, let op, let b):
            self.state = .error
            return CalculatorOutput(display: "Error")
            
        }
        
    }
    
    /**
        Handler for the equals input.
        - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
        - Throws: `CalculatorError.invalidInput` if either of the strings cannot be parsed as numbers.
        - Throws: `CalculatorError.divisionByZero` if division by zero was to be performed.
    */
    private func handleEquals() throws -> CalculatorOutput {
        switch self.state {
        
        case .error:
            return CalculatorOutput(display: "Error")
        
        case .awaitingInput:
            return CalculatorOutput(display: "0")
            
        case .inputtingFirstNumber(let num):
            return CalculatorOutput(display: num)
            
        case .inputtedDyadic(let a, let dyadic):
            let result = try self.performOperation(a: a, b: a, dyadic: dyadic)
            self.state = .showingResult(result, dyadic, a)
            return CalculatorOutput(display: result, clearButtonText: "AC")
            
        case .inputtingSecondNumber(let a, let op, let b):
            let result = try self.performOperation(a: a, b: b, dyadic: op)
            self.state = .showingResult(result, op, b)
            return CalculatorOutput(display: result, clearButtonText: "AC")
            
        case .showingResult(let a, let op, let b):
            let result = try self.performOperation(a: a, b: b, dyadic: op)
            self.state = .showingResult(result, op, b)
            return CalculatorOutput(display: result, clearButtonText: "AC")
            
        }
    }
    
    /**
        Handler for the clear input
        - Returns: a `CalculatorOutput` representing the displayable state of the calculator.
    */
    private func handleClear() -> CalculatorOutput {
        
        switch self.state {
            
        case .error:
            self.state = .awaitingInput
            return CalculatorOutput(display: "0", clearButtonText: "AC")
            
        case .awaitingInput:
            return CalculatorOutput(display: "0", clearButtonText: "AC")
            
        case .inputtingFirstNumber(_):
            self.state = .awaitingInput
            return CalculatorOutput(display: "0", clearButtonText: "AC")
            
        case .inputtedDyadic(let a, _):
            self.state = .inputtingFirstNumber(a)
            return CalculatorOutput(display: a, clearButtonText: "AC")
            
        case .inputtingSecondNumber(let a, let op, _):
            self.state = .inputtedDyadic(a, op)
            return CalculatorOutput(display: "0", clearButtonText: "C", highlightedButton: op)
            
        case .showingResult(_, _, _):
            self.state = .awaitingInput
            return CalculatorOutput(display: "0", clearButtonText: "AC")
            
        }

    }
}


