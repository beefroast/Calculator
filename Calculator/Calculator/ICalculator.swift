//
//  ICalculator.swift
//  Calculator
//
//  Created by Benjamin Frost on 7/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation


/// Protocol for representing a calculator
protocol ICalculator {
    
    /**
        Updates the state of the calculator
        - Parameter input: The input into the calculator.
        - Returns: a CalculatorOutput representing the displayable state of the calculator.
     */
    func updateState(input: CalculatorInput) -> CalculatorOutput
}


/// Enum for representing dyadic operators that work on two numbers.
enum DyadicOperator {
    case plus
    case minus
    case multiply
    case divide
}

/// Possible inputs to the calculator
enum CalculatorInput {
    
    /// The user has entered a numeral or a '.' character
    case numeral(String)
    
    /// The user has selected a dyadic operator.
    case dyadic(DyadicOperator)
    
    case reverseSign
    case percent
    case equals
    case clear
}

/// Output from a calculator, represents what should be displayed to the user.
class CalculatorOutput {
    
    /// The display on the calculator screen
    let display: String
    
    /// The display on the calculation label
    let calculation: String?
    
    /// The title of the clear button
    let clearButtonText: String
     
    /**
        Constructs a CalculatorOutput
        - Parameter display: The display on the calculator screen.
        - Parameter clearButtonText: The title of the clear button.
        - Parameter calculation: Optional equation to show on the calculator.
     */
    init(display: String, clearButtonText: String = "C", calculation: String? = nil) {
        self.display = display
        self.clearButtonText = clearButtonText
        self.calculation = calculation
    }
    
}
