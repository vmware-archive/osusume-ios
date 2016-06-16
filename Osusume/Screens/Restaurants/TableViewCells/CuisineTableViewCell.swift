class CuisineTableViewCell: UITableViewCell {
    // MARK: - Initializers
    init() {
        super.init(style: .Default, reuseIdentifier: String(CuisineTableViewCell))
        textLabel!.text = "Select cuisine (Required)"
        accessoryType = .DisclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
