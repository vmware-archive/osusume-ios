import BrightFutures

class RestaurantListViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let repo: RestaurantRepo
    private let reloader: Reloader
    let restaurantListDataSource: RestaurantListDataSource

    // MARK: - View Elements
    let tableView: UITableView

    // MARK: - Initializers
    init(
        router: Router,
        repo: RestaurantRepo,
        reloader: Reloader,
        photoRepo: PhotoRepo)
    {
        self.router = router
        self.repo = repo
        self.reloader = reloader
        self.restaurantListDataSource = RestaurantListDataSource(photoRepo: photoRepo)

        tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantListViewController")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Osusume"

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        repo.getAll()
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurants in
                self.restaurantListDataSource.updateRestaurants(returnedRestaurants)
                self.reloader.reload(self.tableView)
        }
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Profile",
            style: .Plain,
            target: self,
            action: #selector(RestaurantListViewController.didTapProfileButton(_:))
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add restaurant",
            style: .Plain,
            target: self,
            action: #selector(RestaurantListViewController.didTapAddRestaurantButton(_:))
        )
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func configureSubviews() {
        tableView.dataSource = self.restaurantListDataSource
        tableView.delegate = self
        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantTableViewCell)
        )
    }

    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    // MARK: - Actions
    @objc private func didTapProfileButton(sender: UIBarButtonItem) {
        router.showProfileScreen()
    }

    @objc private func didTapAddRestaurantButton(sender: UIBarButtonItem) {
        router.showNewRestaurantScreen()
    }
}

// MARK: - UITableViewDelegate
extension RestaurantListViewController: UITableViewDelegate {
    func tableView(
        tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 160.0
    }

    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let id = restaurantListDataSource.restaurants[indexPath.row].id
        router.showRestaurantDetailScreen(id)
    }
}
