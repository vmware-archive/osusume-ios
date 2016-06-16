class NewRestaurantFormView: UIView {
    // MARK: - Properties
    private(set) var selectedPriceRange: PriceRange = PriceRange(id: 0, range: "Not Specified")
    var delegate: NewRestaurantViewControllerPresenterProtocol?

    // MARK: - View Elements
    let priceRangeHeaderLabel: UILabel
    let priceRangeValueLabel: UILabel
    let priceRangeButton: UIButton

    let offersEnglishMenuHeaderLabel: UILabel
    let offersEnglishMenuSwitch: UISwitch

    let walkInsOkHeaderLabel: UILabel
    let walkInsOkSwitch: UISwitch

    let acceptsCreditCardsHeaderLabel: UILabel
    let acceptsCreditCardsSwitch: UISwitch

    let notesHeaderLabel: UILabel
    let notesTextField: UITextView

    // MARK: - Initializers
    init() {
        priceRangeHeaderLabel = UILabel.newAutoLayoutView()
        priceRangeValueLabel = UILabel.newAutoLayoutView()
        priceRangeButton = UIButton(type: .System)

        offersEnglishMenuHeaderLabel = UILabel.newAutoLayoutView()
        offersEnglishMenuSwitch = UISwitch.newAutoLayoutView()

        walkInsOkHeaderLabel = UILabel.newAutoLayoutView()
        walkInsOkSwitch = UISwitch.newAutoLayoutView()

        acceptsCreditCardsHeaderLabel = UILabel.newAutoLayoutView()
        acceptsCreditCardsSwitch = UISwitch.newAutoLayoutView()

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
        self.addSubview(priceRangeHeaderLabel)
        self.addSubview(priceRangeValueLabel)
        self.addSubview(priceRangeButton)

        self.addSubview(offersEnglishMenuHeaderLabel)
        self.addSubview(offersEnglishMenuSwitch)

        self.addSubview(walkInsOkHeaderLabel)
        self.addSubview(walkInsOkSwitch)

        self.addSubview(acceptsCreditCardsHeaderLabel)
        self.addSubview(acceptsCreditCardsSwitch)

        self.addSubview(notesHeaderLabel)
        self.addSubview(notesTextField)
    }

    private func configureSubviews() {
        priceRangeHeaderLabel.text = "Price Range"
        priceRangeButton.translatesAutoresizingMaskIntoConstraints = false
        priceRangeButton.setTitle("Price Range", forState: .Normal)
        priceRangeButton.setTitleColor(priceRangeButton.tintColor, forState: .Normal)
        priceRangeButton.backgroundColor = UIColor.clearColor()
        priceRangeButton.addTarget(
            self,
            action: #selector(NewRestaurantFormView.didTapPriceRangeButton(_:)),
            forControlEvents: .TouchUpInside
        )

        offersEnglishMenuHeaderLabel.text = "Offers English Menu"
        walkInsOkHeaderLabel.text = "Walk-ins Ok"
        acceptsCreditCardsHeaderLabel.text = "Accepts Credit Cards"

        notesHeaderLabel.text = "Notes"
        notesTextField.layer.borderWidth = 1.0
        notesTextField.layer.borderColor = UIColor.darkGrayColor().CGColor
    }

    private func addConstraints() {
        priceRangeHeaderLabel.autoPinEdgesToSuperviewEdgesWithInsets(
            UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0),
            excludingEdge: .Bottom
        )
        priceRangeValueLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: priceRangeHeaderLabel)
        priceRangeValueLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: priceRangeHeaderLabel)
        priceRangeValueLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeHeaderLabel)
        priceRangeValueLabel.autoSetDimension(.Height, toSize: 25.0)

        priceRangeButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeValueLabel)
        priceRangeButton.autoAlignAxisToSuperviewAxis(.Vertical)

        offersEnglishMenuHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: priceRangeHeaderLabel)
        offersEnglishMenuHeaderLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: offersEnglishMenuSwitch)
        offersEnglishMenuSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeButton, withOffset: 8.0)
        offersEnglishMenuSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: priceRangeHeaderLabel)

        walkInsOkHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: priceRangeHeaderLabel)
        walkInsOkHeaderLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: walkInsOkSwitch)
        walkInsOkSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: priceRangeHeaderLabel)
        walkInsOkSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: offersEnglishMenuSwitch, withOffset: 8.0)

        acceptsCreditCardsHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: priceRangeHeaderLabel)
        acceptsCreditCardsHeaderLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: acceptsCreditCardsSwitch)
        acceptsCreditCardsSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: priceRangeHeaderLabel)
        acceptsCreditCardsSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: walkInsOkSwitch, withOffset: 8.0)

        notesHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: priceRangeHeaderLabel)
        notesHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: priceRangeHeaderLabel)
        notesHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: acceptsCreditCardsSwitch)

        notesTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: priceRangeHeaderLabel)
        notesTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: priceRangeHeaderLabel)
        notesTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesHeaderLabel)
        notesTextField.autoSetDimension(.Height, toSize: 66.0)
        notesTextField.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Getters
    func getOffersEnglishMenuState() -> Bool? {
        return offersEnglishMenuSwitch.on
    }

    func getWalkInsOkState() -> Bool? {
        return walkInsOkSwitch.on
    }

    func getAcceptsCreditCardsState() -> Bool? {
        return acceptsCreditCardsSwitch.on
    }

    func getNotesText() -> String? {
        return notesTextField.text
    }

    // MARK: - Actions
    @objc private func didTapFindCuisineButton(sender: UIButton) {
        delegate?.showFindCuisineScreen()
    }

    @objc private func didTapPriceRangeButton(sender: UIButton) {
        delegate?.showPriceRangeScreen()
    }
}

// MARK: - PriceRangeSelectionDelegate
extension NewRestaurantFormView: PriceRangeSelectionDelegate {
    func priceRangeSelected(priceRange: PriceRange) {
        priceRangeValueLabel.text = priceRange.range
        self.selectedPriceRange = priceRange
    }
}
