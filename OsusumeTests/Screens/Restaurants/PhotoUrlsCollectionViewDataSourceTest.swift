import XCTest
import Nimble
@testable import Osusume

class PhotoUrlsCollectionViewDataSourceTest: XCTestCase {

    func test_dataSource_configuresNumberOfRowsPerSection() {
        let collectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        let photoUrls = [
            NSURL(string: "url1")!,
            NSURL(string: "url2")!
        ]
        let dataSource = PhotoUrlsCollectionViewDataSource(photoUrls: photoUrls)


        let numberOfItems = dataSource.collectionView(
            collectionView,
            numberOfItemsInSection: 0
        )


        expect(numberOfItems).to(equal(2))
    }

    func test_dataSource_configuresCellWithImageView() {
        let collectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.registerClass(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: String(UICollectionViewCell)
        )
        let photoUrls = [
            NSURL(string: "url")!
        ]
        let dataSource = PhotoUrlsCollectionViewDataSource(photoUrls: photoUrls)
        collectionView.dataSource = dataSource


        let firstImageCell = dataSource.collectionView(
            collectionView,
            cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
        )


        let firstImageView = firstImageCell.backgroundView as? UIImageView
        expect(firstImageView?.sd_imageURL())
            .to(equal(NSURL(string: "url")!))
    }

}
