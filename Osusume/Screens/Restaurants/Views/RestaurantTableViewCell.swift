import UIKit

class RestaurantTableViewCell: UITableViewCell {

    let photoImageView = UIImageView()
    let textContentView = UIView.newAutoLayoutView()
    let nameLabel = UILabel()
    let cuisineTypeLabel = UILabel()
    let authorLabel = UILabel()
    let createdAtLabel = UILabel()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(photoImageView)
        contentView.addSubview(textContentView)
        textContentView.addSubview(nameLabel)
        textContentView.addSubview(cuisineTypeLabel)
        textContentView.addSubview(authorLabel)
        textContentView.addSubview(createdAtLabel)

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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPresenter(presenter: RestaurantDetailPresenter) {
        photoImageView.sd_setImageWithURL(
            presenter.photoUrl,
            placeholderImage: UIImage(named: "TableCellPlaceholder")
        )
        nameLabel.text = presenter.name
        cuisineTypeLabel.text = presenter.cuisineType
        authorLabel.text = presenter.author
        createdAtLabel.text = presenter.creationDate
    }
}