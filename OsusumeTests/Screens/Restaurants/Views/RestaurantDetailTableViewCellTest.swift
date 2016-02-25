import XCTest
import Nimble
@testable import Osusume

class RestaurantDetailTableViewCellTest: XCTestCase {
    var restaurantDetailTableViewCell: RestaurantDetailTableViewCell!

    func test_viewDidLoad_displaysDetailsOfARestaurant() {
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

        let restaurantDetailCell = RestaurantDetailTableViewCell(
            style: .Default,
            reuseIdentifier: String(RestaurantDetailTableViewCell)
        )

        restaurantDetailCell.configureViewWithRestaurant(restaurant)

        expect(restaurantDetailCell.nameLabel.text).to(equal("My Restaurant"))
        expect(restaurantDetailCell.addressLabel.text).to(equal("Roppongi"))
        expect(restaurantDetailCell.cuisineTypeLabel.text).to(equal("Sushi"))
        expect(restaurantDetailCell.offersEnglishMenuLabel.text).to(equal("Offers English menu"))
        expect(restaurantDetailCell.walkInsOkLabel.text).to(equal("Walk-ins not recommended"))
        expect(restaurantDetailCell.acceptsCreditCardsLabel.text).to(equal("Accepts credit cards"))
        expect(restaurantDetailCell.notesLabel.text).to(equal("This place is great"))
        expect(restaurantDetailCell.creationInfoLabel.text).to(equal("Added by Danny on 1/1/70"))
        expect(restaurantDetailCell.photoUrls.count).to(equal(1))

        let firstImageCell = restaurantDetailCell.collectionView(restaurantDetailCell.imageCollectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        let firstImageView = firstImageCell.backgroundView as! UIImageView
        expect(firstImageView.sd_imageURL()).to(equal(NSURL(string: "my-awesome-url")!))
    }

}
