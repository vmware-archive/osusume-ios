class NearestStationTableViewCell: UITableViewCell {
    // MARK: - Properties

    // MARK: - View Elements
    let titleLabel: UILabel
    let textField: UITextField

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel.newAutoLayoutView()
        textField = UITextField.newAutoLayoutView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .None

        addSubviews()
        configureSubviews()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
    }

    private func configureSubviews() {
        titleLabel.text = "Nearest Station"
        textField.placeholder = "e.g. Roppongi Station"
    }

    private func addConstraints() {
        titleLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Trailing)
        titleLabel.autoSetDimension(.Width, toSize: 150.0)
        textField.autoPinEdgesToSuperviewMarginsExcludingEdge(.Leading)
        textField.autoPinEdge(.Leading, toEdge: .Trailing, ofView: titleLabel)
    }
}
