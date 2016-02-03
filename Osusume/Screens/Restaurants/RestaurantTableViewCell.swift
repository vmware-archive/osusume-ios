import UIKit

class RestaurantTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let cuisineTypeLabel = UILabel()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(nameLabel)
        contentView.addSubview(cuisineTypeLabel)

        nameLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        nameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}