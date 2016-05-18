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

    func test_formats_offersEnglishMenu_whenTrue() {
        let restaurant = RestaurantFixtures
            .newRestaurant(offersEnglishMenu: true)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.offersEnglishMenu).to(equal("Offers English menu"))
    }

    func test_formats_offersEnglishMenu_whenFalse() {
        let restaurant = RestaurantFixtures
            .newRestaurant(offersEnglishMenu: false)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.offersEnglishMenu).to(equal("Does not offer English menu"))
    }

    func test_formats_walkInsOk_whenTrue() {
        let restaurant = RestaurantFixtures
            .newRestaurant(walkInsOk: true)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.walkInsOk).to(equal("Walk-ins ok"))
    }

    func test_formats_walkInsOk_whenFalse() {
        let restaurant = RestaurantFixtures
            .newRestaurant(walkInsOk: false)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.walkInsOk).to(equal("Walk-ins not recommended"))
    }

    func test_formats_creditCardsOk_whenTrue() {
        let restaurant = RestaurantFixtures
            .newRestaurant(acceptsCreditCards: true)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.creditCardsOk).to(equal("Accepts credit cards"))
    }

    func test_formats_creditCardsOk_whenFalse() {
        let restaurant = RestaurantFixtures
            .newRestaurant(acceptsCreditCards: false)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.creditCardsOk).to(equal("Does not accept credit cards"))
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
            .newRestaurant(author: "danny", createdAt: date)
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        let formattedDate = DateConverter.formattedDate(date)


        expect(presenter.creationInfo).to(equal("Added by danny on \(formattedDate)"))
    }

    func test_formats_author() {
        let restaurant = RestaurantFixtures
            .newRestaurant(author: "danny")
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.author).to(equal("Added by danny"))
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
            .newRestaurant(photoUrls: [NSURL(string: "photoUrl.com")!])
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
        let restaurant = RestaurantFixtures.newRestaurant(priceRange: "¥1000~1999")
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)


        expect(presenter.priceRange).to(equal("Price Range: ¥1000~1999"))
    }
}
