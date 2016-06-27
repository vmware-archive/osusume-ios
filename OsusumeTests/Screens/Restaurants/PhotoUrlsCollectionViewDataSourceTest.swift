import XCTest
import Nimble
@testable import Osusume

class PhotoUrlsCollectionViewDataSourceTest: XCTestCase {

    var photoUrls: [PhotoUrl] = []
    var addedPhotos: [UIImage] = []

    func test_dataSource_hasTwoSections() {
        let collectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        let dataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: false,
            deletePhotoClosure: nil
        )


        let numberOfSections = dataSource.numberOfSectionsInCollectionView(collectionView)


        expect(numberOfSections).to(equal(2))
    }

    func test_dataSource_configuresNumberOfRowsPerSection() {
        let collectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        photoUrls = [
            PhotoUrl(id: 1, url: NSURL(string: "url1")!),
            PhotoUrl(id: 2, url: NSURL(string: "url2")!)
        ]
        addedPhotos = [
            UIImage(), UIImage(), UIImage()
        ]
        let dataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: false,
            deletePhotoClosure: nil
        )


        let numberOfItemsInSectionZero = dataSource.collectionView(
            collectionView,
            numberOfItemsInSection: 0
        )

        let numberOfItemsInSectionOne = dataSource.collectionView(
            collectionView,
            numberOfItemsInSection: 1
        )


        expect(numberOfItemsInSectionZero).to(equal(2))
        expect(numberOfItemsInSectionOne).to(equal(3))
    }

    func test_dataSource_configuresCellWithImageView_whenPhotoURL() {
        let collectionView = initializeImageCollectionView()
        photoUrls = [
            PhotoUrl(id: 1, url: NSURL(string: "url")!)
        ]
        let dataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: false,
            deletePhotoClosure: nil
        )
        collectionView.dataSource = dataSource


        let firstImageCell = dataSource.collectionView(
            collectionView,
            cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
        )


        let firstImageView = firstImageCell.backgroundView as? UIImageView
        expect(firstImageView?.sd_imageURL())
            .to(equal(NSURL(string: "url")!))
    }

    func test_dataSource_configuresCellWithImageView_whenAddedPhoto() {
        let collectionView = initializeImageCollectionView()
        let image = UIImage()
        addedPhotos = [image]
        let dataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: false,
            deletePhotoClosure: nil
        )
        collectionView.dataSource = dataSource


        let firstImageCell = dataSource.collectionView(
            collectionView,
            cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 1)
        )


        let firstImageView = firstImageCell.backgroundView as? UIImageView
        expect(firstImageView?.image).to(equal(image))
    }

    func test_dataSource_configureCellWithDeleteButtonHidden() {
        let collectionView = initializeImageCollectionView()
        photoUrls = [
            PhotoUrl(id: 1, url: NSURL(string: "url")!)
        ]


        let dataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: false,
            deletePhotoClosure: nil
        )
        collectionView.dataSource = dataSource
        let cell = dataSource.collectionView(
            collectionView,
            cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
            ) as? PhotoCollectionViewCell


        expect(cell?.deleteButton.hidden).to(beTrue())
    }

    func test_dataSource_configureCellWithDeleteButtonDisplayed() {
        let collectionView = initializeImageCollectionView()
        photoUrls = [
            PhotoUrl(id: 1, url: NSURL(string: "url")!)
        ]


        let dataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: true,
            deletePhotoClosure: nil
        )
        collectionView.dataSource = dataSource
        let cell = dataSource.collectionView(
            collectionView,
            cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
        ) as? PhotoCollectionViewCell


        expect(cell?.deleteButton.hidden).to(beFalse())
    }

    func test_tappingDeletePhotoButton_invokesDeleteOnPhotoRepo() {
        let collectionView = initializeImageCollectionView()
        photoUrls = [
            PhotoUrl(id: 1, url: NSURL(string: "url")!)
        ]
        var deletePhotoClosureWasCalled = false

        let dataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: true,
            deletePhotoClosure: { photoUrlId in
                deletePhotoClosureWasCalled = true
            }
        )
        collectionView.dataSource = dataSource


        let cell = dataSource.collectionView(
            collectionView,
            cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
            ) as? PhotoCollectionViewCell
        tapButton((cell?.deleteButton)!)


        expect(deletePhotoClosureWasCalled).to(beTrue())
    }

    // MARK: - Private Methods
    func initializeImageCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.registerClass(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: String(PhotoCollectionViewCell)
        )

        return collectionView
    }

}

extension PhotoUrlsCollectionViewDataSourceTest: PhotoUrlsDataSource {
    func getPhotoUrls() -> [PhotoUrl] {
        return photoUrls
    }
}

extension PhotoUrlsCollectionViewDataSourceTest: AddedPhotosDataSource {
    func getAddedPhotos() -> [UIImage] {
        return addedPhotos
    }
}
