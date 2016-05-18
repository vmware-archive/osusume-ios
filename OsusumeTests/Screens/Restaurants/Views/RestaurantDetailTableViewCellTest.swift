import XCTest
import Nimble
@testable import Osusume

class RestaurantDetailTableViewCellTest: XCTestCase {
    let fakeReloader: FakeReloader = FakeReloader()
    let fakeRouter: FakeRouter = FakeRouter()
    var restaurantDetailCell: RestaurantDetailTableViewCell!

    override func setUp() {
        restaurantDetailCell = RestaurantDetailTableViewCell(
            style: .Default,
            reuseIdentifier: String(RestaurantDetailTableViewCell)
        )
    }

    func test_configureView_displaysDetailsOfARestaurant() {
        restaurantDetailCell.configureView(
            Restaurant(
                id: 1,
                name: "My Restaurant",
                address: "Roppongi",
                cuisineType: "Sushi",
                cuisine: Cuisine(id: 1, name: "Pizza"),
                offersEnglishMenu: true,
                walkInsOk: false,
                acceptsCreditCards: true,
                notes: "This place is great",
                author: "Danny",
                liked: true,
                numberOfLikes: 2,
                priceRange: "0~999",
                createdAt: NSDate(timeIntervalSince1970: 0),
                photoUrls: [NSURL(string: "my-awesome-url")!],
                comments: []
            ),
            reloader: FakeReloader(),
            router: FakeRouter()
        )

        expect(self.restaurantDetailCell.nameLabel.text)
            .to(equal("My Restaurant"))
        expect(self.restaurantDetailCell.addressLabel.text)
            .to(equal("Roppongi"))
        expect(self.restaurantDetailCell.cuisineTypeLabel.text)
            .to(equal("Cuisine: Pizza"))
        expect(self.restaurantDetailCell.offersEnglishMenuLabel.text)
            .to(equal("Offers English menu"))
        expect(self.restaurantDetailCell.walkInsOkLabel.text)
            .to(equal("Walk-ins not recommended"))
        expect(self.restaurantDetailCell.acceptsCreditCardsLabel.text)
            .to(equal("Accepts credit cards"))
        expect(self.restaurantDetailCell.notesLabel.text)
            .to(equal("This place is great"))
        expect(self.restaurantDetailCell.numberOfLikesLabel.text)
            .to(equal("2 people liked"))
        expect(self.restaurantDetailCell.priceRangeLabel.text)
            .to(equal("Price Range: 0~999"))	
        expect(self.restaurantDetailCell.creationInfoLabel.text)
            .to(equal("Added by Danny on 1/1/70"))
        expect(self.restaurantDetailCell.photoUrls.count).to(equal(1))
    }

    func test_configureView_displaysRestaurantImage() {
        restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(photoUrl: "my-awesome-url"),
            reloader: FakeReloader(),
            router: FakeRouter()
        )

        let firstImageCell = restaurantDetailCell
            .collectionView(
                restaurantDetailCell.imageCollectionView,
                cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        let firstImageView = firstImageCell.backgroundView as? UIImageView
        expect(firstImageView?.sd_imageURL())
            .to(equal(NSURL(string: "my-awesome-url")!))
    }

    func test_configureView_displaysLikedState_whenLiked() {
        restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(liked: true),
            reloader: fakeReloader,
            router: fakeRouter
        )

        expect(self.restaurantDetailCell.likeButton.backgroundColor)
            .toEventually(equal(UIColor.redColor()))
        expect(self.restaurantDetailCell.likeButton.titleColorForState(.Normal))
            .toEventually(equal(UIColor.blueColor()))
        expect(self.restaurantDetailCell.likeButton.enabled)
            .toEventually(beFalse())
    }

    func test_configureView_reloadsCollectionViewData() {
        restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(),
            reloader: fakeReloader,
            router: fakeRouter
        )

        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    func test_configureView_displaysLikedState_whenNotLiked() {
        restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(liked: false),
            reloader: fakeReloader,
            router: fakeRouter
        )

        expect(self.restaurantDetailCell.likeButton.backgroundColor)
            .toEventually(equal(UIColor.blueColor()))
        expect(self.restaurantDetailCell.likeButton.titleColorForState(.Normal))
            .toEventually(equal(UIColor.redColor()))
        expect(self.restaurantDetailCell.likeButton.enabled)
            .toEventually(beTrue())
    }

    func test_tappingAnImage_showsAFullScreenImage() {
        restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(
                photoUrl: "http://www.example.com/cat.jpg"
            ),
            reloader: fakeReloader,
            router: fakeRouter
        )

        restaurantDetailCell
            .imageCollectionView
            .delegate!
            .collectionView!(
                restaurantDetailCell.imageCollectionView,
                didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
        )

        expect(self.fakeRouter.imageScreenIsShowing).to(equal(true))
        expect(self.fakeRouter.showImageScreen_args)
            .to(equal(NSURL(string: "http://www.example.com/cat.jpg")))
    }
}
