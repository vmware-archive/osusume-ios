class AddRestaurantPhotosTableViewCell: UITableViewCell {
    // MARK: - Properties

    // MARK: - View Elements
    let imageCollectionView: UICollectionView
    let addPhotoButton: UIButton

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        imageCollectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: AddRestaurantPhotosTableViewCell.imageCollectionViewLayout()
        )
        addPhotoButton = UIButton(type: UIButtonType.System)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        configureSubviews()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(addPhotoButton)
    }

    private func configureSubviews() {
        imageCollectionView.backgroundColor = UIColor.lightGrayColor()
        imageCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)

        imageCollectionView.registerClass(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: String(UICollectionViewCell)
        )

        addPhotoButton.setTitle("Add photos", forState: .Normal)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addConstraints() {
        imageCollectionView.autoPinEdgesToSuperviewEdgesWithInsets(
            UIEdgeInsetsZero,
            excludingEdge: .Bottom
        )
        imageCollectionView.autoSetDimension(.Height, toSize: 120.0)

        addPhotoButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageCollectionView, withOffset: 0.0)
        addPhotoButton.autoAlignAxis(.Vertical, toSameAxisOfView: self.contentView)
        addPhotoButton.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Public Methods
    func configureCell(
        parentViewController: NewRestaurantViewController,
        dataSource: UICollectionViewDataSource,
        reloader: Reloader)
    {
        addPhotoButton.addTarget(
            parentViewController,
            action: #selector(NewRestaurantViewController.didTapAddPhotoButton(_:)),
            forControlEvents: .TouchUpInside
        )

        imageCollectionView.dataSource = dataSource
        reloader.reload(imageCollectionView)
    }

    // MARK: - Private Methods
    private static func imageCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(100, 100)
        layout.scrollDirection = .Horizontal
        return layout
    }
}
