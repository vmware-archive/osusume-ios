class FindRestaurantTableViewCell: UITableViewCell {
    // MARK: - Initializers
    init() {
        super.init(style: .Default, reuseIdentifier: String(FindRestaurantTableViewCell))
        textLabel!.text = "Find restaurant (Required)"
        accessoryType = .DisclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
