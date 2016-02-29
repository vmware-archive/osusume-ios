import XCTest
import Nimble
@testable import Osusume

class RestaurantDetailTableViewCellTest: XCTestCase {
    var restaurantDetailTableViewCell: RestaurantDetailTableViewCell!
    var restaurantDetailCell: RestaurantDetailTableViewCell!
    var fakeReloader: FakeReloader!
    var fakeRouter: FakeRouter!

    override func setUp() {
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

        restaurantDetailCell = RestaurantDetailTableViewCell(
            style: .Default,
            reuseIdentifier: String(RestaurantDetailTableViewCell)
        )

        fakeReloader = FakeReloader()
        fakeRouter = FakeRouter()

        restaurantDetailCell.configureView(
            restaurant,
            reloader: fakeReloader,
            router: fakeRouter
        )
    }

    func test_viewDidLoad_displaysDetailsOfARestaurant() {
        expect(self.restaurantDetailCell.nameLabel.text).to(equal("My Restaurant"))
        expect(self.restaurantDetailCell.addressLabel.text).to(equal("Roppongi"))
        expect(self.restaurantDetailCell.cuisineTypeLabel.text).to(equal("Sushi"))
        expect(self.restaurantDetailCell.offersEnglishMenuLabel.text).to(equal("Offers English menu"))
        expect(self.restaurantDetailCell.walkInsOkLabel.text).to(equal("Walk-ins not recommended"))
        expect(self.restaurantDetailCell.acceptsCreditCardsLabel.text).to(equal("Accepts credit cards"))
        expect(self.restaurantDetailCell.notesLabel.text).to(equal("This place is great"))
        expect(self.restaurantDetailCell.creationInfoLabel.text).to(equal("Added by Danny on 1/1/70"))
        expect(self.restaurantDetailCell.photoUrls.count).to(equal(1))

        expect(self.fakeReloader.reload_wasCalled).to(beTrue())

        let firstImageCell = restaurantDetailCell.collectionView(restaurantDetailCell.imageCollectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        let firstImageView = firstImageCell.backgroundView as! UIImageView
        expect(firstImageView.sd_imageURL()).to(equal(NSURL(string: "my-awesome-url")!))
    }

    func test_tappingAnImage_showsAFullScreenImage() {
        restaurantDetailCell.imageCollectionView.delegate!.collectionView!(restaurantDetailCell.imageCollectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))

        expect(self.fakeRouter.imageScreenIsShowing).to(equal(true))
        expect(self.fakeRouter.showImageScreen_args).to(equal(NSURL(string: "my-awesome-url")))
    }
}
