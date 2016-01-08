import Foundation
import UIKit
import PureLayout
import BrightFutures

class NewRestaurantViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    unowned let router: Router
    let repo: Repo

    init(router: Router, repo: Repo) {
        self.router = router
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for NewRestaurantViewController")
    }

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

    let dishNameTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let dishNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name of a Dish"
        return label
    }()

    let backgroundImage : UIImageView = {
        let bgImage = UIImage(named: "Jeana")
        let imageView = UIImageView(image: bgImage)
        
        return imageView
    }()

    let addPhotoFromAlbumButton : UIButton = {
        let button = UIButton()
        button.setTitle("Add Photo From Album", forState: .Normal)
        return button
    }()

    let selectedImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()

    let offersEnglishMenuLabel : UILabel = {
        let label = UILabel()
        label.text = "Offers English Menu"
        return label
    }()

    let offersEnglishMenuSwitch : UISwitch = {
        let menuSwitch = UISwitch()
        return menuSwitch
    }()

    let walkInsOkLabel : UILabel = {
        let label = UILabel()
        label.text = "Walk-ins Ok"
        return label
    }()

    let walkInsOkSwitch : UISwitch = {
        return UISwitch()
    }()

    let acceptsCreditCardsLabel : UILabel = {
        let label = UILabel()
        label.text = "Accepts Credit Cards"
        return label
    }()

    let acceptsCreditCardsSwitch : UISwitch = {
        return UISwitch()
    }()

    let saveTextLabel : UILabel = {
        let label = UILabel()
        label.text = "Not Saved"
        return label
    }()

    let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", forState: .Normal)
        return button
    }()

    lazy var imagePicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        return picker
    }()

    var imageViewHeightConstraint : NSLayoutConstraint!
    var imageViewWidthConstraint : NSLayoutConstraint!

    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        
        view.addSubview(backgroundImage)
        view.addSubview(nameTextField)
        view.addSubview(nameLabel)
        view.addSubview(addressTextField)
        view.addSubview(addressLabel)
        view.addSubview(cuisineTypeTextField)
        view.addSubview(cuisineTypeLabel)
        view.addSubview(dishNameTextField)
        view.addSubview(dishNameLabel)
        view.addSubview(addPhotoFromAlbumButton)
        view.addSubview(selectedImageView)
        view.addSubview(offersEnglishMenuLabel)
        view.addSubview(offersEnglishMenuSwitch)
        view.addSubview(walkInsOkLabel)
        view.addSubview(walkInsOkSwitch)
        view.addSubview(acceptsCreditCardsLabel)
        view.addSubview(acceptsCreditCardsSwitch)
        view.addSubview(saveTextLabel)
        view.addSubview(saveButton)

        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addPhotoFromAlbumButton.addTarget(self, action:Selector("addPhotoFromAlbumButtonTapped:"), forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action:Selector("saveButtonTapped:"), forControlEvents: .TouchUpInside)
    }

    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageView.image = pickedImage

            // Adjust the constraint to display more of the image.
            imageViewWidthConstraint.constant = 150.0
            imageViewHeightConstraint.constant = 150.0
        }

        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: actions
    @IBAction func saveButtonTapped(sender: UIButton) {
        if let nameText = nameTextField.text {
            let params: [String: AnyObject] = [
                "name": nameText,
                "address": addressTextField.text!,
                "cuisine_type": cuisineTypeTextField.text!,
                "offers_english_menu": offersEnglishMenuSwitch.on,
                "walk_ins_ok": walkInsOkSwitch.on,
                "accepts_credit_cards": acceptsCreditCardsSwitch.on
            ]
            repo.create(params)
                .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                    self.saveTextLabel.text = "Saved"
                    self.router.showRestaurantListScreen()
            }
        } else {
            saveTextLabel.text = "No Restaurant Name Provided"
        }
    }

    @IBAction func addPhotoFromAlbumButtonTapped(sender: UIButton) {
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    // MARK: auto layout
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            backgroundImage.autoCenterInSuperview()
            
            nameLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
            nameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
            nameLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)

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

            dishNameLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
            dishNameLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
            dishNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeTextField)

            dishNameTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
            dishNameTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
            dishNameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: dishNameLabel)

            addPhotoFromAlbumButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: dishNameTextField)
            addPhotoFromAlbumButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            selectedImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: addPhotoFromAlbumButton)
            imageViewWidthConstraint = selectedImageView.autoSetDimension(.Width, toSize: 0.0)
            imageViewHeightConstraint = selectedImageView.autoSetDimension(.Height, toSize: 0.0)
            selectedImageView.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            offersEnglishMenuSwitch.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
            offersEnglishMenuSwitch.autoPinEdge(.Top, toEdge: .Bottom, ofView: selectedImageView)

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

            saveTextLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: acceptsCreditCardsSwitch)
            saveTextLabel.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            saveButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: saveTextLabel)
            saveButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}