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

    func test_deletePhotoUrl_returnsRestaurant() {
        let restaurant = RestaurantFixtures.newRestaurant(
            photoUrls: [PhotoUrl(
                id: 10,
                url: NSURL(string: "http://hoge/image.jpg")!
            )]
        )


        let updatedRestaurant = restaurant.restaurantByDeletingPhotoUrl("http://hoge/image.jpg")


        expect(updatedRestaurant.photoUrls.count).to(equal(0))
    }

    func test_createdByCurrentUser_returnsTrue_whenCurrentUserCreated() {
        let restaurant = RestaurantFixtures.newRestaurant(
            createdByUser: (id: 10, name: "Danny", email: "danny@email.com")
        )
        let currentUser = AuthenticatedUser(id: 10, email: "danny@email.com", token: "token-string")


        expect(restaurant.createdByCurrentUser(currentUser)).to(beTrue())
    }

    func test_createdByCurrentUser_returnsFalse_whenCurrentUserIsNil() {
        let restaurant = RestaurantFixtures.newRestaurant(
            createdByUser: (id: 10, name: "Danny", email: "danny@email.com")
        )


        expect(restaurant.createdByCurrentUser(nil)).to(beFalse())
    }
}