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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureSubviews()
        addConstraints()

        getRestaurants()
            .onSuccess { [unowned self] restaurants in
                self.restaurantListDataSource.myPosts = restaurants
                self.reloader.reload(self.tableView)
        }
    }

    // MARK: - View Setup
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
}
