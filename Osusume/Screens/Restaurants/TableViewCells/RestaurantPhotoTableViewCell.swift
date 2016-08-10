class RestaurantPhotoTableViewCell: UITableViewCell {
    // MARK: - View Elements
    let imageCollectionView: UICollectionView
    weak var delegate: RestaurantPhotoTableViewCellDelegate?
    private var photoUrlDataSource: PhotoUrlsCollectionViewDataSource?
    private(set) var dataSourcePhotoUrls: [PhotoUrl]
    private(set) var addedPhotos: [UIImage]

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        dataSourcePhotoUrls = [PhotoUrl]()
        addedPhotos = [UIImage]()

        imageCollectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: RestaurantPhotoTableViewCell.imageCollectionViewLayout()
        )

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        configureSubviews()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(reloader: Reloader, photoUrls: [PhotoUrl], router: Router) {
        dataSourcePhotoUrls = photoUrls
        photoUrlDataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: false,
            deletePhotoClosure: nil
        )

        imageCollectionView.dataSource = photoUrlDataSource

        reloader.reload(imageCollectionView)
    }

    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(imageCollectionView)
    }

    private func configureSubviews() {
        imageCollectionView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        imageCollectionView.registerClass(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: String(PhotoCollectionViewCell)
        )
        imageCollectionView.backgroundColor = UIColor.lightGrayColor()
        imageCollectionView.delegate = self
    }

    private func addConstraints() {
        imageCollectionView.autoPinEdgesToSuperviewEdges()
        imageCollectionView.autoSetDimension(.Height, toSize: 120.0)
    }

    // MARK: - Private Methods
    private static func imageCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(100, 100)
        layout.scrollDirection = .Horizontal
        return layout
    }
}

// MARK: - UICollectionViewDelegate
extension RestaurantPhotoTableViewCell: UICollectionViewDelegate {
    func collectionView(
        collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.delegate?.displayImageScreen(dataSourcePhotoUrls[indexPath.row].url)
    }
}

// MARK: - PhotoUrlsDataSource
extension RestaurantPhotoTableViewCell: PhotoUrlsDataSource {
    func getPhotoUrls() -> [PhotoUrl] {
        return self.dataSourcePhotoUrls
    }
}

// MARK: - AddedPhotosDataSource
extension RestaurantPhotoTableViewCell: AddedPhotosDataSource {
    func getAddedPhotos() -> [UIImage] {
        return self.addedPhotos
    }
}
