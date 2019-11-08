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
            return CalculationNode.numeral(existing + numeral)
            
        case .dyadic(let lhs, let op, .none):
            return CalculationNode.dyadic(lhs, op, .numeral(numeral))
            
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
        return .result(self)
    }
    
    func handleClear() -> CalculationNode {
        return .numeral("0")
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
    
    func getValue() -> Double {
        
        switch self {
        
        case .numeral(let num): return Double(num)!
        
        case .dyadic(let lhs, let op, .none): return lhs.getValue()
            
        case .dyadic(let lhs, let op, .some(let rhs)):
            switch op {
            case .divide: return lhs.getValue() / rhs.getValue()
            case .minus: return lhs.getValue() - rhs.getValue()
            case .multiply: return lhs.getValue() * rhs.getValue()
            case .plus: return lhs.getValue() + rhs.getValue()
            }
            
        case .functional(.percent, let node):
            return node.getValue() / 100.0
            
        case .functional(.reverseSign, let node):
            return -node.getValue()
            
        case .result(let node):
            return node.getValue()
            
        }
    }
    
    func getDisplayedValue(isRootNode: Bool = false) -> String {
        switch self {
        
        case .numeral(let num): return num
            
        case .dyadic(let lhs, let op, .none):
            return "\(lhs.getValue())"
            
        case .dyadic(let lhs, let op, .some(let rhs)):
            return rhs.getDisplayedValue()
            
        case .result(let node): return "\(node.getValue())"
        default: return ""
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
