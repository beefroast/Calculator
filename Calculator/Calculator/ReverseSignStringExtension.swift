//
//  ReverseSignStringExtension.swift
//  Calculator
//
//  Created by Benjamin Frost on 7/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation



extension String {
    func withLeadingMinusSignToggled() -> String {
        if self.prefix(1) == "-" {
            return String(self.suffix(1))
        } else {
            return "-" + self
        }
    }
}
