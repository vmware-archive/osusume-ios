class EditRestaurantPhotosTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    // MARK: - View Elements
    let imageCollectionView: UICollectionView
    
    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        imageCollectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: EditRestaurantPhotosTableViewCell.imageCollectionViewLayout()
        )
        
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
    }
    
    private func configureSubviews() {
        imageCollectionView.backgroundColor = UIColor.lightGrayColor()
        imageCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        imageCollectionView.registerClass(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: String(PhotoCollectionViewCell)
        )
    }
    
    private func addConstraints() {
        imageCollectionView.autoPinEdgesToSuperviewEdges()
        imageCollectionView.autoSetDimension(.Height, toSize: 120.0)
    }
    
    // MARK: - Public Methods
    func configureCell(dataSource: UICollectionViewDataSource, reloader: Reloader) {
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
