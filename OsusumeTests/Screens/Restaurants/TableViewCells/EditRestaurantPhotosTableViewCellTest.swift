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
    }
    
    func test_viewDidLoad_addsSubviews() {
        expect(self.editRestaurantPhotosTVC.contentView)
            .to(containSubview(editRestaurantPhotosTVC.imageCollectionView))
    }
    
    func test_viewDidLoad_addsConstraints() {
        expect(self.editRestaurantPhotosTVC.imageCollectionView)
            .to(hasConstraintsToSuperviewOrSelf())
    }
        
    // MARK: - Photo Collection View
    func test_imageCollectionView_setsDatasource() {
        
        editRestaurantPhotosTVC.configureCell(
            self,
            reloader: FakeReloader()
        )
        
        expect(self.editRestaurantPhotosTVC.imageCollectionView.dataSource === self)
            .to(beTrue())
    }

    func test_configureCell_reloadsImageCollectionView() {
        let fakeReloader = FakeReloader()

        
        editRestaurantPhotosTVC.configureCell(self, reloader: fakeReloader)
        
        
        expect(fakeReloader.reload_wasCalled).to(beTrue())
    }
    
    func test_imageCollectionView_registersPhotoCollectionViewCell() {
        editRestaurantPhotosTVC.configureCell(
            self,
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
