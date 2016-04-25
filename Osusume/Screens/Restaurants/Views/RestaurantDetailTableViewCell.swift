protocol RestaurantDetailTableViewCellDelegate: NSObjectProtocol {
    func displayAddCommentScreen()
    func didTapLikeButton(sender: UIButton)
}

class RestaurantDetailTableViewCell: UITableViewCell {

    weak var delegate: RestaurantDetailTableViewCellDelegate?
    weak var router: Router?

    var imageCollectionView: UICollectionView
    let nameLabel: UILabel
    let addressLabel: UILabel
    let cuisineTypeLabel: UILabel
    let numberOfLikesLabel: UILabel
    let offersEnglishMenuLabel: UILabel
    let walkInsOkLabel: UILabel
    let acceptsCreditCardsLabel: UILabel
    let notesLabel: UILabel
    let creationInfoLabel: UILabel
    let likeButton: UIButton
    let priceRangeLabel: UILabel
    let addCommentButton: UIButton
    var photoUrls: [NSURL]

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        nameLabel = UILabel.newAutoLayoutView()
        addressLabel = UILabel.newAutoLayoutView()
        cuisineTypeLabel = UILabel.newAutoLayoutView()
        numberOfLikesLabel = UILabel.newAutoLayoutView()
        offersEnglishMenuLabel = UILabel.newAutoLayoutView()
        walkInsOkLabel = UILabel.newAutoLayoutView()
        acceptsCreditCardsLabel = UILabel.newAutoLayoutView()
        notesLabel = UILabel.newAutoLayoutView()
        creationInfoLabel = UILabel.newAutoLayoutView()
        likeButton = UIButton.newAutoLayoutView()
        priceRangeLabel = UILabel.newAutoLayoutView()
        addCommentButton = UIButton.newAutoLayoutView()
        photoUrls = [NSURL]()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(100, 100)
        layout.scrollDirection = .Horizontal
        imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        imageCollectionView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        imageCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        imageCollectionView.backgroundColor = UIColor.lightGrayColor()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(imageCollectionView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(cuisineTypeLabel)
        contentView.addSubview(numberOfLikesLabel)
        contentView.addSubview(offersEnglishMenuLabel)
        contentView.addSubview(walkInsOkLabel)
        contentView.addSubview(acceptsCreditCardsLabel)
        contentView.addSubview(notesLabel)
        contentView.addSubview(creationInfoLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(priceRangeLabel)
        contentView.addSubview(addCommentButton)

        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self

        notesLabel.numberOfLines = 0
        addCommentButton.addTarget(
            self,
            action: "didTapAddNewCommentButton",
            forControlEvents: .TouchUpInside
        )
        addCommentButton.setTitle("Add comment", forState: .Normal)
        addCommentButton.backgroundColor = UIColor.grayColor()

        likeButton.addTarget(
            self.delegate,
            action: "didTapLikeButton:",
            forControlEvents: .TouchUpInside
        )
        likeButton.setTitle("Like", forState: .Normal)

        applyViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    func didTapAddNewCommentButton() {
        delegate?.displayAddCommentScreen()
    }

    // MARK: Public Methods
    func configureView(restaurant: Restaurant, reloader: Reloader, router: Router) {
        photoUrls = restaurant.photoUrls

        reloader.reload(imageCollectionView)

        self.router = router

        let restaurantDetailPresenter = RestaurantDetailPresenter(restaurant: restaurant)
        self.nameLabel.text = restaurantDetailPresenter.name
        self.addressLabel.text = restaurantDetailPresenter.address
        self.cuisineTypeLabel.text = restaurantDetailPresenter.cuisineType
        self.numberOfLikesLabel.text = restaurantDetailPresenter.numberOfLikes
        self.offersEnglishMenuLabel.text = restaurantDetailPresenter.offersEnglishMenu
        self.walkInsOkLabel.text = restaurantDetailPresenter.walkInsOk
        self.acceptsCreditCardsLabel.text = restaurantDetailPresenter.creditCardsOk
        self.notesLabel.text = restaurantDetailPresenter.notes
        self.creationInfoLabel.text = restaurantDetailPresenter.creationInfo
        self.priceRangeLabel.text = restaurantDetailPresenter.priceRange

        if restaurant.liked {
            likeButton.backgroundColor = UIColor.redColor()
            likeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            likeButton.backgroundColor = UIColor.blueColor()
            likeButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        }
    }

    // MARK: - Constraints
    func applyViewConstraints() {
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

}
// MARK: - UICollectionViewDelegate
extension RestaurantDetailTableViewCell: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.router?.showImageScreen(photoUrls[indexPath.row])
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