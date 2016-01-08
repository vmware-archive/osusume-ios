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
                let json : [NSDictionary] = [
                    ["name": "first restaurant", "id": 1, "address": "", "cuisine_type": "", "offers_english_menu": false, "walk_ins_ok": false, "accepts_credit_cards": false],
                    ["name": "second restaurant","id": 2, "address": "", "cuisine_type": "", "offers_english_menu": false, "walk_ins_ok": false, "accepts_credit_cards": false]
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
                let json : NSDictionary = ["name": "first restaurant", "id": 1, "address": "", "cuisine_type": "", "offers_english_menu": false, "walk_ins_ok": false, "accepts_credit_cards": false]

                let restaurant : Restaurant = subject.perform(json)
                expect(restaurant.name).to(equal("first restaurant"))
            }
        }
    }
}