class PopulatedRestaurantTableViewCell: UITableViewCell {
    // MARK: - Initializers
    init() {
        super.init(style: .Subtitle, reuseIdentifier: String(PopulatedRestaurantTableViewCell))
        accessoryType = .DisclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
