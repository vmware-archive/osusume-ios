import UIKit

class RestaurantTableViewCell: UITableViewCell {
    // MARK: - View Elements
    let photoImageView: UIImageView
    private let textContentView: UIView
    private let nameLabel: UILabel
    private let cuisineTypeLabel: UILabel
    private let authorLabel: UILabel
    private let createdAtLabel: UILabel

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        photoImageView = UIImageView()
        textContentView = UIView.newAutoLayoutView()
        nameLabel = UILabel()
        cuisineTypeLabel = UILabel()
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
        textContentView.addSubview(authorLabel)
        textContentView.addSubview(createdAtLabel)
    }

    private func configureSubviews() {}

    private func addConstraints() {
        photoImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        photoImageView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        photoImageView.autoConstrainAttribute(.Width, toAttribute: .Height, ofView: self, withOffset: -20.0)
        photoImageView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)

        textContentView.autoPinEdgeToSuperviewEdge(.Top)
        textContentView.autoPinEdge(.Leading, toEdge: .Trailing, ofView: photoImageView)
        textContentView.autoPinEdgeToSuperviewEdge(.Trailing)
        textContentView.autoPinEdgeToSuperviewEdge(.Bottom)

        nameLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        nameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        nameLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

        authorLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        authorLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)

        createdAtLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        createdAtLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: authorLabel)
        createdAtLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
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
        authorLabel.text = presenter.author
        createdAtLabel.text = presenter.creationDate
    }
}
