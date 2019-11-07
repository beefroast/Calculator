//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {

    var app: XCUIApplication!
    var display: XCUIElement!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        self.app = XCUIApplication()
        self.app.launch()
        
        self.display = app.buttons.element(matching: .any, identifier: "Display")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNumerals() {
        
        app.buttons["1"].tap()
        XCTAssertEqual(display.value as? String, "1")
        
        app.buttons["2"].tap()
        XCTAssertEqual(display.value as? String, "12")
        
        app.buttons["3"].tap()
        XCTAssertEqual(display.value as? String, "123")
        
        app.buttons["4"].tap()
        XCTAssertEqual(display.value as? String, "1234")
        
        app.buttons["5"].tap()
        XCTAssertEqual(display.value as? String, "12345")
        
        app.buttons["6"].tap()
        XCTAssertEqual(display.value as? String, "123456")
        
        app.buttons["7"].tap()
        XCTAssertEqual(display.value as? String, "1234567")
        
        app.buttons["8"].tap()
        XCTAssertEqual(display.value as? String, "12345678")
        
        app.buttons["9"].tap()
        XCTAssertEqual(display.value as? String, "123456789")
        
        app.buttons["0"].tap()
        XCTAssertEqual(display.value as? String, "1234567890")
        
    }

    func testPlus() {

        app.buttons["9"].tap()
        app.buttons["+"].tap()
        app.buttons["7"].tap()
        app.buttons["="].tap()
        
        XCTAssertEqual(display.value as? String, "16")
    }
    
    func testMinus() {

        app.buttons["9"].tap()
        app.buttons["−"].tap()
        app.buttons["7"].tap()
        app.buttons["="].tap()
        
        XCTAssertEqual(display.value as? String, "2")
    }
    
    func testMultiply() {

        app.buttons["9"].tap()
        app.buttons["×"].tap()
        app.buttons["7"].tap()
        app.buttons["="].tap()
        
        XCTAssertEqual(display.value as? String, "63")
    }
    
    func testDivide() {

        app.buttons["8"].tap()
        app.buttons["÷"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()
        
        XCTAssertEqual(display.value as? String, "2")
    }
    
    func testClear() {
        
        app.buttons["8"].tap()
        app.buttons["Clear"].tap()
        
        XCTAssertEqual(display.value as? String, "0")
    }
    
    func testReverseSign() {
     
        app.buttons["8"].tap()
        app.buttons["Reverse sign"].tap()
        
        XCTAssertEqual(display.value as? String, "-8")
    }
    
    func testPercent() {
        
        app.buttons["8"].tap()
        app.buttons["%"].tap()
        
        XCTAssertEqual(display.value as? String, "0.08")
    }


    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
