//
//  SwiftUIDebugUITests.swift
//  SwiftUIDebugUITests
//
//  Created by Immanuel on 07/05/24.
//

import XCTest

final class SwiftUIDebugUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app/*@START_MENU_TOKEN@*/.buttons["a"]/*[[".cells.buttons[\"a\"]",".buttons[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        
        let collectionViewsQuery = XCUIApplication().collectionViews
        let aButton = collectionViewsQuery.buttons["a"]
        aButton.swipeLeft()
        aButton.swipeLeft()
        
        let bButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["b"]/*[[".cells.buttons[\"b\"]",".buttons[\"b\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        bButton.swipeLeft()
        bButton.swipeLeft()
        
        let cButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["c"]/*[[".cells.buttons[\"c\"]",".buttons[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cButton.swipeLeft()
//        cButton.swipeLeft()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["minus.circle"]/*[[".buttons[\"Delete\"]",".buttons[\"minus.circle\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
