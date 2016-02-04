import Foundation
import UIKit
import PureLayout
import BrightFutures

class NewRestaurantViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    unowned let router: Router
    let repo: RestaurantRepo

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
    let scrollView  = UIScrollView.newAutoLayoutView()
    let contentInScrollView = UIView.newAutoLayoutView()
    let formViewContainer = UIView.newAutoLayoutView()
    let formView = RestaurantFormView(restaurant: nil)

    let imageView : UIImageView = {
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

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.addSubview(contentInScrollView)
        contentInScrollView.addSubview(formViewContainer)
        formViewContainer.addSubview(formView)
        contentInScrollView.addSubview(imageView)

        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        contentInScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        contentInScrollView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        contentInScrollView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

        formViewContainer.autoPinEdgeToSuperviewEdge(.Top)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        formView.autoPinEdgesToSuperviewEdges()

        imageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: formViewContainer, withOffset: 10.0)
        imageView.autoAlignAxis(.Vertical, toSameAxisOfView: formViewContainer)
        imageView.autoSetDimension(.Height, toSize: 100.0)
        imageView.autoSetDimension(.Width, toSize: 100.0)

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didTapDoneButton:"))
        navigationItem.rightBarButtonItem = doneButton

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("didTapImageView:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Actions
    func didTapDoneButton(sender: UIBarButtonItem?) {
        let params: [String: AnyObject] = [
            "name": formView.getNameText()!,
            "address": formView.getAddressText()!,
            "cuisine_type": formView.getCuisineTypeText()!,
            "offers_english_menu": formView.getOffersEnglishMenuState()!,
            "walk_ins_ok": formView.getWalkInsOkState()!,
            "accepts_credit_cards": formView.getAcceptsCreditCardsState()!,
            "notes": formView.getNotesText()!
        ]
        repo.create(params)
            .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                self.router.showRestaurantListScreen()
        }
        uploadPhoto()
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    func didTapImageView(sender: UITapGestureRecognizer) {
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func uploadPhoto() {
        if let photo = self.imageView.image {
            let UUID = NSUUID().UUIDString

            let photoTempURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString(UUID))
            UIImageJPEGRepresentation(photo, 1.0)?.writeToURL(photoTempURL, atomically: true)

            let transferManager: AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
            let uploadRequest: AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()

            uploadRequest.bucket = "osusume-tokyo-dev"
            uploadRequest.key = "user_id/\(UUID)"
            uploadRequest.body = photoTempURL

            transferManager.upload(uploadRequest).continueWithBlock { (AWSTask task) -> AnyObject! in
                if task.error != nil {
                    print("Error: \(task.error)")
                } else {
                    print("Upload successful")
                }
                
                return nil
            }
        }
    }
}