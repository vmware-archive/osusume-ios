protocol RestaurantDetailTableViewCellDelegate: NSObjectProtocol {
    func displayAddCommentScreen()
}

class RestaurantDetailTableViewCell: UITableViewCell {

    weak var delegate: RestaurantDetailTableViewCellDelegate?

    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let cuisineTypeLabel = UILabel()
    let offersEnglishMenuLabel = UILabel()
    let walkInsOkLabel = UILabel()
    let acceptsCreditCardsLabel = UILabel()
    let notesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    let creationInfoLabel = UILabel()
    let addCommentButton = UIButton.newAutoLayoutView()
    var photoUrls: [NSURL] = []

    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(100, 100)
        layout.scrollDirection = .Horizontal

        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView.backgroundColor = UIColor.lightGrayColor()
        collectionView.accessibilityLabel = "Restaurant photos"

        return collectionView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(imageCollectionView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(cuisineTypeLabel)
        contentView.addSubview(offersEnglishMenuLabel)
        contentView.addSubview(walkInsOkLabel)
        contentView.addSubview(acceptsCreditCardsLabel)
        contentView.addSubview(notesLabel)
        contentView.addSubview(creationInfoLabel)
        contentView.addSubview(addCommentButton)

        addCommentButton.addTarget(
            self,
            action: "didTapAddNewCommentButton",
            forControlEvents: .TouchUpInside
        )
        addCommentButton.setTitle("Add comment", forState: .Normal)
        addCommentButton.backgroundColor = UIColor.grayColor()

        applyViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Actions
    func didTapAddNewCommentButton() {
        delegate?.displayAddCommentScreen()
    }

    // MARK: Public Methods
    func configureViewWithRestaurant(restaurant: Restaurant, reloader: Reloader) {
        photoUrls = restaurant.photoUrls

        reloader.reload(imageCollectionView)

        let restaurantDetailPresenter = RestaurantDetailPresenter(restaurant: restaurant)
        self.nameLabel.text = restaurantDetailPresenter.name
        self.addressLabel.text = restaurantDetailPresenter.address
        self.cuisineTypeLabel.text = restaurantDetailPresenter.cuisineType
        self.offersEnglishMenuLabel.text = restaurantDetailPresenter.offersEnglishMenu
        self.walkInsOkLabel.text = restaurantDetailPresenter.walkInsOk
        self.acceptsCreditCardsLabel.text = restaurantDetailPresenter.creditCardsOk
        self.notesLabel.text = restaurantDetailPresenter.notes
        self.creationInfoLabel.text = restaurantDetailPresenter.creationInfo
    }

    //MARK: - Constraints
    func applyViewConstraints() {
        imageCollectionView.autoPinEdgeToSuperviewEdge(.Top)
        imageCollectionView.autoSetDimension(.Height, toSize: 120.0)
        imageCollectionView.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
        imageCollectionView.autoMatchDimension(.Width, toDimension:.Width, ofView: contentView)

        nameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageCollectionView)
        nameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        addressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        addressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressLabel)

        offersEnglishMenuLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        offersEnglishMenuLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)

        walkInsOkLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        walkInsOkLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: offersEnglishMenuLabel)

        acceptsCreditCardsLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        acceptsCreditCardsLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: walkInsOkLabel)

        notesLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        notesLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        notesLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: acceptsCreditCardsLabel)

        creationInfoLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        creationInfoLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesLabel)

        addCommentButton.autoPinEdge(.Leading, toEdge: .Leading, ofView: creationInfoLabel)
        addCommentButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: creationInfoLabel)

        addCommentButton.autoPinEdgeToSuperviewEdge(.Bottom)
    }

}

// MARK: - UICollectionViewDataSource
extension RestaurantDetailTableViewCell: UICollectionViewDataSource {
    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int
    {
        return photoUrls.count
    }

    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
        ) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath)

        let imageView = UIImageView()
        imageView.sd_setImageWithURL(photoUrls[indexPath.row])
        cell.backgroundView = imageView

        return cell
    }
}