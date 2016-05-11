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

        let restaurantWithPhotos = RestaurantFixtures.newRestaurant(photoUrl: "photo-url")
        detailPresenter = RestaurantDetailPresenter(restaurant: restaurantWithPhotos)
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
    }
}
