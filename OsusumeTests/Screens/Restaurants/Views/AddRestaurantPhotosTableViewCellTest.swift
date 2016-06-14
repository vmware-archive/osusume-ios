import XCTest
import Nimble
@testable import Osusume

class AddRestaurantPhotosTableViewCellTest: XCTestCase {

    var addRestaurantPhotosTVC: AddRestaurantPhotosTableViewCell!

    override func setUp() {
        addRestaurantPhotosTVC = AddRestaurantPhotosTableViewCell()
    }

    // MARK: - Initialize View
    func test_viewDidLoad_initializesSubviews() {
        expect(self.addRestaurantPhotosTVC.imageCollectionView)
            .to(beAKindOf(UICollectionView))
        expect(self.addRestaurantPhotosTVC.addPhotoButton)
            .to(beAKindOf(UIButton))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.addRestaurantPhotosTVC.contentView)
            .to(containSubview(addRestaurantPhotosTVC.imageCollectionView))
        expect(self.addRestaurantPhotosTVC.contentView)
            .to(containSubview(addRestaurantPhotosTVC.addPhotoButton))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.addRestaurantPhotosTVC.imageCollectionView)
            .to(hasConstraintsToSuperviewOrSelf())
        expect(self.addRestaurantPhotosTVC.addPhotoButton)
            .to(hasConstraintsToSuperviewOrSelf())
    }

    func test_cellDoesNotAppearSelected() {
        expect(self.addRestaurantPhotosTVC.selectionStyle == .None).to(beTrue())
    }

    // MARK: - Photo Collection View
    func test_imageCollectionView_setsDatasource() {
        let parentViewController = NewRestaurantViewController(
            router: FakeRouter(),
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            reloader: FakeReloader()
        )


        addRestaurantPhotosTVC.configureCell(
            parentViewController,
            dataSource: parentViewController,
            reloader: FakeReloader()
        )


        expect(self.addRestaurantPhotosTVC.imageCollectionView.dataSource === parentViewController).to(beTrue())
    }

    func test_configureCell_reloadsImageCollectionView() {
        let parentViewController = NewRestaurantViewController(
            router: FakeRouter(),
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            reloader: FakeReloader()
        )
        let fakeReloader = FakeReloader()


        addRestaurantPhotosTVC.configureCell(
            parentViewController,
            dataSource: parentViewController,
            reloader: fakeReloader)


        expect(fakeReloader.reload_wasCalled).to(beTrue())
    }

    func test_imageCollectionView_registersPhotoCollectionViewCell() {
        let parentViewController = NewRestaurantViewController(
            router: FakeRouter(),
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            reloader: FakeReloader()
        )
        addRestaurantPhotosTVC.configureCell(
            parentViewController,
            dataSource: self,
            reloader: FakeReloader()
        )

        let cellIdentifier = String(UICollectionViewCell)
        let cell = addRestaurantPhotosTVC.imageCollectionView
            .dequeueReusableCellWithReuseIdentifier(
                cellIdentifier,
                forIndexPath: NSIndexPath(forRow: 0, inSection: 0)
            )


        expect(cell).toNot(beNil())
    }
}

// MARK: - UICollectionViewDataSource
extension AddRestaurantPhotosTableViewCellTest: UICollectionViewDataSource {
    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int
    {
        return 1
    }

    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
        ) -> UICollectionViewCell
    {
        return UICollectionViewCell()
    }
}
