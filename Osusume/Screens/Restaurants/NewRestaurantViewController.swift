import Foundation
import UIKit
import PureLayout
import BrightFutures

class NewRestaurantViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    unowned let router: Router
    let repo: Repo

    //MARK: - Initializers
    init(router: Router, repo: Repo) {
        self.router = router
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for NewRestaurantViewController")
    }

    //MARK: View Elements
    let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", forState: .Normal)
        return button
    }()

    let formView = RestaurantFormView(restaurant: nil)

    let selectedImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.layer.borderColor = UIColor.blackColor().CGColor
        imageView.layer.borderWidth = 2.0
        imageView.backgroundColor = UIColor.grayColor()
        return imageView
    }()

    lazy var imagePicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        return picker
    }()

    var didSetupConstraints = false


    //MARK: - View Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()

        view.addSubview(formView)
        view.addSubview(selectedImageView)
        view.addSubview(saveButton)

        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("selectedImageViewTapped:"))
        selectedImageView.userInteractionEnabled = true
        selectedImageView.addGestureRecognizer(tapGestureRecognizer)

        saveButton.addTarget(self, action:Selector("saveButtonTapped:"), forControlEvents: .TouchUpInside)
    }

    // MARK: - Actions
    func saveButtonTapped(sender: UIButton) {
        let params: [String: AnyObject] = [
            "name": formView.getNameText()!,
            "address": formView.getAddressText()!,
            "cuisine_type": formView.getCuisineTypeText()!,
            "offers_english_menu": formView.getOffersEnglishMenuState()!,
            "walk_ins_ok": formView.getWalkInsOkState()!,
            "accepts_credit_cards": formView.getAcceptsCreditCardsState()!
        ]
        repo.create(params)
            .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                self.router.showRestaurantListScreen()
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    func selectedImageViewTapped(sender: UITapGestureRecognizer) {
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    // MARK: - auto layout
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            formView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
            formView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
            formView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
            formView.autoSetDimension(.Height, toSize: 250.0)

            selectedImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: formView, withOffset: 10.0)
            selectedImageView.autoAlignAxis(.Vertical, toSameAxisOfView: view)
            selectedImageView.autoSetDimension(.Height, toSize: 100.0)
            selectedImageView.autoSetDimension(.Width, toSize: 100.0)

            saveButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: selectedImageView, withOffset: 10.0)
            saveButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}