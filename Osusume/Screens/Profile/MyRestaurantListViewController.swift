import BrightFutures

class MyRestaurantListViewController: UIViewController {
    private let reloader: Reloader
    let restaurantDataSource: RestaurantDataSource
    let getRestaurants: () -> Future<[Restaurant], RepoError>
    let tableView: UITableView

    let cellIdentifier = "RestaurantListItemCell"

    init(
        reloader: Reloader,
        photoRepo: PhotoRepo,
        getRestaurants: () -> Future<[Restaurant], RepoError>)
    {
        self.reloader = reloader
        self.restaurantDataSource = RestaurantDataSource(photoRepo: photoRepo)
        self.getRestaurants = getRestaurants
        self.tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)

        tableView.dataSource = restaurantDataSource
        tableView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()

        getRestaurants()
            .onSuccess { [unowned self] restaurants in
                self.restaurantDataSource.myPosts = restaurants
                self.reloader.reload(self.tableView)
        }
    }
}

extension MyRestaurantListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
}
