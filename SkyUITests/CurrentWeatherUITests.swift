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
        
        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["FakeJSON"] = """
            {
                "longitude": 100,
                "latitude": 52,
                "currently": {
                    "temperature": 23,
                    "humidity": 0.91,
                    "icon": "snow",
                    "time": 1507180335,
                    "summary": "Light Snow"
                }
            }
        """
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_location_button_exists() {
        
        let locationBtn = app.buttons["LocationBtn"]
        
        XCTAssert(locationBtn.exists)
    }
}
