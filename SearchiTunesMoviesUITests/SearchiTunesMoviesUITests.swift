//
//  SearchiTunesMoviesUITests.swift
//  SearchiTunesMoviesUITests
//
//  Created by Khairul Bashar on 2/6/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import XCTest

class SearchiTunesMoviesUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchForMovies() {
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        XCTAssertEqual(app.searchFields.count, 1)
        XCTAssertEqual(app.tables.count, 0)
        
        let searchBar = app.searchFields["Search movie by title..."]
        let table = app.tables.element(boundBy: 0)
        
        XCTAssertTrue(searchBar.exists)
        XCTAssertFalse(table.exists)
        
        searchBar.tap()
        searchBar.typeText("Avengers")
        
        let searchButton = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        searchButton.tap()
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(app.tables.count, 1)
        table/*@START_MENU_TOKEN@*/.cells.staticTexts["The Avengers (1998)"]/*[[".cells.staticTexts[\"The Avengers (1998)\"]",".staticTexts[\"The Avengers (1998)\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        let alertDialog = app.alerts["The Avengers (1998)"]
        XCTAssertTrue(alertDialog.exists)
        alertDialog.buttons["OK"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["Avengers Grimm: Time Wars"]/*[[".cells.staticTexts[\"Avengers Grimm: Time Wars\"]",".staticTexts[\"Avengers Grimm: Time Wars\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Avengers Grimm: Time Wars"].buttons["OK"].tap()
        
        XCTAssertEqual(table.cells.count, 19)
        
        searchBar.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        
        searchBar.typeText("World war")
        searchButton.tap()
        XCTAssertEqual(table.cells.count, 14)
        searchBar.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        
        searchBar.typeText("dfefs")
        searchButton.tap()
        expectation(for: NSPredicate(format: "exists == 0"), evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(app.tables.count, 0)
        app.staticTexts["No movies found with title containing dfefs"].tap()
        
    }
    
}
