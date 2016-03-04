import XCTest
import Nimble
@testable import Osusume

class RestaurantTableViewCellTest: XCTestCase {
    func test_setPresenter_setsContent() {
        let restaurant = Restaurant(
            id: 1,
            name: "My Restaurant",
            address: "Roppongi",
            cuisineType: "Sushi",
            offersEnglishMenu: true,
            walkInsOk: false,
            acceptsCreditCards: true,
            notes: "This place is great",
            author: "Danny",
            createdAt: NSDate(timeIntervalSince1970: 0),
            photoUrls: [NSURL(string: "my-awesome-url")!],
            comments: []
        )

        let restaurantCell = RestaurantTableViewCell(
            style: .Default,
            reuseIdentifier: String(RestaurantTableViewCell)
        )

        let presenter = RestaurantDetailPresenter(restaurant: restaurant)

        restaurantCell.setPresenter(presenter)

        expect(restaurantCell.photoImageView.getImageURL()).to(equal(NSURL(string: "my-awesome-url")))
        expect(restaurantCell.nameLabel.text).to(equal("My Restaurant"))
        expect(restaurantCell.cuisineTypeLabel.text).to(equal("Sushi"))
        expect(restaurantCell.authorLabel.text).to(equal("Added by Danny"))
        expect(restaurantCell.createdAtLabel.text).to(equal("Created on 1/1/70"))
    }
}