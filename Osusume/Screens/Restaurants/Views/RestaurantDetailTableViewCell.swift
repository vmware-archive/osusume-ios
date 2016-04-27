class RestaurantDetailTableViewCell: UITableViewCell {
    // MARK: - Properties
    private weak var router: Router?
    weak var delegate: RestaurantDetailTableViewCellDelegate?
    private(set) var photoUrls: [NSURL]

    // MARK: - View Elements
    let imageCollectionView: UICollectionView
    let nameLabel: UILabel
    let addressLabel: UILabel
    let cuisineTypeLabel: UILabel
    let priceRangeLabel: UILabel
    let numberOfLikesLabel: UILabel
    let offersEnglishMenuLabel: UILabel
    let walkInsOkLabel: UILabel
    let acceptsCreditCardsLabel: UILabel
    let notesLabel: UILabel
    let creationInfoLabel: UILabel
    let likeButton: UIButton
    let addCommentButton: UIButton

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        photoUrls = [NSURL]()

        imageCollectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: RestaurantDetailTableViewCell.imageCollectionViewLayout()
        )

        nameLabel = UILabel.newAutoLayoutView()
        addressLabel = UILabel.newAutoLayoutView()
        cuisineTypeLabel = UILabel.newAutoLayoutView()
        priceRangeLabel = UILabel.newAutoLayoutView()
        numberOfLikesLabel = UILabel.newAutoLayoutView()
        offersEnglishMenuLabel = UILabel.newAutoLayoutView()
        walkInsOkLabel = UILabel.newAutoLayoutView()
        acceptsCreditCardsLabel = UILabel.newAutoLayoutView()
        notesLabel = UILabel.newAutoLayoutView()
        creationInfoLabel = UILabel.newAutoLayoutView()
        likeButton = UIButton.newAutoLayoutView()
        addCommentButton = UIButton.newAutoLayoutView()

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
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(cuisineTypeLabel)
        contentView.addSubview(priceRangeLabel)
        contentView.addSubview(numberOfLikesLabel)
        contentView.addSubview(offersEnglishMenuLabel)
        contentView.addSubview(walkInsOkLabel)
        contentView.addSubview(acceptsCreditCardsLabel)
        contentView.addSubview(notesLabel)
        contentView.addSubview(creationInfoLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(addCommentButton)
    }

    private func configureSubviews() {
        imageCollectionView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        imageCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        imageCollectionView.backgroundColor = UIColor.lightGrayColor()
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self

        notesLabel.numberOfLines = 0

        likeButton.addTarget(
            self.delegate,
            action: #selector(RestaurantDetailViewController.didTapLikeButton(_:)),
            forControlEvents: .TouchUpInside
        )
        likeButton.setTitle("Like", forState: .Normal)

        addCommentButton.addTarget(
            self.delegate,
            action: #selector(RestaurantDetailViewController.displayAddCommentScreen(_:)),
            forControlEvents: .TouchUpInside
        )
        addCommentButton.setTitle("Add comment", forState: .Normal)
        addCommentButton.backgroundColor = UIColor.grayColor()
    }

    private func addConstraints() {
        imageCollectionView.autoPinEdgeToSuperviewEdge(.Top)
        imageCollectionView.autoSetDimension(.Height, toSize: 120.0)
        imageCollectionView.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
        imageCollectionView.autoMatchDimension(.Width, toDimension:.Width, ofView: contentView)

        nameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageCollectionView)
        nameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        addressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        addressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

        priceRangeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        priceRangeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressLabel)

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeLabel)

        numberOfLikesLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        numberOfLikesLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)

        offersEnglishMenuLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        offersEnglishMenuLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: numberOfLikesLabel)

        walkInsOkLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        walkInsOkLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: offersEnglishMenuLabel)

        acceptsCreditCardsLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        acceptsCreditCardsLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: walkInsOkLabel)

        notesLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        notesLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        notesLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: acceptsCreditCardsLabel)

        creationInfoLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        creationInfoLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesLabel)

        likeButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: creationInfoLabel)
        likeButton.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        likeButton.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

        addCommentButton.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        addCommentButton.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        addCommentButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: likeButton)
        addCommentButton.autoPinEdgeToSuperviewMargin(.Bottom)
    }

    // MARK: Public Methods
    func configureView(restaurant: Restaurant, reloader: Reloader, router: Router) {
        self.router = router
        photoUrls = restaurant.photoUrls

        reloader.reload(imageCollectionView)

        let restaurantDetailPresenter = RestaurantDetailPresenter(restaurant: restaurant)
        nameLabel.text = restaurantDetailPresenter.name
        addressLabel.text = restaurantDetailPresenter.address
        cuisineTypeLabel.text = restaurantDetailPresenter.cuisineType
        numberOfLikesLabel.text = restaurantDetailPresenter.numberOfLikes
        offersEnglishMenuLabel.text = restaurantDetailPresenter.offersEnglishMenu
        walkInsOkLabel.text = restaurantDetailPresenter.walkInsOk
        acceptsCreditCardsLabel.text = restaurantDetailPresenter.creditCardsOk
        notesLabel.text = restaurantDetailPresenter.notes
        creationInfoLabel.text = restaurantDetailPresenter.creationInfo
        priceRangeLabel.text = restaurantDetailPresenter.priceRange

        if restaurant.liked {
            likeButton.backgroundColor = UIColor.redColor()
            likeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            likeButton.backgroundColor = UIColor.blueColor()
            likeButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        }
    }

    // MARK: - Private Methods
    private static func imageCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(100, 100)
        layout.scrollDirection = .Horizontal
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension RestaurantDetailTableViewCell: UICollectionViewDataSource {
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
            "photoCell",
            forIndexPath: indexPath
        )

        let imageView = UIImageView()
        imageView.sd_setImageWithURL(photoUrls[indexPath.row])
        cell.backgroundView = imageView

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RestaurantDetailTableViewCell: UICollectionViewDelegate {
    func collectionView(
        collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.router?.showImageScreen(photoUrls[indexPath.row])
    }
}
