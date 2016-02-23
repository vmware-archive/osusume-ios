import Foundation
import UIKit
import PureLayout
import BrightFutures
import BSImagePicker
import Photos

class NewRestaurantViewController: UIViewController {

    unowned let router: Router
    let restaurantRepo: RestaurantRepo
    let photoRepo: PhotoRepo

    //MARK: - Initializers
    init(
        router: Router,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo)
    {
        self.router = router
        self.restaurantRepo = restaurantRepo
        self.photoRepo = photoRepo

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

    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(100, 100)
        layout.scrollDirection = .Horizontal

        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView.backgroundColor = UIColor.lightGrayColor()
        collectionView.accessibilityLabel = "Photos to be uploaded"

        return collectionView
    }()

    var images = [UIImage]()

    lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("add photos", forState: .Normal)
        button.backgroundColor = .whiteColor()
        button.setTitleColor(.blackColor(), forState: .Normal)
        button.addTarget(
            self,
            action: Selector("didTapAddPhotoButton:"),
            forControlEvents: .TouchUpInside
        )
        return button
    }()

    lazy var imagePicker : BSImagePickerViewController = {
        let picker = BSImagePickerViewController()
        return picker
    }()

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.addSubview(contentInScrollView)
        contentInScrollView.addSubview(imageCollectionView)
        contentInScrollView.addSubview(addPhotoButton)
        contentInScrollView.addSubview(formViewContainer)
        formViewContainer.addSubview(formView)

        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        contentInScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        contentInScrollView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        contentInScrollView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

        imageCollectionView.autoPinEdgeToSuperviewEdge(.Top, withInset: 20.0)
        imageCollectionView.autoAlignAxisToSuperviewAxis(.Vertical)
        imageCollectionView.autoSetDimension(.Height, toSize: 120.0)
        imageCollectionView.autoMatchDimension(.Width, toDimension:.Width, ofView: contentInScrollView)

        addPhotoButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageCollectionView)
        addPhotoButton.autoAlignAxis(.Vertical, toSameAxisOfView: imageCollectionView)
        addPhotoButton.autoSetDimension(.Height, toSize: 25.0)
        addPhotoButton.autoSetDimension(.Width, toSize: 100.0)

        formViewContainer.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        formViewContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: addPhotoButton, withOffset: 20.0)
        formViewContainer.autoAlignAxis(.Vertical, toSameAxisOfView: formViewContainer)
        formView.autoPinEdgesToSuperviewEdges()

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("didTapDoneButton:")
        )
        navigationItem.rightBarButtonItem = doneButton
    }

    // MARK: - Actions
    func didTapDoneButton(sender: UIBarButtonItem?) {
        let photoUrls = photoRepo.uploadPhotos(self.images)

        let newRestaurant = NewRestaurant(
            name: formView.getNameText()!,
            address: formView.getAddressText()!,
            cuisineType: formView.getCuisineTypeText()!,
            offersEnglishMenu: formView.getOffersEnglishMenuState()!,
            walkInsOk: formView.getWalkInsOkState()!,
            acceptsCreditCards: formView.getAcceptsCreditCardsState()!,
            notes: formView.getNotesText()!,
            photoUrls: photoUrls
        )

        restaurantRepo.create(newRestaurant)
            .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                self.router.showRestaurantListScreen()
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension NewRestaurantViewController: UINavigationControllerDelegate {
    func didTapAddPhotoButton(sender: UIButton?) {
        bs_presentImagePickerController(
            imagePicker,
            animated: true,
            select: nil,
            deselect: nil,
            cancel: nil,
            finish: gatherImageAssets,
            completion: nil
        )
    }

    func gatherImageAssets(assets: [PHAsset]) {
        images.removeAll()

        let imageManager = PHImageManager.defaultManager()
        for asset in assets {
            imageManager.requestImageForAsset(
                asset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .Default,
                options: nil,
                resultHandler: addImageToCollectionView
            )
        }
    }

    func addImageToCollectionView(image: UIImage?, info: [NSObject: AnyObject]?) {
        guard let i = image else {
            return
        }

        images.append(i)
        imageCollectionView.reloadData()
    }
}

extension NewRestaurantViewController: UICollectionViewDataSource {
    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
        ) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath)

        cell.backgroundView = UIImageView(image: images[indexPath.row])

        return cell
    }

    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int
    {
        return images.count
    }
}

extension NewRestaurantViewController: UICollectionViewDelegate {}
