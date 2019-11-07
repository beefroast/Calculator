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
            
        case (.some(let val), let numeral):
            let input = val + numeral
            self.currentInput = input
            return CalculatorOutput(display: input)
            
        }
    }
    
    private func handle(dyadic: DyadicOperator) throws -> CalculatorOutput {
         return CalculatorOutput(display: "")
    }
    
    private func performOperation(a: String, b: String, dyadic: DyadicOperator) throws -> String {
        return ""
    }
    
    private func performOperation(a: Double, b: Double, dyadic: DyadicOperator) throws -> Double {
        return 0.0
    }
    
    private func handleReverseSign() -> CalculatorOutput {
        return CalculatorOutput(display: "")
    }
    
    private func handlePercent() throws -> CalculatorOutput {
        return CalculatorOutput(display: "")
    }
    
    private func handleEquals() throws -> CalculatorOutput {
        return CalculatorOutput(display: "")
    }
    
    private func handleClear() -> CalculatorOutput {
        return CalculatorOutput(display: "")
    }
    
}
