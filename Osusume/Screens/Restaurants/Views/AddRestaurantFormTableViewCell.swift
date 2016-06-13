class AddRestaurantFormTableViewCell: UITableViewCell {
    // MARK: - Properties

    // MARK: - View Elements
    let formView: NewRestaurantFormView

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        formView = NewRestaurantFormView()

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
        contentView.addSubview(formView)
    }

    private func configureSubviews() {
    }

    private func addConstraints() {
        formView.autoPinEdgesToSuperviewEdgesWithInsets(
            UIEdgeInsetsMake(0.0, 10.0, 10.0, 10.0)
        )
    }

    // MARK: - Public Methods
    func configureCell(parentViewController: NewRestaurantViewController) {
        formView.delegate = parentViewController
    }
}
