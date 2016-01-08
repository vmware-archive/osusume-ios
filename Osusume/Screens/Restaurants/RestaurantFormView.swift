import UIKit

class RestaurantFormView : UIView {


    // MARK: - Initializers
    init() {
        super.init(frame: CGRect())
        self.addSubview(nameLabel)
        self.addSubview(nameTextField)
        self.addSubview(addressLabel)
        self.addSubview(addressTextField)
        self.addSubview(cuisineTypeLabel)
        self.addSubview(cuisineTypeTextField)

        self.backgroundColor = UIColor.greenColor()
        nameLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: self)
        nameLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        nameLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self)

        nameTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        nameTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
        nameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

        addressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        addressLabel.autoPinEdge(.Trailing, toEdge: .Leading, ofView: nameLabel)
        addressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameTextField)

        addressTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        addressTextField.autoPinEdge(.Trailing, toEdge: .Leading, ofView: nameLabel)
        addressTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressLabel)

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Trailing, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressTextField)

        cuisineTypeTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeTextField.autoPinEdge(.Trailing, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Elements

    let nameTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Restaurant Name"
        return label
    }()

    let addressTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let addressLabel : UILabel = {
        let label = UILabel()
        label.text = "Address"
        return label
    }()

    let cuisineTypeTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let cuisineTypeLabel : UILabel = {
        let label = UILabel()
        label.text = "Cuisine Type"
        return label
    }()
//
//    let dishNameTextField : UITextField = {
//        let textField = UITextField.newAutoLayoutView()
//        textField.borderStyle = .Line
//        return textField
//    }()
//
//    let dishNameLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Name of a Dish"
//        return label
//    }()
//
//    let addPhotoFromAlbumButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("Add Photo From Album", forState: .Normal)
//        return button
//    }()
//
//    let selectedImageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .ScaleAspectFit
//        return imageView
//    }()
//
//    let offersEnglishMenuLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Offers English Menu"
//        return label
//    }()
//
//    let offersEnglishMenuSwitch : UISwitch = {
//        let menuSwitch = UISwitch()
//        return menuSwitch
//    }()
//
//    let walkInsOkLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Walk-ins Ok"
//        return label
//    }()
//
//    let walkInsOkSwitch : UISwitch = {
//        return UISwitch()
//    }()
//
//    let acceptsCreditCardsLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Accepts Credit Cards"
//        return label
//    }()
//
//    let acceptsCreditCardsSwitch : UISwitch = {
//        return UISwitch()
//    }()
//
//    let saveTextLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Not Saved"
//        return label
//    }()
//
//    let saveButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("Save", forState: .Normal)
//        return button
//    }()
//
//    lazy var imagePicker : UIImagePickerController = {
//        let picker = UIImagePickerController()
//        picker.allowsEditing = false
//        picker.sourceType = .PhotoLibrary
//        return picker
//    }()
//


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
}
