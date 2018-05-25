//
//  CurrentWeatherUITests.swift
//  SkyUITests
//
//  Created by Ronan on 5/25/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import XCTest

class CurrentWeatherUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_location_button_exists() {
        
        let locationBtn = app.buttons["LocationBtn"]
        let exists = NSPredicate(format: "exists == true")

        expectation(for: exists, evaluatedWith: locationBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssert(locationBtn.exists)
    }
}
