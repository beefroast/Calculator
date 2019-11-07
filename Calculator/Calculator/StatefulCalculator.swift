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
    var currentResult: String? = nil
    var operatorNumber: String? = nil
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
        return CalculatorOutput(display: "")
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
