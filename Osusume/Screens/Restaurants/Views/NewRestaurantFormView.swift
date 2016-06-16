class NewRestaurantFormView: UIView {
    // MARK: - Properties
    private(set) var selectedPriceRange: PriceRange = PriceRange(id: 0, range: "Not Specified")
    var delegate: NewRestaurantViewControllerPresenterProtocol?

    // MARK: - View Elements
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
        offersEnglishMenuHeaderLabel.text = "Offers English Menu"
        walkInsOkHeaderLabel.text = "Walk-ins Ok"
        acceptsCreditCardsHeaderLabel.text = "Accepts Credit Cards"

        notesHeaderLabel.text = "Notes"
        notesTextField.layer.borderWidth = 1.0
        notesTextField.layer.borderColor = UIColor.darkGrayColor().CGColor
    }

    private func addConstraints() {
        offersEnglishMenuHeaderLabel.autoPinEdgesToSuperviewEdgesWithInsets(
            UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0),
            excludingEdge: .Bottom
        )
        offersEnglishMenuSwitch.autoPinEdge(.Top, toEdge: .Top, ofView: offersEnglishMenuHeaderLabel, withOffset: 0.0)
        offersEnglishMenuSwitch.autoPinEdgeToSuperviewEdge(.Right)

        walkInsOkHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: offersEnglishMenuHeaderLabel)
        walkInsOkHeaderLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: walkInsOkSwitch)
        walkInsOkSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: offersEnglishMenuSwitch, withOffset: 8.0)
        walkInsOkSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: offersEnglishMenuSwitch)

        acceptsCreditCardsHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: offersEnglishMenuHeaderLabel)
        acceptsCreditCardsHeaderLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: acceptsCreditCardsSwitch)
        acceptsCreditCardsSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: walkInsOkSwitch, withOffset: 8.0)
        acceptsCreditCardsSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: offersEnglishMenuSwitch)

        notesHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: acceptsCreditCardsSwitch, withOffset: 8.0)
        notesHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: offersEnglishMenuHeaderLabel)
        notesHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: offersEnglishMenuSwitch)

        notesTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesHeaderLabel)
        notesTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: offersEnglishMenuHeaderLabel)
        notesTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: offersEnglishMenuSwitch)
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
}
