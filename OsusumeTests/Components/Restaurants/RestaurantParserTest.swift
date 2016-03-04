import Foundation
import Nimble
import XCTest

@testable import Osusume

class RestaurantParserTest: XCTestCase {

    // MARK: parseList
    func test_convertingMultipleRestaurants() {
        let restaurantParser = RestaurantParser()

        let json: [[String: AnyObject]] = [
            [
                "name": "first restaurant",
                "id": 1,
                "address": "",
                "cuisine_type": "",
                "offers_english_menu": false,
                "walk_ins_ok": false,
                "accepts_credit_cards": false,
                "notes": "notes",
                "created_at": 1454480320,
                "user": ["name": "Bambi"],
                "photo_urls": [
                    ["url": "http://www.example.com"]
                ]
            ],
            [
                "name": "second restaurant",
                "id": 2,
                "address": "",
                "cuisine_type": "",
                "offers_english_menu": false,
                "walk_ins_ok": false,
                "accepts_credit_cards": false,
                "notes": "notes",
                "created_at": 1454480320,
                "user": ["name": "Bambi"],
                "photo_urls": [
                    ["url": "http://www.example.com"]
                ]
            ]
        ]

        let restaurants: [Restaurant] = restaurantParser.parseList(json).value!

        expect(restaurants.count).to(equal(2))
        expect(restaurants[0].name).to(equal("first restaurant"))
        expect(restaurants[1].name).to(equal("second restaurant"))
    }

    func test_convertingMultipleRestaurants_omittingRestaurantsWithBadData() {
        let restaurantParser = RestaurantParser()

        let json: [[String: AnyObject]] = [
            ["id": 1, "name": "first restaurant"],
            ["bad": "data"]
        ]

        let result = restaurantParser.parseList(json)
        expect(result.error).to(beNil())

        let restaurants = result.value!
        expect(restaurants.count).to(equal(1))
    }

    func test_convertingMultipleRestaurantsWithbadData_returnsNil() {
        let restaurantParser = RestaurantParser()

        let json: [[String: AnyObject]] = [
            [
                "bad": "data",
                "id": 1,
            ],
            [
                "name": "second restaurant",
                "really bad": "data",
            ]
        ]

        let result = restaurantParser.parseList(json)
        expect(result.error).to(beNil())
    }

    // MARK: parseSingle
    func test_convertingASingleRestaurant_withoutComments() {
        let restaurantParser = RestaurantParser()

        let json: [String: AnyObject] = [
            "name": "first restaurant",
            "id": 1232,
            "address": "",
            "cuisine_type": "",
            "offers_english_menu": false,
            "walk_ins_ok": false,
            "accepts_credit_cards": false,
            "created_at": 1454480320,
            "user": ["name": "Bambi"],
            "photo_urls": [
                ["url": "http://www.example.com"],
                ["url": "my-awesome-url"]
            ],
            "comments": [
            ]
        ]

        let restaurant: Restaurant = restaurantParser.parseSingle(json).value!
        expect(restaurant.name).to(equal("first restaurant"))
        expect(restaurant.createdAt!).to(equal(NSDate(timeIntervalSince1970: 1454480320)))
        expect(restaurant.author).to(equal("Bambi"))
        expect(restaurant.photoUrls[0].URLString).to(equal("http://www.example.com"))
        expect(restaurant.photoUrls[1].URLString).to(equal("my-awesome-url"))
        expect(restaurant.comments.count).to(equal(0))
    }

    func test_convertingASingleRestaurant_withComments() {
        let restaurantParser = RestaurantParser()

        let json: [String: AnyObject] = [
            "name": "first restaurant",
            "id": 1232,
            "comments": [
                [
                    "id": 1,
                    "content": "first comment",
                    "created_at": "2016-02-29T06:07:55.000Z",
                    "restaurant_id": 1232,
                    "user": [
                        "name": "Witta"
                    ]
                ],
                [
                    "id": 2,
                    "content": "second comment",
                    "created_at": "2016-02-29T06:07:59.000Z",
                    "restaurant_id": 1232,
                    "user": [
                        "name": "Danny"
                    ]
                ]
            ]
        ]

        let restaurant: Restaurant = restaurantParser.parseSingle(json).value!
        let expectedFirstComment = PersistedComment(
            id: 1,
            text: "first comment",
            createdDate: NSDate(timeIntervalSince1970: 1456726075),
            restaurantId: 1232,
            userName: "Witta"
        )
        expect(restaurant.comments[0]).to(equal(expectedFirstComment))

        let expectedSecondComment = PersistedComment(
            id: 2,
            text: "second comment",
            createdDate: NSDate(timeIntervalSince1970: 1456726079),
            restaurantId: 1232,
            userName: "Danny"
        )
        expect(restaurant.comments[1]).to(equal(expectedSecondComment))
    }

    func test_convertingASingleRestaurant_skipsInvalidComments() {
        let restaurantParser = RestaurantParser()

        let json: [String: AnyObject] = [
            "name": "first restaurant",
            "id": 1,
            "comments": [
                [
                    "id": 1,
                    "content": "first comment",
                    "created_at": "2016-02-29T06:07:55.000Z",
                    "restaurant_id": 9,
                    "user": [
                        "name": "Witta"
                    ]
                ],
                [
                    "id": 2,
                    "content": "second comment",
                    "created_at": "2016-02-29T06:07:55.000Z",
                    "restaurant_id": 9,
                    "user": [
                        "name": "Witta"
                    ]
                ],
                [ "bad": "commentData"]
            ]
        ]

        let restaurant: Restaurant = restaurantParser.parseSingle(json).value!
        expect(restaurant.comments.count).to(equal(2))
    }

    func test_convertingASingleRestaurant_onFailure() {
        let restaurantParser = RestaurantParser()

        let json: [String: AnyObject] = [ "bad": "data" ]

        let parseError: RestaurantParseError = restaurantParser.parseSingle(json).error!

        expect(parseError).to(equal(RestaurantParseError.InvalidField))
    }

    func test_convert_usesDefaultsWhenOptionalFieldsAreMissing() {
        let restaurantParser = RestaurantParser()
        let json: [String: AnyObject] = ["name": "first restaurant", "id": 1]

        let restaurant = restaurantParser.parseSingle(json).value!
        expect(restaurant.address).to(equal(""))
        expect(restaurant.walkInsOk).to(equal(false))
        expect(restaurant.createdAt).to(beNil())
    }

}