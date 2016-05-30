class PhotoUrlsCollectionViewDataSource: NSObject {
    private let photoUrls: [NSURL]

    init (photoUrls: [NSURL]) {
        self.photoUrls = photoUrls
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
        )

        let imageView = UIImageView()
        imageView.sd_setImageWithURL(photoUrls[indexPath.row])
        cell.backgroundView = imageView

        return cell
    }
}
