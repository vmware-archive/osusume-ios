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

    let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", forState: .Normal)
        return button
    }()

    let formView = RestaurantFormView(restaurant: nil)

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
        view.addSubview(saveButton)

        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.addTarget(self, action:Selector("saveButtonTapped:"), forControlEvents: .TouchUpInside)
    }

    // MARK: - actions
    @IBAction func saveButtonTapped(sender: UIButton) {
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

            saveButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: formView)
            saveButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}