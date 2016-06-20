class EditRestaurantFormView: UIView {
    // MARK: - View Elements
    let nameHeaderLabel: UILabel
    let nameTextField: UITextField

    let addressHeaderLabel: UILabel
    let addressTextField: UITextField

    let cuisineHeaderLabel: UILabel
    let cuisineValueLabel: UILabel

    let notesHeaderLabel: UILabel
    let notesTextView: UITextView

    // MARK: - Initializers
    init(restaurant: Restaurant) {
        nameHeaderLabel = UILabel.newAutoLayoutView()
        nameTextField = UITextField.newAutoLayoutView()
        addressHeaderLabel = UILabel.newAutoLayoutView()
        addressTextField = UITextField.newAutoLayoutView()
        cuisineHeaderLabel = UILabel.newAutoLayoutView()
        cuisineValueLabel = UILabel.newAutoLayoutView()
        notesHeaderLabel = UILabel.newAutoLayoutView()
        notesTextView = UITextView.newAutoLayoutView()

        super.init(frame: CGRect())

        addSubviews()
        configureSubviews()
        addConstraints()

        updateUIWithRestaurant(restaurant)
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
        self.addSubview(cuisineHeaderLabel)
        self.addSubview(cuisineValueLabel)
        self.addSubview(notesHeaderLabel)
        self.addSubview(notesTextView)
    }

    private func configureSubviews() {
        nameHeaderLabel.text = "Restaurant Name"
        nameTextField.borderStyle = .Line
        addressHeaderLabel.text = "Address"
        addressTextField.borderStyle = .Line
        cuisineHeaderLabel.text = "Cuisine Type"
        notesHeaderLabel.text = "Notes"
        notesTextView.layer.borderWidth = 1.0
        notesTextView.layer.borderColor = UIColor.darkGrayColor().CGColor
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

        cuisineHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        cuisineHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        cuisineHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressTextField)
        cuisineValueLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        cuisineValueLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        cuisineValueLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineHeaderLabel)
        cuisineValueLabel.autoSetDimension(.Height, toSize: 25.0)

        notesHeaderLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        notesHeaderLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        notesHeaderLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineValueLabel)

        notesTextView.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameHeaderLabel)
        notesTextView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameHeaderLabel)
        notesTextView.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesHeaderLabel)
        notesTextView.autoSetDimension(.Height, toSize: 66.0)

        notesTextView.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Getters
    func getNameText() -> String? {
        return nameTextField.text
    }

    func getAddressText() -> String? {
        return addressTextField.text
    }

    func getNotesText() -> String? {
        return notesTextView.text
    }

    // MARK: - Private Methods
    private func updateUIWithRestaurant(restaurant: Restaurant) {
        nameTextField.text = restaurant.name
        addressTextField.text = restaurant.address
        cuisineValueLabel.text = restaurant.cuisine.id == 0 ? "" : restaurant.cuisine.name
        notesTextView.text = restaurant.notes
    }
}

