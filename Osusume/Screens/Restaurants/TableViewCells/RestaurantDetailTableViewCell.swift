class RestaurantDetailTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var router: Router?
    weak var delegate: RestaurantDetailTableViewCellDelegate?

    // MARK: - View Elements
    let nameLabel: UILabel
    let addressLabel: UILabel
    let viewMapButton: UIButton
    let cuisineTypeLabel: UILabel
    let priceRangeLabel: UILabel
    let nearestStationLabel: UILabel
    let numberOfLikesLabel: UILabel
    let notesLabel: UILabel
    let creationInfoLabel: UILabel
    let likeButton: UIButton
    let addCommentButton: UIButton

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        nameLabel = UILabel.newAutoLayoutView()
        addressLabel = UILabel.newAutoLayoutView()
        viewMapButton = UIButton(type: UIButtonType.System)
        cuisineTypeLabel = UILabel.newAutoLayoutView()
        priceRangeLabel = UILabel.newAutoLayoutView()
        nearestStationLabel = UILabel.newAutoLayoutView()
        numberOfLikesLabel = UILabel.newAutoLayoutView()
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(viewMapButton)
        contentView.addSubview(cuisineTypeLabel)
        contentView.addSubview(priceRangeLabel)
        contentView.addSubview(nearestStationLabel)
        contentView.addSubview(numberOfLikesLabel)
        contentView.addSubview(notesLabel)
        contentView.addSubview(creationInfoLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(addCommentButton)
    }

    private func configureSubviews() {
        viewMapButton.setTitle("view in map", forState: .Normal)

        notesLabel.numberOfLines = 0

        likeButton.setTitle("Like", forState: .Normal)

        addCommentButton.setTitle("Add comment", forState: .Normal)
        addCommentButton.backgroundColor = UIColor.grayColor()
    }

    private func addConstraints() {
        nameLabel.autoPinEdgeToSuperviewEdge(.Top)
        nameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        addressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        addressLabel.autoPinEdge(.Trailing, toEdge: .Leading, ofView: viewMapButton)
        addressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)
        viewMapButton.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        viewMapButton.autoSetDimension(.Width, toSize: 100.0)
        viewMapButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

        priceRangeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        priceRangeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressLabel)

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeLabel)

        numberOfLikesLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        numberOfLikesLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)

        nearestStationLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        nearestStationLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: numberOfLikesLabel)

        notesLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        notesLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        notesLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nearestStationLabel)

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

    // MARK: - Public Methods
    func configureView(restaurant: Restaurant, reloader: Reloader, router: Router) {
        self.router = router
        viewMapButton.addTarget(
            self.delegate,
            action: #selector(RestaurantDetailTableViewCellDelegate.displayMapScreen(_:)),
            forControlEvents: .TouchUpInside
        )

        likeButton.addTarget(
            self.delegate,
            action: #selector(RestaurantDetailTableViewCellDelegate.didTapLikeButton(_:)),
            forControlEvents: .TouchUpInside
        )

        addCommentButton.addTarget(
            self.delegate,
            action: #selector(RestaurantDetailTableViewCellDelegate.displayAddCommentScreen(_:)),
            forControlEvents: .TouchUpInside
        )

        let restaurantDetailPresenter = RestaurantDetailPresenter(restaurant: restaurant)
        nameLabel.text = restaurantDetailPresenter.name
        addressLabel.text = restaurantDetailPresenter.address
        cuisineTypeLabel.text = restaurantDetailPresenter.cuisineType
        numberOfLikesLabel.text = restaurantDetailPresenter.numberOfLikes
        nearestStationLabel.text = restaurantDetailPresenter.nearestStation
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
}