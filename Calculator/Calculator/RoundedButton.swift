//
//  RoundedButton.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit

/// Button that has rounded corners and different colours for the highlighted and selected states.
class RoundedButton: UIButton {
    
    var defaultBackgroundColor: UIColor? = nil
    @IBInspectable var highlightedColor: UIColor? = nil
    @IBInspectable var selectedColor: UIColor? = nil
    
    override var isHighlighted: Bool {
        didSet {
            self.updateColorsForState(state: self.state)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.updateColorsForState(state: self.state)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        
        self.defaultBackgroundColor = self.backgroundColor
        self.highlightedColor = self.highlightedColor ?? UIColor.white
        self.selectedColor = self.selectedColor ?? self.defaultBackgroundColor
        
        self.setTitleColor(self.backgroundColor, for: UIControl.State.highlighted)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let minCornerDimension = min(self.frame.width, self.frame.height)/2.0
        
        // Round the corners
        self.layer.cornerRadius = minCornerDimension
        
        // Set the font appropriately
        self.titleLabel?.font = self.titleLabel?.font.withSize(min(80, minCornerDimension))
    }
    
    private func updateColorsForState(state: UIControl.State) {
        switch state {
        case .highlighted:
            self.backgroundColor = self.highlightedColor
        case .selected:
            self.backgroundColor = self.selectedColor
        default:
            self.backgroundColor = self.defaultBackgroundColor
        }
    }

}
