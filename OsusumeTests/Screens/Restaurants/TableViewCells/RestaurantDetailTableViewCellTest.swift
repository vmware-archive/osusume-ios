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
                notes: "This place is great",
                liked: true,
                numberOfLikes: 2,
                priceRange: PriceRange(id: 1, range: "0~999"),
                createdAt: NSDate(timeIntervalSince1970: 0),
                photoUrls: [
                    PhotoUrl(id: 1, url: NSURL(string: "my-awesome-url")!)
                ],
                createdByUser: (id: 99, name: "Danny", email: "danny@pivotal"),
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
                photoUrls: [
                    PhotoUrl(id: 10, url: NSURL(string: "http://www.example.com/cat.jpg")!)
                ]
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

    func test_configureView_setsPhotosDataSource() {
        restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(
            photoUrls: [
                PhotoUrl(id: 10, url: NSURL(string: "my-awesome-url")!)
            ]),
            reloader: FakeReloader(),
            router: FakeRouter()
        )


        expect(self.restaurantDetailCell.imageCollectionView.dataSource)
            .toNot(beNil())
        expect(self.restaurantDetailCell.imageCollectionView.dataSource is PhotoUrlsCollectionViewDataSource).to(beTrue())
    }
}
