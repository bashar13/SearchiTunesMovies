//
//  SearchiTunesMoviesTests.swift
//  SearchiTunesMoviesTests
//
//  Created by Jahid Bashar on 3/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import XCTest
@testable import SearchiTunesMovies

class SearchiTunesMoviesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncoder() {
        let testString = "   World    war    "
        XCTAssert(testString.condenseWhitespace() == "World war")
        let refinedString = testString.condenseWhitespace()
        XCTAssert(Encoder.encodeInputSearchString(searchString: refinedString) == "World+war")
        let encodedTestString = Encoder.encodeInputSearchString(searchString: testString)
        XCTAssert(Encoder.buildURL(searchString: encodedTestString) == "https://itunes.apple.com/search?term=World+war&country=US&media=movie&entity=movie&attribute=movieTerm&limit=20")
        
        let vc: UIViewController = UIViewController()
        vc.
    }
    
    func testMovieDataModel() {
        let movieItem = Movie(movieName: "Gladiator", release: "2000", directorName: "Ridley Scott", movieGenre: "Drama", iTunesPrice: 12.99, priceCurrency: "CAD", imageURL: "https://is1-ssl.mzstatic.com//image//thumb//Video62//v4//59//b0//3c//59b03c0b-b681-b000-8924-afbb5a70928f//source//100x100bb.jpg")
        XCTAssert(movieItem.name == "Gladiator")
        XCTAssert(movieItem.releaseYear == "2000")
        XCTAssert(movieItem.director == "Ridley Scott")
        XCTAssert(movieItem.genre == "Drama")
        XCTAssert(movieItem.price == 12.99)
        XCTAssert(movieItem.previewImageURL == "https://is1-ssl.mzstatic.com//image//thumb//Video62//v4//59//b0//3c//59b03c0b-b681-b000-8924-afbb5a70928f//source//100x100bb.jpg")
    }
    
    func testViewController() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
