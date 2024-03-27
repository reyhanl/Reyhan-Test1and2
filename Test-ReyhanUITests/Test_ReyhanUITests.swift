//
//  Test_ReyhanUITests.swift
//  Test-ReyhanUITests
//
//  Created by reyhan muhammad on 25/03/24.
//

import XCTest
import Test_Reyhan

final class Test_ReyhanUITests: XCTestCase {

    var app: XCUIApplication?


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        self.app = app
    }

    override func tearDownWithError() throws {
        self.app = nil
    }


    func testInsufficientBalance() throws {
        // UI tests must launch the application that they test.
        app?.launchArguments = ["TestTransactionModal", "InsufficientBalance"]
        app?.launch()
        
        let button = app?.buttons.matching(identifier: "purchaseButton").element
        if let button = button{
            XCTAssert(button.isEnabled == false)
        }else{
            print("button is not found")
        }
    }
    
    func testTransactionSuccess() throws {
        // UI tests must launch the application that they test.
        app?.launchArguments = ["TestTransactionSuccess", "InsufficientBalance"]
        app?.launch()
        
        guard let button = app?.buttons["Purchase"] else{
            XCTFail()
            return
        }
        XCTAssert(button.isEnabled)
    }
}
