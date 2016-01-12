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

    let formView = RestaurantFormView()

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
        view.backgroundColor = UIColor.lightGrayColor()

        view.addSubview(formView)
        view.addSubview(addPhotoFromAlbumButton)
        view.addSubview(selectedImageView)
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

    // MARK: - actions
    @IBAction func saveButtonTapped(sender: UIButton) {
        if let nameText = formView.getNameText() {
            let params: [String: AnyObject] = [
                "name": nameText,
                "address": formView.getAddressText()!,
                "cuisine_type": formView.getCuisineTypeText()!,
                "offers_english_menu": formView.getOffersEnglishMenuState()!,
                "walk_ins_ok": formView.getWalkInsOkState()!,
                "accepts_credit_cards": formView.getAcceptsCreditCardsState()!
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

    // MARK: - auto layout
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            formView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
            formView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
            formView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
            formView.autoSetDimension(.Height, toSize: 300.0) // This is hard-coded. Should set to natural height.

            addPhotoFromAlbumButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: formView, withOffset: 8.0)
            addPhotoFromAlbumButton.autoAlignAxis(.Vertical, toSameAxisOfView: formView)

            selectedImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: addPhotoFromAlbumButton)
            imageViewWidthConstraint = selectedImageView.autoSetDimension(.Width, toSize: 0.0)
            imageViewHeightConstraint = selectedImageView.autoSetDimension(.Height, toSize: 0.0)
            selectedImageView.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            saveTextLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: selectedImageView)
            saveTextLabel.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            saveButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: saveTextLabel)
            saveButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}