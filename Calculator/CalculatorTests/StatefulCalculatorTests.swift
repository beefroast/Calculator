//
//  StatefulCalculatorTests.swift
//  CalculatorTests
//
//  Created by Benjamin Frost on 7/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import XCTest
@testable import Calculator

class StatefulCalculatorTests: CalculatorStateMachineTests {

    override func setUp() {
        self.state = StatefulCalculator()
    }

}
