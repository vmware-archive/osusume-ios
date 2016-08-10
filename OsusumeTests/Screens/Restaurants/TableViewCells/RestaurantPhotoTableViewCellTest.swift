import XCTest
import Nimble
@testable import Osusume

class RestaurantPhotoTableViewCellTest: XCTestCase {
    var restaurantPhotoCell: RestaurantPhotoTableViewCell!
    let fakeReloader = FakeReloader()
    let fakeRouter = FakeRouter()

    var displayImageScreen_arg: NSURL?

    override func setUp() {
        restaurantPhotoCell = RestaurantPhotoTableViewCell(
            style: .Default,
            reuseIdentifier: String(RestaurantPhotoTableViewCell)
        )
    }

    func test_init_initializesSubviews() {
        expect(self.restaurantPhotoCell.imageCollectionView)
            .to(beAKindOf(UICollectionView))
    }

    func test_init_addsSubviews() {
        expect(self.restaurantPhotoCell.contentView)
            .to(containSubview(restaurantPhotoCell.imageCollectionView))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.restaurantPhotoCell.imageCollectionView)
            .to(hasConstraintsToSuperview())
    }

    func test_configureCell_reloadsCollectionView() {
        restaurantPhotoCell.configureCell(fakeReloader, photoUrls: [], router: fakeRouter)


        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    func test_configureCell_setsPhotosDataSource() {
        restaurantPhotoCell.configureCell(FakeReloader(), photoUrls: [], router: fakeRouter)


        expect(self.restaurantPhotoCell.imageCollectionView.dataSource is PhotoUrlsCollectionViewDataSource).to(beTrue())
    }

    func test_tappingAnImage_showsAFullScreenImage() {
        restaurantPhotoCell.delegate = self
        restaurantPhotoCell.configureCell(
            fakeReloader,
            photoUrls: [
                PhotoUrl(id: 10, url: NSURL(string: "http://www.example.com/cat.jpg")!)
            ],
            router: fakeRouter
        )

        restaurantPhotoCell
            .imageCollectionView
            .delegate!
            .collectionView!(
                restaurantPhotoCell.imageCollectionView,
                didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
        )

        expect(self.displayImageScreen_arg)
            .to(equal(NSURL(string: "http://www.example.com/cat.jpg")!))
    }
}

extension RestaurantPhotoTableViewCellTest: RestaurantPhotoTableViewCellDelegate {
    func displayImageScreen(url: NSURL) {
        displayImageScreen_arg = url
    }
}