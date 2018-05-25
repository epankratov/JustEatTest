//
//  RestaurantTests.swift
//  JustEatTestTests
//
//  Created by Eugene Pankratov on 25.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import XCTest
@testable import JustEatTest

class RestaurantTests: XCTestCase {

    var validJson: [String: Any] = [:]
    var invalidJson: [String: Any] = [:]

    override func setUp() {
        super.setUp()

        if let path = Bundle(for: type(of: self)).path(forResource: "valid-value", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: Any] {
                    validJson = jsonResult
                }
            } catch {
                // handle error
            }
        }

        if let path = Bundle(for: type(of: self)).path(forResource: "invalid-value", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: Any] {
                    invalidJson = jsonResult
                }
            } catch {
                // handle error
            }
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValidJsonInitialization() {
        let restaurant = Restaurant(validJson)
        XCTAssert(restaurant.restaurantId == "13620", "Restaurant ID must be parsed correctly as string")
        XCTAssert(restaurant.name == "Pizza Plus Pizza", "Restaurant name must be parsed correctly")
        XCTAssert(restaurant.address == "2 High Street", "Address must be parsed correctly")
        XCTAssert(restaurant.postcode == "SE25 6EP", "Postcode must be parsed correctly")
        XCTAssert(restaurant.city == "South Norwood", "must be parsed correctly")
        XCTAssert(restaurant.cuisineTypes[0].name == "Pizza", "Cuisine name must be parsed correctly")
        XCTAssert(restaurant.cuisineTypes[1].name == "Chicken", "Cuisine name must be parsed correctly")
        XCTAssert(restaurant.url == "https://www.just-eat.co.uk/restaurants-pizzapluspizzase25", "URL must be parsed correctly")
        XCTAssert(restaurant.logoUrl == "http://d30v2pzvrfyzpo.cloudfront.net/uk/images/restaurants/13620.gif", "Logo URL must be parsed correctly")
        guard let date = restaurant.openingTime else {
            XCTFail("Date must be present")
            return
        }
        XCTAssert(String(describing: date) == "2018-05-23 10:30:00 +0000", "Date must be parsed correctly \(String(describing: restaurant.openingTime?.description)) <> \(String(describing: date))")
    }

    func testInvalidJsonInitialization() {
        let restaurant = Restaurant(invalidJson)
        XCTAssert(restaurant.restaurantId == "0", "Restaurant ID must be parsed correctly as string")
        XCTAssert(restaurant.name == "", "Restaurant name must be parsed correctly")
        XCTAssert(restaurant.address == nil, "Address must be parsed correctly")
        XCTAssert(restaurant.postcode == nil, "Postcode must be parsed correctly")
        XCTAssert(restaurant.city == nil, "must be parsed correctly")
        XCTAssert(restaurant.cuisineTypes.count == 0, "Cuisine name must be parsed correctly")
    }
}
