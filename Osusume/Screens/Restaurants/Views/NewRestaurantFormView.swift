class NewRestaurantFormView: UIView {
    // MARK: - Properties
    private(set) var selectedPriceRange: PriceRange = PriceRange(id: 0, range: "Not Specified")
    var delegate: RestaurantViewControllerPresenterProtocol?

    // MARK: - View Elements
    let notesHeaderLabel: UILabel
    let notesTextField: UITextView

    // MARK: - Initializers
    init() {
        notesHeaderLabel = UILabel.newAutoLayoutView()
        notesTextField = UITextView.newAutoLayoutView()

        super.init(frame: CGRect())

        addSubviews()
        configureSubviews()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup
    private func addSubviews() {
        self.addSubview(notesHeaderLabel)
        self.addSubview(notesTextField)
    }

    private func configureSubviews() {
        notesHeaderLabel.text = "Notes"
        notesTextField.layer.borderWidth = 1.0
        notesTextField.layer.borderColor = UIColor.darkGrayColor().CGColor
    }

    private func addConstraints() {
        notesHeaderLabel.autoPinEdgesToSuperviewEdgesWithInsets(
            UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0),
            excludingEdge: .Bottom
        )

        notesTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesHeaderLabel)
        notesTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: notesHeaderLabel)
        notesTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: notesHeaderLabel)
        notesTextField.autoSetDimension(.Height, toSize: 66.0)
        notesTextField.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Getters
    func getNotesText() -> String? {
        return notesTextField.text
    }
}
