import XCTest
import Nimble
@testable import Osusume

class RestaurantDetailTableViewCellTest: XCTestCase {
    let fakeReloader: FakeReloader = FakeReloader()
    let fakeRouter: FakeRouter = FakeRouter()
    var restaurantDetailCell: RestaurantDetailTableViewCell!

    var displayAddCommentScreen_wasCalled = false
    var didTapLikeButton_wasCalled = false
    var displayMapScreen_wasCalled = false
    var displayImageScreen_arg: NSURL?

    override func setUp() {
        restaurantDetailCell = RestaurantDetailTableViewCell(
            style: .Default,
            reuseIdentifier: String(RestaurantDetailTableViewCell)
        )
    }

    func test_init_initializesSubviews() {
        expect(self.restaurantDetailCell.imageCollectionView)
            .to(beAKindOf(UICollectionView))
        expect(self.restaurantDetailCell.nameLabel)
            .to(beAKindOf(UILabel))
        expect(self.restaurantDetailCell.addressLabel)
            .to(beAKindOf(UILabel))
        expect(self.restaurantDetailCell.viewMapButton)
            .to(beAKindOf(UIButton))
        expect(self.restaurantDetailCell.cuisineTypeLabel)
            .to(beAKindOf(UILabel))
        expect(self.restaurantDetailCell.priceRangeLabel)
            .to(beAKindOf(UILabel))
        expect(self.restaurantDetailCell.nearestStationLabel)
            .to(beAKindOf(UILabel))
        expect(self.restaurantDetailCell.notesLabel)
            .to(beAKindOf(UILabel))
        expect(self.restaurantDetailCell.creationInfoLabel)
            .to(beAKindOf(UILabel))
        expect(self.restaurantDetailCell.likeButton)
            .to(beAKindOf(UIButton))
        expect(self.restaurantDetailCell.addCommentButton)
            .to(beAKindOf(UIButton))
    }

    func test_init_addsSubviews() {
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.imageCollectionView))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.nameLabel))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.addressLabel))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.viewMapButton))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.cuisineTypeLabel))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.priceRangeLabel))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.nearestStationLabel))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.notesLabel))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.creationInfoLabel))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.likeButton))
        expect(self.restaurantDetailCell.contentView)
            .to(containSubview(restaurantDetailCell.addCommentButton))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.restaurantDetailCell.imageCollectionView)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.nameLabel)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.addressLabel)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.viewMapButton)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.cuisineTypeLabel)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.priceRangeLabel)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.nearestStationLabel)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.notesLabel)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.creationInfoLabel)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.likeButton)
            .to(hasConstraintsToSuperview())
        expect(self.restaurantDetailCell.addCommentButton)
            .to(hasConstraintsToSuperview())
    }

    func test_tappingAddCommentButton_callsDisplayAddCommentScreenOnDelegate() {
        self.restaurantDetailCell.delegate = self
        self.restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(),
            reloader: fakeReloader,
            router: fakeRouter
        )


        tapButton(self.restaurantDetailCell.addCommentButton)


        expect(self.displayAddCommentScreen_wasCalled).to(beTrue())
    }

    func test_tappingLikeButton_callsDidTapLikeButtonOnDelegate() {
        self.restaurantDetailCell.delegate = self
        self.restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(),
            reloader: fakeReloader,
            router: fakeRouter
        )


        tapButton(self.restaurantDetailCell.likeButton)


        expect(self.didTapLikeButton_wasCalled).to(beTrue())
    }

    func test_tappingViewMapButton_setsViewInMapButtonDelegateAsCellDelegate() {
        self.restaurantDetailCell.delegate = self
        self.restaurantDetailCell.configureView(
            RestaurantFixtures.newRestaurant(),
            reloader: fakeReloader,
            router: fakeRouter
        )


        tapButton(self.restaurantDetailCell.viewMapButton)


        expect(self.displayMapScreen_wasCalled).to(beTrue())
    }

    func test_configureView_setsButtonTitles() {
        expect(self.restaurantDetailCell.viewMapButton.titleLabel?.text).to(equal("view in map"))
        expect(self.restaurantDetailCell.likeButton.titleLabel?.text).to(equal("Like"))
        expect(self.restaurantDetailCell.addCommentButton.titleLabel?.text).to(equal("Add comment"))
    }

    func test_configureView_displaysDetailsOfARestaurant() {
        restaurantDetailCell.configureView(
            Restaurant(
                id: 1,
                name: "My Restaurant",
                address: "Roppongi",
                placeId: "abcd",
                latitude: 0,
                longitude: 0,
                cuisineType: "Sushi",
                cuisine: Cuisine(id: 1, name: "Pizza"),
                notes: "This place is great",
                liked: true,
                numberOfLikes: 2,
                priceRange: PriceRange(id: 1, range: "0~999"),
                nearestStation: "Roppongi",
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
        expect(self.restaurantDetailCell.nearestStationLabel.text)
            .to(equal("Roppongi"))
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
        restaurantDetailCell.delegate = self
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

        expect(self.displayImageScreen_arg).to(equal(NSURL(string: "http://www.example.com/cat.jpg")!))
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

extension RestaurantDetailTableViewCellTest: RestaurantDetailTableViewCellDelegate {
    func displayAddCommentScreen(sender: UIButton) {
        displayAddCommentScreen_wasCalled = true
    }

    func didTapLikeButton(sender: UIButton) {
        didTapLikeButton_wasCalled = true
    }

    func displayMapScreen(sender: UIButton) {
        displayMapScreen_wasCalled = true
    }

    func displayImageScreen(url: NSURL) {
        displayImageScreen_arg = url
    }
}