import XCTest
import BrightFutures
import Nimble
@testable import Osusume

class RestaurantTableViewCellTest: XCTestCase {
    let fakePhotoRepo = FakePhotoRepo()
    var cell: RestaurantTableViewCell!
    var detailPresenter: RestaurantDetailPresenter!

    override func setUp() {
        cell = RestaurantTableViewCell(
            style: .Default,
            reuseIdentifier: String(RestaurantTableViewCell)
        )

        let restaurantWithPhotos = RestaurantFixtures.newRestaurant(
            photoUrls: [
                PhotoUrl(id: 10, url: NSURL(string: "photo-url")!)
            ]
        )
        detailPresenter = RestaurantDetailPresenter(restaurant: restaurantWithPhotos)
    }

    func test_viewDidLoad_initializesSubviews() {
        expect(self.cell.photoImageView)
            .to(beAKindOf(UIImageView))
        expect(self.cell.textContentView)
            .to(beAKindOf(UIView))
        expect(self.cell.nameLabel)
            .to(beAKindOf(UILabel))
        expect(self.cell.cuisineTypeLabel)
            .to(beAKindOf(UILabel))
        expect(self.cell.priceRangeLabel)
            .to(beAKindOf(UILabel))
        expect(self.cell.nearestStationLabel)
            .to(beAKindOf(UILabel))
        expect(self.cell.numberOfLikesLabel)
            .to(beAKindOf(UILabel))
        expect(self.cell.authorLabel)
            .to(beAKindOf(UILabel))
        expect(self.cell.createdAtLabel)
            .to(beAKindOf(UILabel))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.cell.contentView)
            .to(containSubview(self.cell.photoImageView))
        expect(self.cell.contentView)
            .to(containSubview(self.cell.textContentView))
        expect(self.cell.contentView)
            .to(containSubview(self.cell.nameLabel))
        expect(self.cell.contentView)
            .to(containSubview(self.cell.cuisineTypeLabel))
        expect(self.cell.contentView)
            .to(containSubview(self.cell.priceRangeLabel))
        expect(self.cell.contentView)
            .to(containSubview(self.cell.nearestStationLabel))
        expect(self.cell.contentView)
            .to(containSubview(self.cell.numberOfLikesLabel))
        expect(self.cell.contentView)
            .to(containSubview(self.cell.authorLabel))
        expect(self.cell.contentView)
            .to(containSubview(self.cell.createdAtLabel))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.cell.photoImageView)
            .to(hasConstraintsToSuperview())
        expect(self.cell.textContentView)
            .to(hasConstraintsToSuperview())
        expect(self.cell.nameLabel)
            .to(hasConstraintsToSuperview())
        expect(self.cell.cuisineTypeLabel)
            .to(hasConstraintsToSuperview())
        expect(self.cell.priceRangeLabel)
            .to(hasConstraintsToSuperview())
        expect(self.cell.nearestStationLabel)
            .to(hasConstraintsToSuperview())
        expect(self.cell.numberOfLikesLabel)
            .to(hasConstraintsToSuperview())
        expect(self.cell.authorLabel)
            .to(hasConstraintsToSuperview())
        expect(self.cell.createdAtLabel)
            .to(hasConstraintsToSuperview())
    }

    func test_configureView_startsWithPlaceholderImage() {
        cell.configureView(fakePhotoRepo, presenter: detailPresenter)


        let expectedImage = UIImage(named: "TableCellPlaceholder")
        let expectedImageData = UIImageJPEGRepresentation(expectedImage!, 1.0)
        let actualImageData = UIImageJPEGRepresentation(cell.photoImageView.image!, 1.0)

        expect(expectedImageData).to(equal(actualImageData))
    }

    func test_configureView_loadsImageFromPhotoUrl() {
        cell.configureView(fakePhotoRepo, presenter: detailPresenter)


        expect(self.fakePhotoRepo.loadImageFromUrl_args?.absoluteString).to(equal("photo-url"))
    }

    func test_configureView_setsLoadedImageOnImageView() {
        let promise = Promise<UIImage, RepoError>()
        fakePhotoRepo.loadImageFromUrl_returnValue = promise.future



        cell.configureView(fakePhotoRepo, presenter: detailPresenter)


        let expectedImage = testImage(named: "appleLogo", imageExtension: "png")
        promise.success(expectedImage)
        waitForFutureToComplete(promise.future)

        let expectedImageData = UIImageJPEGRepresentation(expectedImage, 1.0)
        let actualImageData = UIImageJPEGRepresentation(cell.photoImageView.image!, 1.0)
        expect(expectedImageData).to(equal(actualImageData))
    }

    func test_configureView_setsLabelText() {
        cell.configureView(fakePhotoRepo, presenter: detailPresenter)


        expect(self.cell.nameLabel.text).toNot(beNil())
        expect(self.cell.cuisineTypeLabel.text).toNot(beNil())
        expect(self.cell.priceRangeLabel.text).toNot(beNil())
        expect(self.cell.numberOfLikesLabel.text).toNot(beNil())
        expect(self.cell.authorLabel.text).toNot(beNil())
        expect(self.cell.createdAtLabel.text).toNot(beNil())
        expect(self.cell.nearestStationLabel.text).toNot(beNil())
    }
}
