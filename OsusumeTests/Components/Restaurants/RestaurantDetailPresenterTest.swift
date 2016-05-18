import XCTest
import Nimble
@testable import Osusume

class RestaurantDetailPresenterTest: XCTestCase {

    func test_formats_cuisineType() {
        let restaurant = RestaurantFixtures
            .newRestaurant(cuisine: Cuisine(id: 0, name: "Not Specified"))
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)

        expect(presenter.cuisineType).to(equal("Cuisine: Not Specified"))
    }

    func test_formatsPriceRange() {
        let restaurant = RestaurantFixtures.newRestaurant(priceRange: "¥1000~1999")
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.priceRange).to(equal("Price Range: ¥1000~1999"))
    }

    func test_numberOfLikes_displaysSinglePersonLike() {
        let restaurant = RestaurantFixtures.newRestaurant(numberOfLikes: 1)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.numberOfLikes).to(equal("1 person liked"))
    }

    func test_numberOfLikes_displaysMultiplePersonLike() {
        let restaurant = RestaurantFixtures.newRestaurant(numberOfLikes: 2)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.numberOfLikes).to(equal("2 people liked"))
    }
}
