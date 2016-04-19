import BrightFutures

class MyRestaurantListViewController: UIViewController {
    // MARK: - Properties
    private let reloader: Reloader
    private let getRestaurants: () -> Future<[Restaurant], RepoError>
    let restaurantListDataSource: RestaurantListDataSource

    // MARK: - View Elements
    let tableView: UITableView

    // MARK: - Initializers
    init(
        reloader: Reloader,
        photoRepo: PhotoRepo,
        getRestaurants: () -> Future<[Restaurant], RepoError>)
    {
        self.reloader = reloader
        self.restaurantListDataSource = RestaurantListDataSource(photoRepo: photoRepo)
        self.getRestaurants = getRestaurants
        self.tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)

        tableView.dataSource = restaurantListDataSource
        tableView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantTableViewCell)
        )

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()

        getRestaurants()
            .onSuccess { [unowned self] restaurants in
                self.restaurantListDataSource.myPosts = restaurants
                self.reloader.reload(self.tableView)
        }
    }
}

// MARK: - UITableViewDelegate
extension MyRestaurantListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
}
