import XCTest
import Nimble
@testable import Osusume

class EditRestaurantPhotosTableViewCellTest: XCTestCase {
    
    var editRestaurantPhotosTVC: EditRestaurantPhotosTableViewCell!
    
    override func setUp() {
        editRestaurantPhotosTVC = EditRestaurantPhotosTableViewCell()
    }
    
    // MARK: - Initialize View
    func test_viewDidLoad_initializesSubviews() {
        expect(self.editRestaurantPhotosTVC.imageCollectionView)
            .to(beAKindOf(UICollectionView))
        expect(self.editRestaurantPhotosTVC.addPhotoButton)
            .to(beAKindOf(UIButton))
    }
    
    func test_viewDidLoad_addsSubviews() {
        expect(self.editRestaurantPhotosTVC.contentView)
            .to(containSubview(editRestaurantPhotosTVC.imageCollectionView))
        expect(self.editRestaurantPhotosTVC.contentView)
            .to(containSubview(editRestaurantPhotosTVC.addPhotoButton))
    }
    
    func test_viewDidLoad_addsConstraints() {
        expect(self.editRestaurantPhotosTVC.imageCollectionView)
            .to(hasConstraintsToSuperviewOrSelf())
        expect(self.editRestaurantPhotosTVC.addPhotoButton)
            .to(hasConstraintsToSuperviewOrSelf())
    }

    func test_cellDoesNotAppearSelected() {
        expect(self.editRestaurantPhotosTVC.selectionStyle == .None).to(beTrue())
    }

    // MARK: - Photo Collection View
    func test_imageCollectionView_setsDatasource() {
        let restaurant = RestaurantFixtures.newRestaurant()

        let parentViewController = EditRestaurantViewController(
            router: FakeRouter(),
            repo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            sessionRepo: FakeSessionRepo(),
            reloader: FakeReloader(),
            restaurant: restaurant
        )

        editRestaurantPhotosTVC.configureCell(
            parentViewController,
            dataSource: self,
            reloader: FakeReloader()
        )

        expect(self.editRestaurantPhotosTVC.imageCollectionView.dataSource === self)
            .to(beTrue())
    }

    func test_configureCell_reloadsImageCollectionView() {
        let fakeReloader = FakeReloader()

        let restaurant = RestaurantFixtures.newRestaurant()

        let parentViewController = EditRestaurantViewController(
            router: FakeRouter(),
            repo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            sessionRepo: FakeSessionRepo(),
            reloader: fakeReloader,
            restaurant: restaurant
        )

        editRestaurantPhotosTVC.configureCell(
            parentViewController,
            dataSource: self,
            reloader: fakeReloader
        )


        expect(fakeReloader.reload_wasCalled).to(beTrue())
    }
    
    func test_imageCollectionView_registersPhotoCollectionViewCell() {
        let restaurant = RestaurantFixtures.newRestaurant()

        let parentViewController = EditRestaurantViewController(
            router: FakeRouter(),
            repo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            sessionRepo: FakeSessionRepo(),
            reloader: FakeReloader(),
            restaurant: restaurant
        )

        editRestaurantPhotosTVC.configureCell(
            parentViewController,
            dataSource: self,
            reloader: FakeReloader()
        )
        
        let cellIdentifier = String(PhotoCollectionViewCell)
        let cell = editRestaurantPhotosTVC.imageCollectionView
            .dequeueReusableCellWithReuseIdentifier(
                cellIdentifier,
                forIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )
        
        
        expect(cell).toNot(beNil())
    }
}

// MARK: - UICollectionViewDataSource
extension EditRestaurantPhotosTableViewCellTest: UICollectionViewDataSource {
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
