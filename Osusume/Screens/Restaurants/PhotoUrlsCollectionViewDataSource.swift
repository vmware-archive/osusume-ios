protocol PhotoUrlsDataSource {
    func getPhotoUrls() -> [PhotoUrl]
}

protocol AddedPhotosDataSource {
    func getAddedPhotos() -> [UIImage]
}

enum PhotoUrlsCollectionViewDataSourceSections: Int {
    case PhotoUrls = 0
    case AddedImages
    case Count

    static var count: Int {
        get {
            return PhotoUrlsCollectionViewDataSourceSections.Count.rawValue
        }
    }
}

class PhotoUrlsCollectionViewDataSource: NSObject {
    private let photoUrlsDataSource: PhotoUrlsDataSource!
    private let addedPhotosDataSource: AddedPhotosDataSource!
    private let editMode: Bool
    private let deletePhotoClosure: ((photoUrlId: Int) -> Void)?

    init (
        photoUrlsDataSource: PhotoUrlsDataSource,
        addedPhotosDataSource: AddedPhotosDataSource,
        editMode: Bool,
        deletePhotoClosure: ((photoUrlId: Int) -> Void)?
    ) {
        self.photoUrlsDataSource = photoUrlsDataSource
        self.addedPhotosDataSource = addedPhotosDataSource
        self.editMode = editMode
        self.deletePhotoClosure = deletePhotoClosure
    }
}

extension PhotoUrlsCollectionViewDataSource: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return PhotoUrlsCollectionViewDataSourceSections.count
    }

    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        if (section == 0) {
            return photoUrlsDataSource.getPhotoUrls().count
        }

        return addedPhotosDataSource.getAddedPhotos().count
    }

    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            String(PhotoCollectionViewCell),
            forIndexPath: indexPath
        ) as! PhotoCollectionViewCell

        switch indexPath.section {
        case PhotoUrlsCollectionViewDataSourceSections.PhotoUrls.rawValue:
            cell.configureCell(
                photoUrlsDataSource.getPhotoUrls()[indexPath.row],
                isEditMode: editMode,
                deletePhotoClosure: deletePhotoClosure
            )
        case PhotoUrlsCollectionViewDataSourceSections.AddedImages.rawValue:
            cell.configureCell(
                addedPhotosDataSource.getAddedPhotos()[indexPath.row]
            )
        default: break
        }

        return cell
    }
}
