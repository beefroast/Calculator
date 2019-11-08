//
//  CalculatorNodeStateMachine.swift
//  Calculator
//
//  Created by Benjamin Frost on 8/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation

enum FunctionalOperator {
    case percent
    case reverseSign
}

indirect enum CalculationNode {
    
    enum CalculatorError: Error {
        case invalidInput
        case divisionByZero
    }
    
    case numeral(String)
    case dyadic(CalculationNode, DyadicOperator, CalculationNode?)
    case functional(FunctionalOperator, CalculationNode)
    case result(CalculationNode)
    
    func apply(input: CalculatorInput) -> CalculationNode {
        switch input {
        case .numeral(let numeral): return self.handle(numeral: numeral)
        case .dyadic(let dyadic): return self.handle(dyadic: dyadic)
        case .reverseSign: return self.handleReverseSign()
        case .percent: return self.handlePercent()
        case .equals: return self.handleEquals()
        case .clear: return self.handleClear()
        }
    }
    
    func handle(numeral: String) -> CalculationNode {
        switch self {
                
        case .numeral(let existing):
            
            switch (existing, numeral) {
            case ("0", "0"): return self
            case ("0", "."): return .numeral("0.")
            case ("0", let input): return .numeral(input)
            case (let e, let b):
                if e.contains(".") && b.contains(".") {
                    return self
                } else {
                    return .numeral(e + b)
                }
            }
            
        case .dyadic(let lhs, let op, .none):
            if numeral == "." {
                return CalculationNode.dyadic(lhs, op, .numeral("0."))
            } else {
                return CalculationNode.dyadic(lhs, op, .numeral(numeral))
            }
            
        case .dyadic(let lhs, let op, .some(let rhs)):
            return CalculationNode.dyadic(lhs, op, rhs.handle(numeral: numeral))
            
        case .functional(let op, let node):
            return CalculationNode.functional(op, node.handle(numeral: numeral))
        
        case .result(let node):
            return CalculationNode.numeral(numeral)
        }
    }
    
    func handle(dyadic: DyadicOperator) -> CalculationNode {
        switch self {
            
        case .dyadic(let lhs, _, .none):
            return CalculationNode.dyadic(lhs, dyadic, nil)
            
        case .dyadic(let lhs, let op, .some(let rhs)):
            
            if dyadic == .divide || dyadic == .multiply {
                return .dyadic(lhs, op, .dyadic(rhs, dyadic, nil))
            } else {
                return CalculationNode.dyadic(self, dyadic, nil)
            }
        
        default:
            return CalculationNode.dyadic(self, dyadic, nil)
        }
    }
    
    func handleReverseSign() -> CalculationNode {
        
        switch self {
            
        case .functional(.reverseSign, let node):
            return node
            
        default:
            return .functional(.reverseSign, self)
        }
    }
    
    func handlePercent() -> CalculationNode {
        return .functional(.percent, self)
    }
    
    func handleEquals() -> CalculationNode {
        switch self {
        
        case .result(.dyadic(let lhs, let op, .some(let rhs))):
            return .result(.dyadic(.dyadic(lhs, op, rhs), op, rhs))
            
        default:
            return .result(self)
        }
    }
    
    func handleClear() -> CalculationNode {
        switch self {
            
        case .numeral(_):
            return .numeral("0")
            
        case .dyadic(let lhs, let op, .none):
            return lhs
            
        case .dyadic(let lhs, let op, .some(let rhs)):
            return .dyadic(lhs, op, nil)
            
        case .functional(_, let node):
            return node
            
        case .result(_):
            return .numeral("0")
            
        }
    }
    
    func display(isRootNode: Bool = false) -> String {
        
        switch self {
            
        case .numeral(let num):
            return num
            
        case .dyadic(let lhs, let op, let rhs):
            return "\(lhs.display()) \(symbolForDyadic(op: op)) \(rhs?.display() ?? "")"
            
        case .functional(.reverseSign, let node):
            return "-(\(node.display()))"
            
        case .functional(.percent, let node):
            return "(\(node.display()))%"
            
        case .result(let node):
            if isRootNode {
                return "\(node.display()) ="
            } else {
                return "(\(node.display()))"
            }
        }
    }
    
    func getValueString() -> String {
        
        do {
            let stringValue = try String(self.getValue())
            
            // Remove the trailing .0 if we've got an integer value
             if stringValue.suffix(2) == ".0" {
                 return String(stringValue.dropLast(2))
             } else {
                 return stringValue
             }
        } catch {
            return "Error"
        }
    }
    
    func getValue() throws -> Double {
        
        switch self {
        
        case .numeral(let num):
            guard let value = Double(num) else {
                throw CalculatorError.invalidInput
            }
            return value
        
        case .dyadic(let lhs, let op, .none): return try lhs.getValue()
            
        case .dyadic(let lhs, let op, .some(let rhs)):
            
            let a = try lhs.getValue()
            let b = try rhs.getValue()
            
            switch op {
            case .divide:
                guard b != 0.0 else {
                    throw CalculatorError.divisionByZero
                }
                return a/b
            case .minus: return a-b
            case .multiply: return a*b
            case .plus: return a+b
            }
            
        case .functional(.percent, let node):
            return try node.getValue() / 100.0
            
        case .functional(.reverseSign, let node):
            return try -node.getValue()
            
        case .result(let node):
            return try node.getValue()
            
        }
    }
    
    func getDisplayedValue(isRootNode: Bool = false) -> String {
        switch self {
        
        case .numeral(let num): return num
            
        case .dyadic(let lhs, _, .none):
            return lhs.getValueString()
            
        case .dyadic(let lhs, _, .some(let rhs)):
            return rhs.getDisplayedValue()
            
        case .result(let node): return node.getValueString()
            
        case .functional(_):
            return self.getValueString()

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
    
}


class CalculatorNodeStateMachine: ICalculator {
    
    var calculation: CalculationNode = .numeral("0")
    
    func updateState(input: CalculatorInput) -> CalculatorOutput {
        
        self.calculation = calculation.apply(input: input)
        
        return CalculatorOutput(
            display: "\(self.calculation.getDisplayedValue())",
            clearButtonText: "C",
            highlightedButton: nil,
            calculation: self.calculation.display(isRootNode: true)
        )
    }
    
}
