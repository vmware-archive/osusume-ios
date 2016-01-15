import UIKit

class RestaurantFormView : UIView {

    let restaurant: Restaurant? = nil

    // MARK: - Initializers
    init(restaurant: Restaurant?) {
        super.init(frame: CGRect())

        self.addSubview(nameLabel)
        self.addSubview(nameTextField)
        self.addSubview(addressLabel)
        self.addSubview(addressTextField)
        self.addSubview(cuisineTypeLabel)
        self.addSubview(cuisineTypeTextField)
        self.addSubview(offersEnglishMenuLabel)
        self.addSubview(offersEnglishMenuSwitch)
        self.addSubview(walkInsOkLabel)
        self.addSubview(walkInsOkSwitch)
        self.addSubview(acceptsCreditCardsLabel)
        self.addSubview(acceptsCreditCardsSwitch)
        self.addSubview(notesLabel)
        self.addSubview(notesTextField)

        if let thisRestaurant = restaurant {
            setRestaurantValues(thisRestaurant)
        }

        updateSubviewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRestaurantValues(restaurant: Restaurant) {
        nameTextField.text = restaurant.name
        addressTextField.text = restaurant.address
        cuisineTypeTextField.text = restaurant.cuisineType
        offersEnglishMenuSwitch.on = restaurant.offersEnglishMenu
        walkInsOkSwitch.on = restaurant.walkInsOk
        acceptsCreditCardsSwitch.on = restaurant.acceptsCreditCards
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
        cuisineTypeTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        cuisineTypeTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)

        offersEnglishMenuSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        offersEnglishMenuSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeTextField, withOffset: 8.0)
        offersEnglishMenuLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
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
        notesTextField.autoSetDimension(.Height, toSize: 33.0)

        notesTextField.autoPinEdgeToSuperviewEdge(.Bottom)
    }


    // MARK: - View Elements

    let nameTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let nameLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Restaurant Name"
        return label
    }()

    let addressTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let addressLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Address"
        return label
    }()

    let cuisineTypeTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let cuisineTypeLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Cuisine Type"
        return label
    }()

    let offersEnglishMenuLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Offers English Menu"
        return label
    }()

    let offersEnglishMenuSwitch : UISwitch = {
        let menuSwitch = UISwitch.newAutoLayoutView()
        return menuSwitch
    }()

    let walkInsOkLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Walk-ins Ok"
        return label
    }()

    let walkInsOkSwitch : UISwitch = {
        return UISwitch.newAutoLayoutView()
    }()

    let acceptsCreditCardsLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Accepts Credit Cards"
        return label
    }()

    let acceptsCreditCardsSwitch : UISwitch = {
        return UISwitch.newAutoLayoutView()
    }()

    let notesLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Notes"
        return label
    }()

    let notesTextField : UITextView = {
        let textField = UITextView.newAutoLayoutView()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.darkGrayColor().CGColor
        return textField
    }()


    //MARK: - Getters

    func getNameText() -> String? {
        return nameTextField.text
    }

    func getAddressText() -> String? {
        return addressTextField.text
    }

    func getCuisineTypeText() -> String? {
        return cuisineTypeTextField.text
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
}
