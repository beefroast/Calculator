//
//  ReverseSignStringExtension.swift
//  Calculator
//
//  Created by Benjamin Frost on 7/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation



extension String {
    
    /// Returns the original string but prefixed with a '-' if it was no present, and with the '-' removed if it was.
    func withLeadingMinusSignToggled() -> String {
        if self.prefix(1) == "-" {
            let idx = index(after: self.startIndex)
            return String(self.suffix(from: idx))
        } else {
            return "-" + self
        }
    }
}
