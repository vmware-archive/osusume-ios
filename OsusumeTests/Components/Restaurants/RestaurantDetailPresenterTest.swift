import XCTest
import Nimble
@testable import Osusume

class RestaurantDetailPresenterTest: XCTestCase {

    func test_formats_restaurantName() {
        let restaurant = RestaurantFixtures
            .newRestaurant(name: "Afuri")
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.name).to(equal("Afuri"))
    }

    func test_formats_address() {
        let restaurant = RestaurantFixtures
            .newRestaurant(address: "Roppongi Hills 5-2-1")
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.address).to(equal("Roppongi Hills 5-2-1"))
    }

    func test_formats_cuisineType() {
        let restaurant = RestaurantFixtures
            .newRestaurant(cuisine: Cuisine(id: 0, name: "Not Specified"))
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.cuisineType).to(equal("Cuisine: Not Specified"))
    }

    func test_formats_notes() {
        let restaurant = RestaurantFixtures
            .newRestaurant(notes: "Notes")
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.notes).to(equal("Notes"))
    }

    func test_formats_creationInfo() {
        let date = NSDate()
        let restaurant = RestaurantFixtures
            .newRestaurant(
                createdByUser: (id: 99, name: "Danny", email: "danny@pivotal"),
                createdAt: date
            )
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        let formattedDate = DateConverter.formattedDate(date)


        expect(presenter.creationInfo).to(equal("Added by Danny on \(formattedDate)"))
    }

    func test_formats_author() {
        let restaurant = RestaurantFixtures
            .newRestaurant(
                createdByUser: (id: 99, name: "Danny", email: "danny@pivotal")
        )
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.author).to(equal("Added by Danny"))
    }

    func test_formats_creationDate() {
        let date = NSDate()
        let restaurant = RestaurantFixtures
            .newRestaurant(createdAt: date)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        let formattedDate = DateConverter.formattedDate(date)


        expect(presenter.creationDate).to(equal("Created on \(formattedDate)"))
    }

    func test_formats_photoUrl_whenThereIsAPhoto() {
        let restaurant = RestaurantFixtures
            .newRestaurant(photoUrls: [
                PhotoUrl(id: 10, url: NSURL(string: "photoUrl.com")!)
                ]
            )
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.photoUrl.absoluteString).to(equal("photoUrl.com"))
    }

    func test_formats_photoUrl_whenThereIsNotAPhoto() {
        let restaurant = RestaurantFixtures
            .newRestaurant(photoUrls: [])
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.photoUrl.absoluteString).to(equal(""))
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

    func test_formatsPriceRange() {
        let restaurant = RestaurantFixtures.newRestaurant(priceRange: PriceRange(id: 1, range: "¥1000~1999"))
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.priceRange).to(equal("Price Range: ¥1000~1999"))
    }
}
