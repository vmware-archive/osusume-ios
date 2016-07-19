import XCTest
import Nimble
@testable import Osusume

class NewRestaurantTest: XCTestCase {

    func test_allRequiredFieldsArePopulatedIsTrue_whenAllFieldsArePopulated() {
        let validRestaurant = NewRestaurant(
            name: "name",
            address: "address",
            placeId: "",
            latitude: 0,
            longitude: 0,
            cuisine: Cuisine(id: 1, name: "cuisine"),
            priceRange: PriceRange(id: 1, range: "100-1000"),
            nearestStation: "",
            notes: "",
            photoUrls: []
        )

        expect(validRestaurant.allRequiredFieldsArePopulated).to(beTrue())
    }

    func test_allRequiredFieldsArePopulatedIsFalse_whenNameIsNotPopulated() {
        let restaurantWithoutName = NewRestaurant(
            name: nil,
            address: "address",
            placeId: "",
            latitude: 0,
            longitude: 0,
            cuisine: Cuisine(id: 1, name: "cuisine"),
            priceRange: PriceRange(id: 1, range: "100-1000"),
            nearestStation: "",
            notes: "",
            photoUrls: []
        )


        expect(restaurantWithoutName.allRequiredFieldsArePopulated).to(beFalse())
    }

    func test_allRequiredFieldsArePopulatedIsFalse_whenAddressIsNotPopulated() {
        let restaurantWithoutAddress = NewRestaurant(
            name: "name",
            address: nil,
            placeId: "",
            latitude: 0,
            longitude: 0,
            cuisine: Cuisine(id: 1, name: "cuisine"),
            priceRange: PriceRange(id: 1, range: "100-1000"),
            nearestStation: "",
            notes: "",
            photoUrls: []
        )


        expect(restaurantWithoutAddress.allRequiredFieldsArePopulated).to(beFalse())
    }

    func test_allRequiredFieldsArePopulatedIsFalse_whenCuisineIsNotPopulated() {
        let restaurantWithoutCuisine = NewRestaurant(
            name: "name",
            address: "address",
            placeId: "",
            latitude: 0,
            longitude: 0,
            cuisine: nil,
            priceRange: PriceRange(id: 1, range: "100-1000"),
            nearestStation: "",
            notes: "",
            photoUrls: []
        )


        expect(restaurantWithoutCuisine.allRequiredFieldsArePopulated).to(beFalse())
    }

    func test_allRequiredFieldsArePopulatedIsFalse_whenPriceRangeIsNotPopulated() {
        let restaurantWithoutPriceRange = NewRestaurant(
            name: "name",
            address: "address",
            placeId: "",
            latitude: 0,
            longitude: 0,
            cuisine: Cuisine(id: 1, name: "cuisine"),
            priceRange: nil,
            nearestStation: "",
            notes: "",
            photoUrls: []
        )

        expect(restaurantWithoutPriceRange.allRequiredFieldsArePopulated).to(beFalse())
    }

}
