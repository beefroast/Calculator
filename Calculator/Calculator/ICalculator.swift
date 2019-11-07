//
//  ICalculator.swift
//  Calculator
//
//  Created by Benjamin Frost on 7/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation


protocol ICalculator {
    func updateState(input: CalculatorInput) -> CalculatorOutput
}

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

class CalculatorOutput {
    
    let display: String
    let clearButtonText: String
    let highlightedButton: DyadicOperator?
    
    init(display: String, clearButtonText: String = "C", highlightedButton: DyadicOperator? = nil) {
        self.display = display
        self.clearButtonText = clearButtonText
        self.highlightedButton = highlightedButton
    }
}
