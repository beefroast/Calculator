//
//  RoundedButton.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    var defaultBackgroundColor: UIColor? = nil
    @IBInspectable var highlightedColor: UIColor? = nil
    @IBInspectable var selectedColor: UIColor? = nil
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.backgroundColor = selectedColor ?? self.highlightedColor
            } else {
                self.backgroundColor = self.defaultBackgroundColor
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.backgroundColor = selectedColor ?? self.defaultBackgroundColor
            } else {
                self.backgroundColor = self.defaultBackgroundColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.defaultBackgroundColor = self.backgroundColor
        self.highlightedColor = self.highlightedColor ?? self.defaultBackgroundColor
        self.selectedColor = self.selectedColor ?? self.defaultBackgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = min(self.frame.width, self.frame.height)/2.0
    }

}
