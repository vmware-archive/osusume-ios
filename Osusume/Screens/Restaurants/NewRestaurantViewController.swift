import Foundation
import UIKit
import PureLayout
import BrightFutures

class NewRestaurantViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    unowned let router: Router
    let repo: RestaurantRepo
    let scrollView  = UIScrollView.newAutoLayoutView()

    let contentInScrollView = UIView.newAutoLayoutView()

    //MARK: - Initializers
    init(router: Router, repo: RestaurantRepo) {
        self.router = router
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for NewRestaurantViewController")
    }

    //MARK: View Elements
    let formView = RestaurantFormView.init(restaurant: nil)

    let selectedImageView : UIImageView = {
        let imageView = UIImageView.newAutoLayoutView()
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

    var contentView = UIView.newAutoLayoutView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        scrollView.addSubview(contentInScrollView)
        contentInScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        contentInScrollView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        contentInScrollView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

        let formViewContainer = UIView.newAutoLayoutView()

        scrollView.backgroundColor = UIColor.whiteColor()

        contentInScrollView.addSubview(formViewContainer)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Top)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        formViewContainer.addSubview(formView)
        formView.autoPinEdgesToSuperviewEdges()

        contentInScrollView.addSubview(selectedImageView)
        selectedImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: formViewContainer, withOffset: 10.0)
        selectedImageView.autoAlignAxis(.Vertical, toSameAxisOfView: formViewContainer)
        selectedImageView.autoSetDimension(.Height, toSize: 100.0)
        selectedImageView.autoSetDimension(.Width, toSize: 100.0)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneButtonTapped:"))
        navigationItem.rightBarButtonItem = doneButton

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("selectedImageViewTapped:"))
        selectedImageView.userInteractionEnabled = true
        selectedImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Actions
    func doneButtonTapped(sender: UIBarButtonItem?) {
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
}