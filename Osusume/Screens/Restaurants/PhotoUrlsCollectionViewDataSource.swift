class PhotoUrlsCollectionViewDataSource: NSObject {
    private let photoUrls: [NSURL]
    private let editMode: Bool
    private let deletePhotoClosure: ((url: NSURL) -> Void)?

    init (
        photoUrls: [NSURL],
        editMode: Bool,
        deletePhotoClosure: ((url: NSURL) -> Void)?
    ) {
        self.photoUrls = photoUrls
        self.editMode = editMode
        self.deletePhotoClosure = deletePhotoClosure
    }
}

extension PhotoUrlsCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return photoUrls.count
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
            photoUrls[indexPath.row],
            isEditMode: editMode,
            deletePhotoClosure: deletePhotoClosure
        )

        return cell
    }
}
