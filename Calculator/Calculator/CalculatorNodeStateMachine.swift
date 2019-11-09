//
//  CalculatorNodeStateMachine.swift
//  Calculator
//
//  Created by Benjamin Frost on 8/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation



/// Enum representing a node in a tree of calculations.
indirect enum CalculationNode {
    
    /// Error representing something going wrong in the process of calculating the value of the node.
    enum CalculatorError: Error {
        
        /// The input contained invalid characters and could not be converted to a number.
        case invalidInput
        
        /// Division by zero was attempted.
        case divisionByZero
    }
    
    /// Functional operator, or an operator that acts on one input.
    enum FunctionalOperator {
        
        /// Function operator percent sign, divides the value of the node by 100.
        case percent
        
        /// Function operator reverse sign, reverses the sign of the child node.
        case reverseSign
    }
    
    /// Case that represents a numeral, the numeral is stored as a `String` to avoid losing precision.
    case numeral(String)
    
    /**
     Case that represents a dyadic operator.
     In that case of non commutitive operators, the first `CalculationNode` is treated as the left hand side.
     */
    case dyadic(CalculationNode, DyadicOperator, CalculationNode?)
    
    /// Functional operator that acts on the given `CalculationNode`.
    case functional(FunctionalOperator, CalculationNode)
    
    /// Represents an indivisible tree of `CalculationNodes`. You can consider the node within to be contained in parenthesis.
    case result(CalculationNode)
    
    // MARK: - Public functions

    
    /**
     Tells you if the node would collapse to just a `.numeral("0")` if a clear input would happen.
     - Returns: `Bool` that is true if clearing would reduce the node to `.numeral("0")`.
     */
    func wouldClearOnClearPressed() -> Bool {
        switch self {
        case .result(_): return true
        case .numeral(_): return true
        default: return false
        }
    }
    
    /**
     Calculates what to display on the calculation display of the calculator.
     - Parameter isRootNode: Should be true if the node is the root of the tree.
     - Returns: `String` containing the value of the calculator calculation display.
    */
    func getCalculationDisplay(isRootNode: Bool = false) -> String {
       
       switch self {
           
       case .numeral("0"):
           return isRootNode ? "" : "0"
           
       case .numeral(let num):
           return num
           
       case .dyadic(let lhs, let op, let rhs):
           return "\(lhs.getCalculationDisplay()) \(symbolForDyadic(op: op)) \(rhs?.getCalculationDisplay() ?? "")"
           
       case .functional(.reverseSign, let node):
           return "-\(node.getCalculationDisplay())"
           
       case .functional(.percent, .numeral(let num)):
           return "\(num)%"
           
       case .functional(.percent, let node):
           return "\(node.getCalculationDisplay())%"
           
       case .result(let node):
           if isRootNode {
               return "\(node.getCalculationDisplay()) ="
           } else {
               return "(\(node.getCalculationDisplay()))"
           }
       }
    }
    
    /**
     Calculates what to display on input/output screen of the calculator.
     - Parameter isRootNode: Should be true if the node is the root of the tree.
     - Returns: `String` containing the value of the calculator calculation display.
    */
    func getLargeDisplayOutput(isRootNode: Bool = false) -> String {
        switch self {
            
        case .numeral(let num):
            return num
            
        case .dyadic(let lhs, _, .none):
            return lhs.getCalculatedValueAsRoundedString()
            
        case .dyadic(_, _, .some(let rhs)):
            return rhs.getLargeDisplayOutput()
            
        case .result(let node): return node.getCalculatedValueAsRoundedString()
            
        case .functional(_):
            return self.getCalculatedValueAsRoundedString()

        }
    }
    
    
    /**
     Applies a calculator input to node.
        - Parameter input: The input to the node.
        - Returns: `CalculationNode` that has been updated with the input.
     */
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
    
    // MARK: - Private functions
    
    /**
     Helper method for applying a numeral input to the node.
     - Parameter numeral: A numeral 0-9 or .
     - Returns: `CalculationNode` that has been updated with the numeral.
     */
    private func handle(numeral: String) -> CalculationNode {
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
        
        case .result(_):
            return CalculationNode.numeral(numeral)
        }
    }
    
    /**
     Helper method for applying a dyadic operator to a node.
     - Parameter dyadic: A `DyadicOperator` to apply.
     - Returns: `CalculationNode` that has been updated with the dyadic.
     */
    private func handle(dyadic: DyadicOperator) -> CalculationNode {
        switch self {
            
        case .dyadic(let lhs, _, .none):
            return .dyadic(lhs, dyadic, nil)
            
        case .dyadic(let ownLhs, let ownOp, .some(let ownRhs)):
            
            let rhsHandled = ownRhs.handle(dyadic: dyadic)
            
            switch rhsHandled {
                
            // NOTE: We perform a rotation to maintain order of operations.
                
            case .dyadic(let lhs, .plus, let rhs):
                return .dyadic(.dyadic(ownLhs, ownOp, lhs), .plus, rhs)
                
            case .dyadic(let lhs, .minus, let rhs):
                return .dyadic(.dyadic(ownLhs, ownOp, lhs), .minus, rhs)
                
            default:
                return .dyadic(ownLhs, ownOp, rhsHandled)
            }
            
        default:
            return CalculationNode.dyadic(self, dyadic, nil)
        }
    }
    
    /**
     Helper method for applying the reverse sign function to a node.
     - Returns: `CalculationNode` that has been updated with with the reverse sign function.
     */
    private func handleReverseSign() -> CalculationNode {
        
        switch self {
                
        case .functional(.reverseSign, let node):
            return node
            
        case .numeral("0"): fallthrough
        case .numeral("0."):
            return self
            
        case .dyadic(let lhs, let op, .some(let rhs)):
            return .dyadic(lhs, op, rhs.handleReverseSign())
            
        case .dyadic(_, _, .none):
            return self
            
        default:
            return .functional(.reverseSign, self)
        }
    }
    
    /**
     Helper method for applying the percent function to the node.
     - Returns: `CalculationNode` that has been updated with with the percent function.
     */
    private func handlePercent() -> CalculationNode {
        
        switch self {
            
        case .dyadic(let lhs, let op, let rhs):
            return .dyadic(lhs, op, rhs?.handlePercent())
            
        default:
            return .functional(.percent, self)
        }
    }
    

    /**
     Helper method for determining if the node can be evaluated in order to get a value.
     - Returns: `Bool` that is `true` if the node can be reduced to a value, `false` otherwise.
     - Note: An expression might not be evaluable if it's got a dyadic operator with a right child. We also assume that result notes, and functional nodes contain equatable nodes but in theory they might not (we can construct one manually for example, but not through use of the `apply(input:)` function.
     */
    private func isEquatable() -> Bool {
        switch self {
        case .numeral(_): return true
        case .result(_): return true
        case .functional(_, _): return true
        case .dyadic(let lhs, _, let rhs): return (rhs?.isEquatable() ?? false) && lhs.isEquatable()
        }
    }
    
    /**
     Helper method for handling the equals input.
     - Returns: `CalculationNode` that has been updated with with the equals operator.
     */
    private func handleEquals() -> CalculationNode {
        switch self {
        
        case .result(.dyadic(let lhs, let op, .some(let rhs))):
            return .result(.dyadic(.dyadic(lhs, op, rhs), op, rhs))
            
        case .result(_):
            return self
            
        default:
            if self.isEquatable() {
                return .result(self)
            } else {
                return self
            }
        }
    }

    
    /**
     Helper method for handling the clear input.
     - Returns: `CalculationNode` that has been updated with the clear input.
     */
    private func handleClear() -> CalculationNode {
        switch self {
            
        case .numeral(_):
            return .numeral("0")
            
        case .dyadic(let lhs, _, .none):
            return lhs
        
        case .dyadic(let lhs, let op, .some(let rhs)):
            return .dyadic(lhs, op, rhs.handleClear())
            
        case .functional(_, let node):
            return node
            
        case .result(_):
            return .numeral("0")
            
        }
    }
    
    
    /**
        Calculates what to display on the calculation display of the calculator.
        - Parameter isRootNode: Should be true if the node is the root of the tree.
        - Returns: `String` containing the value of the calculator calculation display.
     */
    private func getCalculatedValueAsRoundedString() -> String {
        
        do {
            
            let value = try self.getCalculatedValue()
            
            var stringValue = String(value)
            
            if stringValue.hasSuffix(".0") {
                stringValue = String(stringValue.dropLast(2))
            }

            if stringValue.count > 12 {
                let numFormat = NumberFormatter.init()
                numFormat.usesSignificantDigits = true
                numFormat.maximumSignificantDigits = 8
                numFormat.numberStyle = .scientific
                stringValue = numFormat.string(from: NSNumber.init(value: value)) ?? stringValue
            }
            
            
            
            return stringValue
            
        } catch {
            return "Error"
        }
    }
    
    /**
        Gets the displayed symbol for a dyadic operator.
        - Parameter op: `DyadicOperator` that will be rendered.
        - Returns: `String` representing the `DyadicOperator`.
     */
    private func symbolForDyadic(op: DyadicOperator) -> String {
        switch op {
        case .divide: return "÷"
        case .minus: return "−"
        case .multiply: return "×"
        case .plus: return "+"
        }
    }
    
    
    /**
        Calculates the value of expression tree.
        - Returns: `Double` containing the value of the expression tree.
        - Throws: `CalculatorError.invalidInput` if there's an invalid value somewhere in the tree.
        - Throws: `CalculatorError.divisionByZero` if a division by zero was attempted.
     */
    private func getCalculatedValue() throws -> Double {
        
        switch self {
        
        case .numeral(let num):
            guard let value = Double(num) else {
                throw CalculatorError.invalidInput
            }
            return value
        
        case .dyadic(let lhs, _, .none):
            // NOTE: This is never entered
            return try lhs.getCalculatedValue()

        case .dyadic(let lhs, let op, .some(let rhs)):
            
            switch (op, rhs) {
            
            case (.minus, .functional(.percent, let rhs)):
                
                // Special case, a number minus a percent is considered to be
                // that number minus a percent of itself
                
                let a = try lhs.getCalculatedValue()
                let b = try rhs.getCalculatedValue()
                return a - (a*b/100.0)
                
            case (.plus, .functional(.percent, let rhs)):
                
                // Special case, a number plus a percent is considered to be
                // that number plus a percent of itself
                
                let a = try lhs.getCalculatedValue()
                let b = try rhs.getCalculatedValue()
                return a + (a*b/100.0)
                
            default:
                let a = try lhs.getCalculatedValue()
                let b = try rhs.getCalculatedValue()
                
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
            }

        case .functional(.percent, let node):
            return try node.getCalculatedValue() / 100.0
            
        case .functional(.reverseSign, let node):
            return try -node.getCalculatedValue()
            
        case .result(let node):
            return try node.getCalculatedValue()
            
        }
    }


}


class CalculatorNodeStateMachine: ICalculator {
    
    var calculation: CalculationNode = .numeral("0")
    var wasLastInputClear: Bool = false
    
    func updateState(input: CalculatorInput) -> CalculatorOutput {
        
        switch (input, wasLastInputClear) {
            
        case (.clear, true):
            self.wasLastInputClear = true
            
            self.calculation = .numeral("0")
            
            return CalculatorOutput(
                display: "0",
                clearButtonText: "AC",
                calculation: ""
            )
        
        case (.clear, false):
            wasLastInputClear = true
            
            self.calculation = calculation.apply(input: input)
            return CalculatorOutput(
                display: calculation.getLargeDisplayOutput(),
                clearButtonText: "AC",
                calculation: self.calculation.getCalculationDisplay(isRootNode: true)
            )
            
        default:
            wasLastInputClear = false
            self.calculation = calculation.apply(input: input)
                        
            let wouldClear = self.calculation.wouldClearOnClearPressed()
            return CalculatorOutput(
                display: self.calculation.getLargeDisplayOutput(),
                clearButtonText: wouldClear ? "AC" : "C",
                calculation: self.calculation.getCalculationDisplay(isRootNode: true)
            )
            
        }

    }
    
}
