import UIKit

class NewRestaurantFormView: UIView {
    // MARK: - Properties
    private(set) var selectedCuisine: Cuisine = Cuisine(id: 0, name: "Not Specified")
    private(set) var selectedPriceRange: PriceRange = PriceRange(id: 0, range: "Not Specified")
    var delegate: NewRestaurantViewControllerPresenterProtocol?

    // MARK: - View Elements
    let nameHeaderLabel: UILabel
    let nameTextField: UITextField

    let addressHeaderLabel: UILabel
    let addressTextField: UITextField

    let cuisineTypeHeaderLabel: UILabel
    let cuisineTypeValueLabel: UILabel
    let findCuisineButton: UIButton

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
        nameHeaderLabel = UILabel.newAutoLayoutView()
        nameTextField = UITextField.newAutoLayoutView()

        addressHeaderLabel = UILabel.newAutoLayoutView()
        addressTextField = UITextField.newAutoLayoutView()

        cuisineTypeHeaderLabel = UILabel.newAutoLayoutView()
        cuisineTypeValueLabel = UILabel.newAutoLayoutView()
        findCuisineButton = UIButton(type: .System)

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
        self.addSubview(nameHeaderLabel)
        self.addSubview(nameTextField)

        self.addSubview(addressHeaderLabel)
        self.addSubview(addressTextField)

        self.addSubview(cuisineTypeHeaderLabel)
        self.addSubview(cuisineTypeValueLabel)
        self.addSubview(findCuisineButton)

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
        nameHeaderLabel.text = "Restaurant Name"
        nameTextField.borderStyle = .Line

        addressHeaderLabel.text = "Address"
        addressTextField.borderStyle = .Line

        cuisineTypeHeaderLabel.text = "Cuisine Type"
        findCuisineButton.translatesAutoresizingMaskIntoConstraints = false
        findCuisineButton.setTitle("Find Cuisine", forState: .Normal)
        findCuisineButton.setTitleColor(findCuisineButton.tintColor, forState: .Normal)
        findCuisineButton.backgroundColor = UIColor.clearColor()
        findCuisineButton.addTarget(
            self,
            action: Selector("didTapFindCuisineButton:"),
            forControlEvents: .TouchUpInside
        )

        priceRangeHeaderLabel.text = "Price Range"
        priceRangeButton.translatesAutoresizingMaskIntoConstraints = false
        priceRangeButton.setTitle("Price Range", forState: .Normal)
        priceRangeButton.setTitleColor(priceRangeButton.tintColor, forState: .Normal)
        priceRangeButton.backgroundColor = UIColor.clearColor()
        priceRangeButton.addTarget(
            self,
            action: Selector("didTapPriceRangeButton:"),
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
        nameHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: self)
        nameHeaderLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        nameHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self)
        nameTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        nameTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        nameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameHeaderLabel)

        addressHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        addressHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        addressHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameTextField)
        addressTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        addressTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        addressTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressHeaderLabel)

        cuisineTypeHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        cuisineTypeHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        cuisineTypeHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressTextField)
        cuisineTypeValueLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        cuisineTypeValueLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        cuisineTypeValueLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeHeaderLabel)
        cuisineTypeValueLabel.autoSetDimension(.Height, toSize: 25.0)

        findCuisineButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeValueLabel)
        findCuisineButton.autoAlignAxisToSuperviewAxis(.Vertical)

        priceRangeHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        priceRangeHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        priceRangeHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: findCuisineButton)
        priceRangeValueLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        priceRangeValueLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        priceRangeValueLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeHeaderLabel)
        priceRangeValueLabel.autoSetDimension(.Height, toSize: 25.0)

        priceRangeButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeValueLabel)
        priceRangeButton.autoAlignAxisToSuperviewAxis(.Vertical)

        offersEnglishMenuHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        offersEnglishMenuHeaderLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: offersEnglishMenuSwitch)
        offersEnglishMenuSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeButton, withOffset: 8.0)
        offersEnglishMenuSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)

        walkInsOkHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        walkInsOkHeaderLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: walkInsOkSwitch)
        walkInsOkSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        walkInsOkSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: offersEnglishMenuSwitch, withOffset: 8.0)

        acceptsCreditCardsHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        acceptsCreditCardsHeaderLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: acceptsCreditCardsSwitch)
        acceptsCreditCardsSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        acceptsCreditCardsSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: walkInsOkSwitch, withOffset: 8.0)

        notesHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        notesHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        notesHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: acceptsCreditCardsSwitch)

        notesTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        notesTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        notesTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesHeaderLabel)
        notesTextField.autoSetDimension(.Height, toSize: 66.0)
        notesTextField.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Getters
    func getNameText() -> String? {
        return nameTextField.text
    }

    func getAddressText() -> String? {
        return addressTextField.text
    }

    func getCuisineTypeText() -> String? {
        return cuisineTypeValueLabel.text
    }

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

// MARK: - CuisineSelectionDelegate
extension NewRestaurantFormView: CuisineSelectionDelegate {
    func cuisineSelected(cuisine: Cuisine) {
        cuisineTypeValueLabel.text = cuisine.name
        self.selectedCuisine = cuisine
    }
}

// MARK: - PriceRangeSelectionDelegate
extension NewRestaurantFormView: PriceRangeSelectionDelegate {
    func priceRangeSelected(priceRange: PriceRange) {
        priceRangeValueLabel.text = priceRange.range
        self.selectedPriceRange = priceRange
    }
}
