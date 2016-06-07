import BrightFutures

class EditRestaurantViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let repo: RestaurantRepo
    private let sessionRepo: SessionRepo
    private(set) var restaurant: Restaurant
    private let id: Int
    private var photoUrlDataSource: PhotoUrlsCollectionViewDataSource?

    // MARK: - View Elements
    let imageCollectionView: UICollectionView
    let scrollView: UIScrollView
    let scrollViewContentView: UIView
    let formViewContainer: UIView
    let formView: EditRestaurantFormView

    // MARK: - Initializers
    init(
        router: Router,
        repo: RestaurantRepo,
        photoRepo: PhotoRepo,
        sessionRepo: SessionRepo,
        reloader: Reloader,
        restaurant: Restaurant)
    {
        self.router = router
        self.repo = repo
        self.sessionRepo = sessionRepo
        self.restaurant = restaurant
        self.id = restaurant.id

        scrollView = UIScrollView.newAutoLayoutView()
        scrollViewContentView = UIView.newAutoLayoutView()
        formViewContainer = UIView.newAutoLayoutView()
        formView = EditRestaurantFormView(restaurant: restaurant)
        imageCollectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: EditRestaurantViewController.imageCollectionViewLayout()
        )

        super.init(nibName: nil, bundle: nil)

        self.photoUrlDataSource = PhotoUrlsCollectionViewDataSource(
            photoUrlsDataSource: self,
            editMode: restaurant.createdByCurrentUser(sessionRepo.getAuthenticatedUser()),
            deletePhotoClosure: { [unowned self] url in
                self.restaurant = self.restaurant.restaurantByDeletingPhotoUrl(url.absoluteString)
                reloader.reload(self.imageCollectionView)

                photoRepo.deletePhoto(url)
            }
        )
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
    }

    private func addSubviews() {
        formViewContainer.addSubview(formView)
        scrollViewContentView.addSubview(imageCollectionView)
        scrollViewContentView.addSubview(formViewContainer)
        scrollView.addSubview(scrollViewContentView)
        view.addSubview(scrollView)
    }

    private func configureSubviews() {
        scrollView.backgroundColor = UIColor.whiteColor()

        imageCollectionView.contentInset = UIEdgeInsets(
            top: 10.0, left: 10.0, bottom: 10.0, right: 10.0
        )
        imageCollectionView.registerClass(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: String(PhotoCollectionViewCell)
        )
        imageCollectionView.backgroundColor = UIColor.lightGrayColor()
        imageCollectionView.dataSource = photoUrlDataSource
    }

    private func addConstraints() {
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        scrollViewContentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        scrollViewContentView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        scrollViewContentView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

        imageCollectionView.autoPinEdgeToSuperviewEdge(.Top)
        imageCollectionView.autoSetDimension(.Height, toSize: 120.0)
        imageCollectionView.autoAlignAxis(
            .Vertical,
            toSameAxisOfView: scrollViewContentView
        )
        imageCollectionView.autoMatchDimension(
            .Width,
            toDimension:.Width,
            ofView: scrollViewContentView
        )

        formViewContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageCollectionView)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        formView.autoPinEdgesToSuperviewEdges()
    }

    // MARK: - Actions
    @objc private func didTapUpdateButton(sender: UIBarButtonItem?) {
        let params: [String: AnyObject] = [
            "name": formView.getNameText()!,
            "address": formView.getAddressText()!,
            "cuisine_type": restaurant.cuisine.name,
            "cuisine_id": restaurant.cuisine.id,
            "offers_english_menu": formView.getOffersEnglishMenuState()!,
            "walk_ins_ok": formView.getWalkInsOkState()!,
            "accepts_credit_cards": formView.getAcceptsCreditCardsState()!,
            "notes": formView.getNotesText()!
        ]
        repo.update(self.id, params: params)
            .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                dispatch_async(dispatch_get_main_queue()) {
                    self.router.showRestaurantListScreen()
                }
        }
    }

    // MARK: - Private Methods
    private static func imageCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(100, 100)
        layout.scrollDirection = .Horizontal
        return layout
    }
}

// MARK: - PhotoUrlsDataSource
extension EditRestaurantViewController: PhotoUrlsDataSource {
    func getPhotoUrls() -> [PhotoUrl] {
        return restaurant.photoUrls
    }
}
