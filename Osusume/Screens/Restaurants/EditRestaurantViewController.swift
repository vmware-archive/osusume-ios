import BrightFutures
import BSImagePicker
import Photos


enum EditRestaurantTableViewRow: Int {
    case EditPhotosCell = 0
    case FindRestaurantCell
    case CuisineCell
    case PriceRangeCell
    case NotesCell
    case Count
    
    static var count: Int {
        get {
            return EditRestaurantTableViewRow.Count.rawValue
        }
    }
}

class EditRestaurantViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let repo: RestaurantRepo
    private let photoRepo: PhotoRepo
    private let sessionRepo: SessionRepo
    private var imagePicker: ImagePicker?
    private let reloader: Reloader

    private let imagePickerViewController: BSImagePickerViewController
    private(set) var restaurant: Restaurant
    var restaurantEditResult: (name: String, address: String, cuisine: Cuisine, priceRange: PriceRange)
    private let id: Int
    private(set) var photoUrlDataSource: PhotoUrlsCollectionViewDataSource?
    private var addedPhotos: [UIImage]

    let editRestaurantPhotosTableViewCell: EditRestaurantPhotosTableViewCell
    private var maybeFindRestaurantTableViewCell: FindRestaurantTableViewCell
    private lazy var maybePopulatedRestaurantTableViewCell = PopulatedRestaurantTableViewCell()
    private let cuisineTableViewCell: CuisineTableViewCell
    private let priceRangeTableViewCell: PriceRangeTableViewCell
    let notesTableViewCell: NotesTableViewCell

    // MARK: - View Elements
    let tableView: UITableView

    // MARK: - Initializers
    init(
        router: Router,
        repo: RestaurantRepo,
        photoRepo: PhotoRepo,
        sessionRepo: SessionRepo,
        imagePicker: ImagePicker?,
        reloader: Reloader,
        restaurant: Restaurant)
    {
        self.router = router
        self.repo = repo
        self.sessionRepo = sessionRepo
        self.imagePicker = imagePicker
        self.reloader = reloader
        self.restaurant = restaurant
        self.id = restaurant.id
        self.restaurantEditResult = (
            name: restaurant.name,
            address: restaurant.address,
            cuisine: restaurant.cuisine,
            priceRange: restaurant.priceRange
        )

        imagePickerViewController = BSImagePickerViewController()
        self.photoRepo = photoRepo
        addedPhotos = [UIImage]()

        tableView = UITableView.newAutoLayoutView()
        
        editRestaurantPhotosTableViewCell = EditRestaurantPhotosTableViewCell()
        maybeFindRestaurantTableViewCell = FindRestaurantTableViewCell()
        cuisineTableViewCell = CuisineTableViewCell()
        priceRangeTableViewCell = PriceRangeTableViewCell()
        notesTableViewCell = NotesTableViewCell()

        super.init(nibName: nil, bundle: nil)

        self.photoUrlDataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            addedPhotosDataSource: self,
            editMode: restaurant.createdByCurrentUser(sessionRepo.getAuthenticatedUser()),
            deletePhotoClosure: { [unowned self] photoUrlId in
                self.restaurant = self.restaurant.restaurantByDeletingPhotoUrl(photoUrlId)
                reloader.reload(self.editRestaurantPhotosTableViewCell.imageCollectionView)

                photoRepo.deletePhoto(self.restaurant.id, photoUrlId: photoUrlId)
            }
        )
    }

    convenience init(
        router: Router,
        repo: RestaurantRepo,
        photoRepo: PhotoRepo,
        sessionRepo: SessionRepo,
        reloader: Reloader,
        restaurant: Restaurant)
    {
        self.init(
            router: router,
            repo: repo,
            photoRepo: photoRepo,
            sessionRepo: sessionRepo,
            imagePicker: nil,
            reloader: reloader,
            restaurant: restaurant
        )

        self.imagePicker = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Restaurant"

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Update",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(EditRestaurantViewController.didTapUpdateButton(_:))
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(EditRestaurantViewController.didTapCancelButton(_:))
        )
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }

    // MARK: - Actions
    @objc private func didTapUpdateButton(sender: UIBarButtonItem?) {
        let addedPhotoUrls = photoRepo.uploadPhotos(addedPhotos)
        let existingAndAddedPhotos = restaurant.photoUrls.map({photoUrl in photoUrl.url.absoluteString}) + addedPhotoUrls

        let params: [String: AnyObject] = [
            "name":  maybePopulatedRestaurantTableViewCell.textLabel?.text ?? "",
            "address":  maybePopulatedRestaurantTableViewCell.detailTextLabel?.text ?? "",
            "cuisine_type":  restaurantEditResult.cuisine.name,
            "cuisine_id": restaurantEditResult.cuisine.id,
            "price_range_id" : restaurantEditResult.priceRange.id,
            "notes": notesTableViewCell.formView.getNotesText() ?? "",
            "photo_urls":  existingAndAddedPhotos
        ]
        repo.update(self.id, params: params)
            .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                dispatch_async(dispatch_get_main_queue()) {
                    self.router.dismissPresentedNavigationController()
                }
        }
    }

    @objc private func didTapCancelButton(sender: UIBarButtonItem?) {
        self.router.dismissPresentedNavigationController()
    }

    @objc func didTapAddPhotoButton(sender: UIButton?) {
        imagePicker?.bs_presentImagePickerController(
            imagePickerViewController,
            animated: true,
            select: nil,
            deselect: nil,
            cancel: nil,
            finish: gatherImageAssets,
            completion: nil
        )
    }

    // MARK: - Private Methods
    private func gatherImageAssets(assets: [PHAsset]) {
        addedPhotos.removeAll()
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

    private func addImageToCollectionView(maybeImage: UIImage?, info: [NSObject: AnyObject]?) {
        guard let image = maybeImage else {
            return
        }

        addedPhotos.append(image)
        tableView.reloadData()
    }
}

// MARK: - PhotoUrlsDataSource
extension EditRestaurantViewController: PhotoUrlsDataSource {
    func getPhotoUrls() -> [PhotoUrl] {
        return restaurant.photoUrls
    }
}

// MARK: - AddedPhotosDataSource
extension EditRestaurantViewController: AddedPhotosDataSource {
    func getAddedPhotos() -> [UIImage] {
        return addedPhotos
    }
}

// MARK: - UITableViewDelegate
extension EditRestaurantViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case EditRestaurantTableViewRow.FindRestaurantCell.rawValue:
            showFindRestaurantScreen(self)
        case EditRestaurantTableViewRow.CuisineCell.rawValue:
            showFindCuisineScreen(self)
        case EditRestaurantTableViewRow.PriceRangeCell.rawValue:
            showPriceRangeScreen(self)
        default:
            break
        }
    }
    
}

// MARK: - UITableViewDataSource
extension EditRestaurantViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditRestaurantTableViewRow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case EditRestaurantTableViewRow.EditPhotosCell.rawValue:
            editRestaurantPhotosTableViewCell.configureCell(
                self,
                dataSource: photoUrlDataSource!,
                reloader: reloader
            )
            return editRestaurantPhotosTableViewCell
            
        case EditRestaurantTableViewRow.FindRestaurantCell.rawValue:
            if (restaurantEditResult.name == "") {
                return maybeFindRestaurantTableViewCell
            }
            
            maybePopulatedRestaurantTableViewCell.textLabel?.text = restaurantEditResult.name
            maybePopulatedRestaurantTableViewCell.detailTextLabel?.text = restaurantEditResult.address
            return maybePopulatedRestaurantTableViewCell
            
        case EditRestaurantTableViewRow.CuisineCell.rawValue:
            let restaurantCuisineName = restaurantEditResult.cuisine.name
            if (restaurantCuisineName != "Not Specified") {
                cuisineTableViewCell.textLabel?.text = restaurantCuisineName
            }
            
            return cuisineTableViewCell
            
        case EditRestaurantTableViewRow.PriceRangeCell.rawValue:
            let restaurantPriceRange = restaurantEditResult.priceRange.range
            if (restaurantPriceRange != "Not Specified") {
                priceRangeTableViewCell.textLabel?.text = restaurantPriceRange
            }
            
            return priceRangeTableViewCell
            
        case EditRestaurantTableViewRow.NotesCell.rawValue:
            notesTableViewCell.formView.notesTextField.text = restaurant.notes
            return notesTableViewCell
            
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - RestaurantViewControllerPresenterProtocol
extension EditRestaurantViewController: RestaurantViewControllerPresenterProtocol {
    func showFindCuisineScreen(delegate: CuisineSelectionDelegate) {
        router.showFindCuisineScreen(delegate)
    }

    func showFindRestaurantScreen(delegate: SearchResultRestaurantSelectionDelegate) {
        router.showFindRestaurantScreen(delegate)
    }

    func showPriceRangeScreen(delegate: PriceRangeSelectionDelegate) {
        router.showPriceRangeListScreen(delegate)
    }
}

// MARK: - SearchResultRestaurantSelectionDelegate
extension EditRestaurantViewController: SearchResultRestaurantSelectionDelegate {
    func searchResultRestaurantSelected(restaurantSuggestion: RestaurantSuggestion) {
        restaurantEditResult.name = restaurantSuggestion.name
        restaurantEditResult.address = restaurantSuggestion.address
        
        reloader.reload(tableView)
    }
}

// MARK: - CuisineSelectionDelegate
extension EditRestaurantViewController: CuisineSelectionDelegate {
    func cuisineSelected(cuisine: Cuisine) {
        restaurantEditResult.cuisine = cuisine
        reloader.reload(tableView)
    }
}

// MARK: - PriceRangeSelectionDelegate
extension EditRestaurantViewController: PriceRangeSelectionDelegate {
    func priceRangeSelected(priceRange: PriceRange) {
        restaurantEditResult.priceRange = priceRange
        reloader.reload(tableView)
    }
}
