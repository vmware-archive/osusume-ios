import UIKit

class NewRestaurantFormView: UIView {
    var delegate: FindCuisineScreenPresenterProtocol?
    var cuisine: Cuisine = Cuisine(id: 0, name: "Not Specified")

    // MARK: - View Elements

    let nameTextField: UITextField
    let nameLabel: UILabel
    let addressTextField: UITextField
    let addressLabel: UILabel
    let cuisineTypeValueLabel: UILabel
    let cuisineTypeLabel: UILabel
    let offersEnglishMenuLabel: UILabel
    let offersEnglishMenuSwitch: UISwitch
    let walkInsOkLabel: UILabel
    let walkInsOkSwitch: UISwitch
    let acceptsCreditCardsLabel: UILabel
    let acceptsCreditCardsSwitch: UISwitch
    let notesLabel: UILabel
    let notesTextField: UITextView
    let findCuisineButton: UIButton

    // MARK: - Initializers
    init() {
        nameTextField = UITextField.newAutoLayoutView()
        nameTextField.borderStyle = .Line

        nameLabel = UILabel.newAutoLayoutView()
        nameLabel.text = "Restaurant Name"

        addressTextField = UITextField.newAutoLayoutView()
        addressTextField.borderStyle = .Line

        addressLabel = UILabel.newAutoLayoutView()
        addressLabel.text = "Address"

        cuisineTypeValueLabel = UILabel.newAutoLayoutView()

        cuisineTypeLabel = UILabel.newAutoLayoutView()
        cuisineTypeLabel.text = "Cuisine Type"

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

        findCuisineButton = UIButton.newAutoLayoutView()
        findCuisineButton.setTitle("Find Cuisine", forState: .Normal)
        findCuisineButton.setTitleColor(findCuisineButton.tintColor, forState: .Normal)
        findCuisineButton.backgroundColor = UIColor.clearColor()

        super.init(frame: CGRect())

        self.addSubview(nameLabel)
        self.addSubview(nameTextField)
        self.addSubview(addressLabel)
        self.addSubview(addressTextField)
        self.addSubview(cuisineTypeLabel)
        self.addSubview(cuisineTypeValueLabel)
        self.addSubview(findCuisineButton)
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

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressTextField)
        cuisineTypeValueLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeValueLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        cuisineTypeValueLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)
        cuisineTypeValueLabel.autoSetDimension(.Height, toSize: 25.0)

        findCuisineButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeValueLabel)
        findCuisineButton.autoAlignAxisToSuperviewAxis(.Vertical)

        offersEnglishMenuSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: findCuisineButton, withOffset: 8.0)
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
}

extension NewRestaurantFormView: CuisineSelectionProtocol {
    func cuisineSelected(cuisine: Cuisine) {
        cuisineTypeValueLabel.text = cuisine.name
        self.cuisine = cuisine
    }
}
