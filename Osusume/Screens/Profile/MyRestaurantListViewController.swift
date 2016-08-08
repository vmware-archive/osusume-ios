import BrightFutures

class MyRestaurantListViewController: UIViewController {
    // MARK: - Properties
    private let reloader: Reloader
    private let myRestaurantSelectionDelegate: MyRestaurantSelectionDelegate
    let getRestaurants: () -> Future<[Restaurant], RepoError>
    let restaurantListDataSource: RestaurantListDataSource
    let emptyStateView: MyRestaurantsEmptyStateView

    // MARK: - View Elements
    let tableView: UITableView

    // MARK: - Initializers
    init(
        reloader: Reloader,
        photoRepo: PhotoRepo,
        myRestaurantSelectionDelegate: MyRestaurantSelectionDelegate,
        emptyStateView: MyRestaurantsEmptyStateView,
        getRestaurants: () -> Future<[Restaurant], RepoError>)
    {
        self.reloader = reloader
        self.restaurantListDataSource = RestaurantListDataSource(photoRepo: photoRepo)
        self.myRestaurantSelectionDelegate = myRestaurantSelectionDelegate
        self.getRestaurants = getRestaurants
        self.emptyStateView = emptyStateView
        self.tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()

        getRestaurants()
            .onSuccess { [unowned self] restaurants in
                if (restaurants.count <= 0) {
                    self.tableView.backgroundView = self.emptyStateView
                    self.tableView.separatorStyle = .None
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .SingleLine
                }
                self.restaurantListDataSource.updateRestaurants(restaurants)
                self.reloader.reload(self.tableView)
        }
    }

    // MARK: - View Setup
    private func configureNavigationBar() {}

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func configureSubviews() {
        tableView.dataSource = restaurantListDataSource
        tableView.delegate = self
        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantTableViewCell)
        )
    }

    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
}

// MARK: - UITableViewDelegate
extension MyRestaurantListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRestaurant = restaurantListDataSource.restaurants[indexPath.row]
        myRestaurantSelectionDelegate.myRestaurantSelected(selectedRestaurant)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
}
