//
//  ViewController.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit


/// View Controller for displaying a calculator
class CalculatorViewController: UIViewController {
    
    /// Label representing the calculation that has taken place
    @IBOutlet weak var labelCalculation: UILabel?
    
    /// Label representing the calculator input/output
    @IBOutlet weak var labelOutput: UILabel?
    
    /// Clear button
    @IBOutlet weak var clearButton: UIButton?
    
    /// The state of the calculator
    var state: ICalculator = CalculatorNodeStateMachine()
    
    /**
     Updates the state of the ICalculator with the given input, and then applies the output to the view controller's UIControls.
     - Parameter input: The button pressed on the calculator.
     */
    private func updateState(input: CalculatorInput) {
        
        let newState = self.state.updateState(input: input)
        
        // Update the display
        self.labelOutput?.text = newState.display
        self.labelOutput?.accessibilityValue = newState.display
        
        print(self.labelOutput?.text)
        
        // Update the clear button label
        self.clearButton?.setTitle(newState.clearButtonText, for: .normal)
        
        // Update the calculation display
        self.labelCalculation?.text = newState.calculation
        self.labelCalculation?.accessibilityValue = newState.calculation
        
        // Post a notification reading the display for a user using VoiceOver
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            UIAccessibility.post(
                notification: UIAccessibility.Notification.announcement,
                argument: newState.display
            )
        }
    }
    
    // MARK: - IBActions
    
    /// @IBAction connected to numeral buttons.
    @IBAction func onNumeralPressed(_ sender: UIButton) {
        guard let numeral = sender.titleLabel?.text else { return }
        self.updateState(input: .numeral(numeral))
    }
    
    /// @IBAction connected to clear button.
    @IBAction func onClearPressed(_ sender: Any) {
        self.updateState(input: .clear)
    }
    
    /// @IBAction connected to clear reverse sign button.
    @IBAction func onReverseSignPressed(_ sender: Any) {
        self.updateState(input: .reverseSign)
    }
    
    /// @IBAction connected to percent button.
    @IBAction func onPercentPressed(_ sender: Any) {
        self.updateState(input: .percent)
    }
    
    /// @IBAction connected to plus button.
    @IBAction func onPlusPressed(_ sender: Any) {
        self.updateState(input: .dyadic(.plus))
    }
    
    /// @IBAction connected to multiply button.
    @IBAction func onMultiplyPressed(_ sender: Any) {
        self.updateState(input: .dyadic(.multiply))
    }
    
    /// @IBAction connected to minus button.
    @IBAction func onMinusPressed(_ sender: Any) {
        self.updateState(input: .dyadic(.minus))
    }
    
    /// @IBAction connected to divide button.
    @IBAction func onDividePressed(_ sender: Any) {
        self.updateState(input: .dyadic(.divide))
    }
    
    /// @IBAction connected to equals button.
    @IBAction func onEqualsPressed(_ sender: Any) {
        self.updateState(input: .equals)
    }
}


