import XCTest
import Nimble
@testable import Osusume

class RestaurantDetailPresenterTest: XCTestCase {

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
