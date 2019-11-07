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
    var lastResult: String? = nil
    var currentInput: String? = nil
    var lastOperator: DyadicOperator? = nil
    
    func updateState(input: CalculatorInput) -> CalculatorOutput {
        fatalError()
    }
    
}
