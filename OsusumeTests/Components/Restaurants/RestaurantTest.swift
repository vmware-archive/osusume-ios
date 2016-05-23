import XCTest
import Nimble
@testable import Osusume

class RestaurantTest: XCTestCase {

    func test_toggledLikeForUnlikedRestaurant_isLiked() {
        let restaurant = RestaurantFixtures.newRestaurant(
            liked: false,
            numberOfLikes: 0
        )


        let updatedRestaurant = restaurant.newRetaurantWithLikeToggled()


        expect(updatedRestaurant.liked).to(beTrue())
        expect(updatedRestaurant.numberOfLikes).to(equal(1))
    }

    func test_toggledLikeForLikedRestaurant_isUnliked() {
        let restaurant = RestaurantFixtures.newRestaurant(
            liked: true,
            numberOfLikes: 1
        )


        let updatedRestaurant = restaurant.newRetaurantWithLikeToggled()


        expect(updatedRestaurant.liked).to(beFalse())
        expect(updatedRestaurant.numberOfLikes).to(equal(0))
    }
}