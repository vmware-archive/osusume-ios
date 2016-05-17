import BrightFutures
import BSImagePicker
import Photos

class NewRestaurantViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let restaurantRepo: RestaurantRepo
    private let photoRepo: PhotoRepo
    private(set) var images: [UIImage]
    private let imagePicker: BSImagePickerViewController

    // MARK: - View Elements
    let scrollView: UIScrollView
    let scrollViewContentView: UIView
    let imageCollectionView: UICollectionView
    let addPhotoButton: UIButton
    let formViewContainer: UIView
    let formView: NewRestaurantFormView

    // MARK: - Initializers
    init(
        router: Router,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo)
    {
        self.router = router
        self.restaurantRepo = restaurantRepo
        self.photoRepo = photoRepo
        images = [UIImage]()
        imagePicker = BSImagePickerViewController()

        scrollView = UIScrollView.newAutoLayoutView()
        scrollViewContentView = UIView.newAutoLayoutView()
        imageCollectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: NewRestaurantViewController.imageCollectionViewLayout()
        )
        addPhotoButton = UIButton(type: UIButtonType.System)
        formViewContainer = UIView.newAutoLayoutView()
        formView = NewRestaurantFormView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for NewRestaurantViewController")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(NewRestaurantViewController.didTapDoneButton(_:))
        )
    }

    private func addSubviews() {
        formViewContainer.addSubview(formView)

        scrollViewContentView.addSubview(imageCollectionView)
        scrollViewContentView.addSubview(addPhotoButton)
        scrollViewContentView.addSubview(formViewContainer)
        scrollView.addSubview(scrollViewContentView)
        view.addSubview(scrollView)
    }

    private func configureSubviews() {
        scrollView.backgroundColor = UIColor.whiteColor()

        imageCollectionView.dataSource = self
        imageCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        imageCollectionView.registerClass(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: String(UICollectionViewCell)
        )
        imageCollectionView.backgroundColor = UIColor.lightGrayColor()

        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.setTitle("Add photos", forState: .Normal)
        addPhotoButton.addTarget(
            self,
            action: #selector(NewRestaurantViewController.didTapAddPhotoButton(_:)),
            forControlEvents: .TouchUpInside
        )

        formView.delegate = self
    }

    private func addConstraints() {
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        scrollViewContentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        scrollViewContentView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        scrollViewContentView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

        imageCollectionView.autoPinEdgeToSuperviewEdge(.Top, withInset: 20.0)
        imageCollectionView.autoAlignAxisToSuperviewAxis(.Vertical)
        imageCollectionView.autoSetDimension(.Height, toSize: 120.0)
        imageCollectionView.autoMatchDimension(.Width, toDimension:.Width, ofView: scrollViewContentView)

        addPhotoButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageCollectionView)
        addPhotoButton.autoAlignAxis(.Vertical, toSameAxisOfView: imageCollectionView)
        addPhotoButton.autoSetDimension(.Height, toSize: 25.0)
        addPhotoButton.autoSetDimension(.Width, toSize: 100.0)

        formViewContainer.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        formViewContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: addPhotoButton, withOffset: 20.0)
        formViewContainer.autoAlignAxis(.Vertical, toSameAxisOfView: formViewContainer)

        formView.autoPinEdgesToSuperviewEdges()
    }

    // MARK: - Actions
    @objc private func didTapDoneButton(sender: UIBarButtonItem?) {
        let photoUrls = photoRepo.uploadPhotos(self.images)

        let newRestaurant = NewRestaurant(
            name: formView.getNameText()!,
            address: formView.getAddressText()!,
            cuisineType: formView.getCuisineTypeText() ?? "",
            cuisineId: formView.selectedCuisine.id,
            priceRangeId: formView.selectedPriceRange.id,
            offersEnglishMenu: formView.getOffersEnglishMenuState()!,
            walkInsOk: formView.getWalkInsOkState()!,
            acceptsCreditCards: formView.getAcceptsCreditCardsState()!,
            notes: formView.getNotesText()!,
            photoUrls: photoUrls
        )

        restaurantRepo.create(newRestaurant)
            .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                dispatch_async(dispatch_get_main_queue()) {
                    self.router.showRestaurantListScreen()
                }
        }
    }

    @objc private func didTapAddPhotoButton(sender: UIButton?) {
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

    // MARK: - Private Methods
    private static func imageCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(100, 100)
        layout.scrollDirection = .Horizontal
        return layout
    }

    private func gatherImageAssets(assets: [PHAsset]) {
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

    private func addImageToCollectionView(image: UIImage?, info: [NSObject: AnyObject]?) {
        guard let i = image else {
            return
        }

        images.append(i)
        imageCollectionView.reloadData()
    }
}

// MARK: - UINavigationControllerDelegate
extension NewRestaurantViewController: UINavigationControllerDelegate {}

// MARK: - UICollectionViewDataSource
extension NewRestaurantViewController: UICollectionViewDataSource {
    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
        ) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            String(UICollectionViewCell),
            forIndexPath: indexPath
        )

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

// MARK: - NewRestaurantViewControllerPresenterProtocol
extension NewRestaurantViewController: NewRestaurantViewControllerPresenterProtocol {
    func showFindCuisineScreen() {
        router.showFindCuisineScreen()
    }

    func showFindRestaurantScreen() {
        router.showFindRestaurantScreen()
    }

    func showPriceRangeScreen() {
        router.showPriceRangeListScreen()
    }
}
