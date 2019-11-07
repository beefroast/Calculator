//
//  ViewController.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit






class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var labelOutput: UILabel?
    @IBOutlet weak var clearButton: UIButton?
    @IBOutlet weak var plusButton: UIButton?
    @IBOutlet weak var minusButton: UIButton?
    @IBOutlet weak var multiplyButton: UIButton?
    @IBOutlet weak var divideButton: UIButton?
    
    var state = CalculatorStateMachine()
    
    private func updateState(input: CalculatorInput) {
        
        let newState = self.state.updateState(input: input)
        
        // Update the display
        self.labelOutput?.text = newState.display
        self.labelOutput?.accessibilityValue = newState.display
        
        // Update the clear button label
        self.clearButton?.setTitle(newState.clearButtonText, for: [.normal, .highlighted])
        
        // Update the operators selected state
        self.plusButton?.isSelected = newState.highlightedButton == .some(.plus)
        self.minusButton?.isSelected = newState.highlightedButton == .some(.minus)
        self.multiplyButton?.isSelected = newState.highlightedButton == .some(.multiply)
        self.divideButton?.isSelected = newState.highlightedButton == .some(.divide)
        
        // Post a notification reading the display for a user using VoiceOver
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            UIAccessibility.post(
                notification: UIAccessibility.Notification.announcement,
                argument: newState.display
            )
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func onNumeralPressed(_ sender: UIButton) {
        guard let numeral = sender.titleLabel?.text else { return }
        self.updateState(input: .numeral(numeral))
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        self.updateState(input: .clear)
    }
    
    @IBAction func onReverseSignPressed(_ sender: Any) {
        self.updateState(input: .reverseSign)
    }
    
    @IBAction func onPercentPressed(_ sender: Any) {
        self.updateState(input: .percent)
    }
    
    @IBAction func onPlusPressed(_ sender: Any) {
        self.updateState(input: .dyadic(.plus))
    }
    
    @IBAction func onMultiplyPressed(_ sender: Any) {
        self.updateState(input: .dyadic(.multiply))
    }
    
    @IBAction func onMinusPressed(_ sender: Any) {
        self.updateState(input: .dyadic(.minus))
    }
    
    @IBAction func onDividePressed(_ sender: Any) {
        self.updateState(input: .dyadic(.divide))
    }
    
    @IBAction func onEqualsPressed(_ sender: Any) {
        self.updateState(input: .equals)
    }
}

extension String {
    func withLeadingMinusSignToggled() -> String {
        if self.prefix(1) == "-" {
            return String(self.suffix(1))
        } else {
            return "-" + self
        }
    }
}

