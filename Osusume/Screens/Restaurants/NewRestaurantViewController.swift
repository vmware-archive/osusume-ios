import BrightFutures
import BSImagePicker
import Photos

enum NewRestuarantTableViewRow: Int {
    case AddPhotosCell = 0
    case FindRestaurantCell
    case CuisineCell
    case PriceRangeCell
    case NotesCell
    case Count

    static var count: Int {
        get {
            return NewRestuarantTableViewRow.Count.rawValue
        }
    }
}

class NewRestaurantViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let restaurantRepo: RestaurantRepo
    private let photoRepo: PhotoRepo
    private var imagePicker: ImagePicker?
    private let reloader: Reloader

    private(set) var images: [UIImage]
    private let imagePickerViewController: BSImagePickerViewController

    var newRestaurant = NewRestaurant()

    let addRestaurantPhotosTableViewCell: AddRestaurantPhotosTableViewCell
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
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo,
        imagePicker: ImagePicker?,
        reloader: Reloader)
    {
        self.router = router
        self.restaurantRepo = restaurantRepo
        self.photoRepo = photoRepo
        self.imagePicker = imagePicker
        self.reloader = reloader

        images = [UIImage]()
        imagePickerViewController = BSImagePickerViewController()

        tableView = UITableView.newAutoLayoutView()

        addRestaurantPhotosTableViewCell = AddRestaurantPhotosTableViewCell()
        maybeFindRestaurantTableViewCell = FindRestaurantTableViewCell()
        cuisineTableViewCell = CuisineTableViewCell()
        priceRangeTableViewCell = PriceRangeTableViewCell()
        notesTableViewCell = NotesTableViewCell()

        super.init(nibName: nil, bundle: nil)
    }

    convenience init(
        router: Router,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo,
        reloader: Reloader)
    {
        self.init(
            router: router,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo,
            imagePicker: nil,
            reloader: reloader
        )

        self.imagePicker = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for NewRestaurantViewController")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Restaurant"

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(NewRestaurantViewController.didTapSaveButton(_:))
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(NewRestaurantViewController.didTapCancelButton(_:))
        )
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self

        addRestaurantPhotosTableViewCell.configureCell(
            self,
            dataSource: self,
            reloader: DefaultReloader()
        )

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    // MARK: - Actions
    @objc private func didTapSaveButton(sender: UIBarButtonItem?) {
        let photoUrls = photoRepo.uploadPhotos(images)

        let restaurantTableViewCellIndexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.NotesCell.rawValue,
            inSection: 0
        )
        let maybeCell = tableView.dataSource?.tableView(
            tableView,
            cellForRowAtIndexPath: restaurantTableViewCellIndexPath
        ) as? NotesTableViewCell

        if let cell = maybeCell {
            let formView = cell.formView
            newRestaurant.notes = formView.getNotesText()
            newRestaurant.photoUrls = photoUrls

            restaurantRepo.create(newRestaurant)
                .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
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

    private func addImageToCollectionView(maybeImage: UIImage?, info: [NSObject: AnyObject]?) {
        guard let image = maybeImage else {
            return
        }

        images.append(image)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension NewRestaurantViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int
    {
        return NewRestuarantTableViewRow.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        switch indexPath.row {
            case NewRestuarantTableViewRow.AddPhotosCell.rawValue:
                addRestaurantPhotosTableViewCell.configureCell(
                    self,
                    dataSource: self,
                    reloader: DefaultReloader()
                )
                return addRestaurantPhotosTableViewCell

            case NewRestuarantTableViewRow.FindRestaurantCell.rawValue:
                if let restaurantName = newRestaurant.name,
                    restaurantAddress = newRestaurant.address
                {
                    maybePopulatedRestaurantTableViewCell.textLabel?.text = restaurantName
                    maybePopulatedRestaurantTableViewCell.detailTextLabel?.text = restaurantAddress
                    return maybePopulatedRestaurantTableViewCell
                } else {
                    return maybeFindRestaurantTableViewCell
                }

            case NewRestuarantTableViewRow.CuisineCell.rawValue:
                if let cuisine = newRestaurant.cuisine {
                    cuisineTableViewCell.textLabel?.text = cuisine.name
                }
                return cuisineTableViewCell

            case NewRestuarantTableViewRow.PriceRangeCell.rawValue:
                if let priceRange = newRestaurant.priceRange {
                    priceRangeTableViewCell.textLabel?.text = priceRange.range
                }
                return priceRangeTableViewCell

            case NewRestuarantTableViewRow.NotesCell.rawValue:
                notesTableViewCell.configureCell(self)
                return notesTableViewCell

            default:
                return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension NewRestaurantViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case NewRestuarantTableViewRow.FindRestaurantCell.rawValue:
                showFindRestaurantScreen(self)
            case NewRestuarantTableViewRow.CuisineCell.rawValue:
                showFindCuisineScreen(self)
            case NewRestuarantTableViewRow.PriceRangeCell.rawValue:
                showPriceRangeScreen(self)
            default:
                break
        }
    }
}

// MARK: - UICollectionViewDataSource
extension NewRestaurantViewController: UICollectionViewDataSource {
    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int
    {
        return images.count
    }

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
}

// MARK: - RestaurantViewControllerPresenterProtocol
extension NewRestaurantViewController: RestaurantViewControllerPresenterProtocol {
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
extension NewRestaurantViewController: SearchResultRestaurantSelectionDelegate {
    func searchResultRestaurantSelected(restaurantSuggestion: RestaurantSuggestion) {
        newRestaurant.name = restaurantSuggestion.name
        newRestaurant.address = restaurantSuggestion.address
        newRestaurant.placeId = restaurantSuggestion.placeId
        newRestaurant.latitude = restaurantSuggestion.latitude
        newRestaurant.longitude = restaurantSuggestion.longitude

        reloader.reload(tableView)
    }
}

// MARK: - CuisineSelectionDelegate
extension NewRestaurantViewController: CuisineSelectionDelegate {
    func cuisineSelected(cuisine: Cuisine) {
        newRestaurant.cuisine = cuisine
        reloader.reload(tableView)
    }
}

// MARK: - PriceRangeSelectionDelegate
extension NewRestaurantViewController: PriceRangeSelectionDelegate {
    func priceRangeSelected(priceRange: PriceRange) {
        newRestaurant.priceRange = priceRange
        reloader.reload(tableView)
    }
}
