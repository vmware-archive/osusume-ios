import Foundation
import Quick
import Nimble

@testable import Osusume

class RestaurantConverterSpec : QuickSpec {
    override func spec() {
        describe("the restaurant converter") {
            var subject: RestaurantConverter!
            beforeEach {
                subject = RestaurantConverter()
            }

            it("turns the json into an array of Restaurants") {
                let json : [HttpJson] = [
                    ["name": "first restaurant", "id": 1, "address": "", "cuisine_type": "", "offers_english_menu": false, "walk_ins_ok": false, "accepts_credit_cards": false, "notes": "notes", "created_at": 1454480320, "user": ["name": "Bambi"], "photo_url": "http://www.example.com"],
                    ["name": "second restaurant","id": 2, "address": "", "cuisine_type": "", "offers_english_menu": false, "walk_ins_ok": false, "accepts_credit_cards": false, "notes": "notes", "created_at": 1454480320, "user": ["name": "Bambi"], "photo_url": "http://www.example.com"]
                ]

                let restaurants : [Restaurant] = subject.perform(json)

                expect(restaurants.count).to(equal(2))
                expect(restaurants[0].name).to(equal("first restaurant"))
                expect(restaurants[1].name).to(equal("second restaurant"))
            }
        }

        describe("convert single restaurant") {
            var subject: RestaurantConverter!
            beforeEach {
                subject = RestaurantConverter()
            }

            it("turns the json into a Restaurant") {
                let json : HttpJson = ["name": "first restaurant", "id": 1, "address": "", "cuisine_type": "", "offers_english_menu": false, "walk_ins_ok": false, "accepts_credit_cards": false, "created_at": 1454480320, "user": ["name": "Bambi"], "photo_url": "http://www.example.com"]



                let restaurant : Restaurant = subject.perform(json)
                expect(restaurant.name).to(equal("first restaurant"))
                expect(restaurant.createdAt!).to(equal(NSDate(timeIntervalSince1970: 1454480320)))
                expect(restaurant.author).to(equal("Bambi"))
            }

            it("uses defaults when optional fields are missing") {
                let json : HttpJson = ["name": "first restaurant", "id": 1]

                let restaurant = subject.perform(json)
                expect(restaurant.address).to(equal(""))
                expect(restaurant.walkInsOk).to(equal(false))
                expect(restaurant.createdAt).to(beNil())
            }
        }
    }
}