import UIKit

class NewRestaurantFormView: UIView {
    var delegate: NewRestaurantViewControllerPresenterProtocol?
    var cuisine: Cuisine = Cuisine(id: 0, name: "Not Specified")

    // MARK: - View Elements

    let nameLabel: UILabel
    let nameTextField: UITextField

    let addressLabel: UILabel
    let addressTextField: UITextField

    let cuisineTypeHeaderLabel: UILabel
    let cuisineTypeValueLabel: UILabel
    let findCuisineButton: UIButton

    let priceRangeHeaderLabel: UILabel
    let priceRangeValueLabel: UILabel
    let priceRangeButton: UIButton

    let offersEnglishMenuLabel: UILabel
    let offersEnglishMenuSwitch: UISwitch
    let walkInsOkLabel: UILabel
    let walkInsOkSwitch: UISwitch
    let acceptsCreditCardsLabel: UILabel
    let acceptsCreditCardsSwitch: UISwitch
    let notesLabel: UILabel
    let notesTextField: UITextView

    // MARK: - Initializers
    init() {
        nameLabel = UILabel.newAutoLayoutView()
        nameLabel.text = "Restaurant Name"

        nameTextField = UITextField.newAutoLayoutView()
        nameTextField.borderStyle = .Line

        addressLabel = UILabel.newAutoLayoutView()
        addressLabel.text = "Address"

        addressTextField = UITextField.newAutoLayoutView()
        addressTextField.borderStyle = .Line

        cuisineTypeHeaderLabel = UILabel.newAutoLayoutView()
        cuisineTypeHeaderLabel.text = "Cuisine Type"

        cuisineTypeValueLabel = UILabel.newAutoLayoutView()

        findCuisineButton = UIButton(type: .System)
        findCuisineButton.translatesAutoresizingMaskIntoConstraints = false
        findCuisineButton.setTitle("Find Cuisine", forState: .Normal)
        findCuisineButton.setTitleColor(findCuisineButton.tintColor, forState: .Normal)
        findCuisineButton.backgroundColor = UIColor.clearColor()

        priceRangeHeaderLabel = UILabel.newAutoLayoutView()
        priceRangeHeaderLabel.text = "Price Range"

        priceRangeValueLabel = UILabel.newAutoLayoutView()

        priceRangeButton = UIButton(type: .System)
        priceRangeButton.translatesAutoresizingMaskIntoConstraints = false
        priceRangeButton.setTitle("Price Range", forState: .Normal)
        priceRangeButton.setTitleColor(priceRangeButton.tintColor, forState: .Normal)
        priceRangeButton.backgroundColor = UIColor.clearColor()

        offersEnglishMenuLabel = UILabel.newAutoLayoutView()
        offersEnglishMenuLabel.text = "Offers English Menu"

        offersEnglishMenuSwitch = UISwitch.newAutoLayoutView()

        walkInsOkLabel = UILabel.newAutoLayoutView()
        walkInsOkLabel.text = "Walk-ins Ok"

        walkInsOkSwitch = UISwitch.newAutoLayoutView()

        acceptsCreditCardsLabel = UILabel.newAutoLayoutView()
        acceptsCreditCardsLabel.text = "Accepts Credit Cards"

        acceptsCreditCardsSwitch = UISwitch.newAutoLayoutView()

        notesLabel = UILabel.newAutoLayoutView()
        notesLabel.text = "Notes"

        notesTextField = UITextView.newAutoLayoutView()
        notesTextField.layer.borderWidth = 1.0
        notesTextField.layer.borderColor = UIColor.darkGrayColor().CGColor

        super.init(frame: CGRect())

        self.addSubview(nameLabel)
        self.addSubview(nameTextField)
        self.addSubview(addressLabel)
        self.addSubview(addressTextField)

        self.addSubview(cuisineTypeHeaderLabel)
        self.addSubview(cuisineTypeValueLabel)
        self.addSubview(findCuisineButton)

        self.addSubview(priceRangeHeaderLabel)
        self.addSubview(priceRangeValueLabel)
        self.addSubview(priceRangeButton)

        self.addSubview(offersEnglishMenuLabel)
        self.addSubview(offersEnglishMenuSwitch)
        self.addSubview(walkInsOkLabel)
        self.addSubview(walkInsOkSwitch)
        self.addSubview(acceptsCreditCardsLabel)
        self.addSubview(acceptsCreditCardsSwitch)

        self.addSubview(notesLabel)
        self.addSubview(notesTextField)

        findCuisineButton.addTarget(
            self,
            action: Selector("didTapFindCuisineButton:"),
            forControlEvents: .TouchUpInside
        )

        priceRangeButton.addTarget(
            self,
            action: Selector("didTapPriceRangeButton:"),
            forControlEvents: .TouchUpInside
        )

        updateSubviewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints

    func updateSubviewConstraints() {
        nameLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: self)
        nameLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        nameLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self)
        nameTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        nameTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        nameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

        addressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        addressLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        addressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameTextField)
        addressTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        addressTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        addressTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressLabel)

        cuisineTypeHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        cuisineTypeHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressTextField)
        cuisineTypeValueLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeValueLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        cuisineTypeValueLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeHeaderLabel)
        cuisineTypeValueLabel.autoSetDimension(.Height, toSize: 25.0)

        findCuisineButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeValueLabel)
        findCuisineButton.autoAlignAxisToSuperviewAxis(.Vertical)

        priceRangeHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        priceRangeHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        priceRangeHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: findCuisineButton)
        priceRangeValueLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        priceRangeValueLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        priceRangeValueLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeHeaderLabel)
        priceRangeValueLabel.autoSetDimension(.Height, toSize: 25.0)

        priceRangeButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeValueLabel)
        priceRangeButton.autoAlignAxisToSuperviewAxis(.Vertical)

        offersEnglishMenuSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceRangeButton, withOffset: 8.0)
        offersEnglishMenuLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        offersEnglishMenuSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        offersEnglishMenuLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: offersEnglishMenuSwitch)

        walkInsOkSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        walkInsOkSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: offersEnglishMenuSwitch, withOffset: 8.0)
        walkInsOkLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        walkInsOkLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: walkInsOkSwitch)

        acceptsCreditCardsSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        acceptsCreditCardsSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: walkInsOkSwitch, withOffset: 8.0)
        acceptsCreditCardsLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        acceptsCreditCardsLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: acceptsCreditCardsSwitch)

        notesLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        notesLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        notesLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: acceptsCreditCardsSwitch)

        notesTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        notesTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        notesTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesLabel)
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

    // MARK: Actions
    func didTapFindCuisineButton(sender: UIButton) {
        delegate?.showFindCuisineScreen()
    }

    func didTapPriceRangeButton(sender: UIButton) {
        delegate?.showPriceRangeScreen()
    }
}

extension NewRestaurantFormView: CuisineSelectionDelegate {
    func cuisineSelected(cuisine: Cuisine) {
        cuisineTypeValueLabel.text = cuisine.name
        self.cuisine = cuisine
    }
}

extension NewRestaurantFormView: PriceRangeSelectionDelegate {
    func priceRangeSelected(priceRange: String) {
        priceRangeValueLabel.text = priceRange
    }
}
