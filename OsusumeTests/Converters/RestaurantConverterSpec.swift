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
                let json : [NSDictionary] = [["name": "first restaurant", "id ": 1], ["name": "second restaurant","id": 2]]

                let restaurants : [Restaurant] = subject.perform(json)

                expect(restaurants.count).to(equal(2))
                expect(restaurants[0].name).to(equal("first restaurant"))
                expect(restaurants[1].name).to(equal("second restaurant"))
            }
        }
    }
}