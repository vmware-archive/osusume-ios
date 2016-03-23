class MyLikesTableViewController: UIViewController {
    let userRepo: UserRepo
    let reloader: Reloader
    let restaurantDataSource: RestaurantDataSource
    let tableView: UITableView

    let cellIdentifier = "RestaurantListItemCell"

    init(
        userRepo: UserRepo,
        reloader: Reloader,
        photoRepo: PhotoRepo)
    {
        self.userRepo = userRepo
        self.reloader = reloader
        self.restaurantDataSource = RestaurantDataSource(photoRepo: photoRepo)
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

        userRepo.getMyLikes()
            .onSuccess { [unowned self] restaurants in
                self.restaurantDataSource.myPosts = restaurants
                self.reloader.reload(self.tableView)
        }
    }
}

extension MyLikesTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
}
