protocol PhotoUrlsDataSource {
    func getPhotoUrls() -> [NSURL]
}

class PhotoUrlsCollectionViewDataSource: NSObject {
    private let photoUrlsDataSource: PhotoUrlsDataSource!
    private let editMode: Bool
    private let deletePhotoClosure: ((url: NSURL) -> Void)?

    init (
        photoUrlsDataSource: PhotoUrlsDataSource,
        editMode: Bool,
        deletePhotoClosure: ((url: NSURL) -> Void)?
    ) {
        self.photoUrlsDataSource = photoUrlsDataSource
        self.editMode = editMode
        self.deletePhotoClosure = deletePhotoClosure
    }
}

extension PhotoUrlsCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return photoUrlsDataSource.getPhotoUrls().count
    }

    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            String(PhotoCollectionViewCell),
            forIndexPath: indexPath
        ) as! PhotoCollectionViewCell

        cell.configureCell(
            photoUrlsDataSource.getPhotoUrls()[indexPath.row],
            isEditMode: editMode,
            deletePhotoClosure: deletePhotoClosure
        )

        return cell
    }
}
