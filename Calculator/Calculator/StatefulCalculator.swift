//
//  StatefulCalculator.swift
//  Calculator
//
//  Created by Benjamin Frost on 7/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation


class StatefulCalculator: ICalculator {

    var shouldEnteringNumeralClearDisplay: Bool = false
    var accumulatedValue: String? = nil
    var currentInput: String? = nil
    var lastOperator: DyadicOperator? = nil

    func updateState(input: CalculatorInput) -> CalculatorOutput {
    
        do {
            switch input {
            case .numeral(let numeral): return self.handle(numeral: numeral)
            case .dyadic(let dyadic): return try self.handle(dyadic: dyadic)
            case .reverseSign: return self.handleReverseSign()
            case .percent: return try self.handlePercent()
            case .equals: return try self.handleEquals()
            case .clear: return self.handleClear()
            }
        } catch {
            return CalculatorOutput(display: "Error")
        }
    }
    
    private func handle(numeral: String) -> CalculatorOutput {
        
        if shouldEnteringNumeralClearDisplay {
            self.currentInput = nil
        }
    
        switch (self.currentInput, numeral) {
        
        case (.none, "0"): fallthrough
        case (.some("0"), "0"):
            self.currentInput = "0"
            return CalculatorOutput(display: "0")
            
        case (.none, "."): fallthrough
        case (.some("0"), "."):
            self.currentInput = "0."
            return CalculatorOutput(display: "0.")
        
        case (.some("0"), _): fallthrough
        case (.none, _):
            self.currentInput = numeral
            return CalculatorOutput(display: numeral)
            
        case (.some(let val), "."):
            guard val.contains(".") == false else {
                return CalculatorOutput(display: val)
            }
            self.currentInput = val + "."
            return CalculatorOutput(display: val + ".")
            
        case (.some(let val), let numeral):
            let input = val + numeral
            self.currentInput = input
            return CalculatorOutput(display: input)
            
        }
    }
    
    private func handle(dyadic: DyadicOperator) throws -> CalculatorOutput {
        let accumulatedValue = self.currentInput ?? "0"
        self.accumulatedValue = accumulatedValue
        self.currentInput = nil
        self.lastOperator = dyadic
        return CalculatorOutput(display: accumulatedValue)
    }
    
    private func performOperation(a: String, b: String, dyadic: DyadicOperator) throws -> String {
        
        // TODO: Conversions could be better
        guard let aDouble = Double(a), let bDouble = Double(b) else {
            throw NSError(domain: "", code: 0, userInfo: nil)
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
            guard b != 0 else { throw NSError(domain: "", code: 0, userInfo: nil) }
            return a / b
        }
    }
    
    private func handleReverseSign() -> CalculatorOutput {
        return CalculatorOutput(display: "")
    }
    
    private func handlePercent() throws -> CalculatorOutput {
        return CalculatorOutput(display: "")
    }
    
    private func handleEquals() throws -> CalculatorOutput {
        
        guard let op = self.lastOperator else {
            return CalculatorOutput(display: self.currentInput ?? "0")
        }
        
        switch (self.accumulatedValue, self.currentInput) {
            
        case (.some(let a), .some(let b)):
            let result = try self.performOperation(a: a, b: b, dyadic: op)
            self.accumulatedValue = result
            self.currentInput = b
            return CalculatorOutput(display: result)
            
        default:
            return CalculatorOutput(display: "Error")
        }
        
    }
    
    private func handleClear() -> CalculatorOutput {
        return CalculatorOutput(display: "")
    }
    
}
