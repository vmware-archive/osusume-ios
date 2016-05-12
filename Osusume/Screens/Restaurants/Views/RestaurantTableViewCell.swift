class RestaurantTableViewCell: UITableViewCell {
    // MARK: - View Elements
    let photoImageView: UIImageView
    let textContentView: UIView
    let nameLabel: UILabel
    let cuisineTypeLabel: UILabel
    let priceRangeLabel: UILabel
    let numberOfLikesLabel: UILabel
    let authorLabel: UILabel
    let createdAtLabel: UILabel

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        photoImageView = UIImageView()
        textContentView = UIView.newAutoLayoutView()
        nameLabel = UILabel()
        cuisineTypeLabel = UILabel()
        priceRangeLabel = UILabel()
        numberOfLikesLabel = UILabel()
        authorLabel = UILabel()
        createdAtLabel = UILabel()

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
        contentView.addSubview(photoImageView)
        contentView.addSubview(textContentView)
        textContentView.addSubview(nameLabel)
        textContentView.addSubview(cuisineTypeLabel)
        textContentView.addSubview(priceRangeLabel)
        textContentView.addSubview(numberOfLikesLabel)
        textContentView.addSubview(authorLabel)
        textContentView.addSubview(createdAtLabel)
    }

    private func configureSubviews() {}

    private func addConstraints() {
        photoImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        photoImageView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        photoImageView.autoConstrainAttribute(
            .Width,
            toAttribute: .Height,
            ofView: self,
            withOffset: -20.0
        )
        photoImageView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)

        textContentView.autoPinEdge(.Top, toEdge: .Top, ofView: photoImageView)
        textContentView.autoPinEdge(.Leading, toEdge: .Trailing, ofView: photoImageView)
        textContentView.autoPinEdgeToSuperviewEdge(.Trailing)
        textContentView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: photoImageView)

        nameLabel.autoPinEdge(.Top, toEdge: .Top, ofView: textContentView)
        nameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        nameLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

        priceRangeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        priceRangeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)

        numberOfLikesLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        numberOfLikesLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeLabel)

        authorLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        authorLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: numberOfLikesLabel)

        createdAtLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        createdAtLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: authorLabel)
    }

    func configureView(
        photoRepo: PhotoRepo,
        presenter: RestaurantDetailPresenter)
    {
        photoImageView.image = UIImage(named: "TableCellPlaceholder")
        photoRepo.loadImageFromUrl(presenter.photoUrl)
            .onSuccess { image in
                self.photoImageView.image = image
        }

        nameLabel.text = presenter.name
        cuisineTypeLabel.text = presenter.cuisineType
        priceRangeLabel.text = presenter.priceRange
        numberOfLikesLabel.text = presenter.numberOfLikes
        authorLabel.text = presenter.author
        createdAtLabel.text = presenter.creationDate
    }
}
