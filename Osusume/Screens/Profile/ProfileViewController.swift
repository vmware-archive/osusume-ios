import Foundation

class ProfileViewController: UIViewController {
    let router: Router
    let userRepo: UserRepo
    let sessionRepo: SessionRepo
    let postRepo: PostRepo
    let reloader: Reloader
    let restaurantDataSource: RestaurantDataSource

    let cellIdentifier = "RestaurantListItemCell"


    //MARK: - View Elements
    let userNameLabel: UILabel
    let logoutButton: UIButton
    let tableView: UITableView

    init(router: Router,
        userRepo: UserRepo,
        sessionRepo: SessionRepo,
        postRepo: PostRepo,
        photoRepo: PhotoRepo,
        reloader: Reloader)
    {
        self.router = router
        self.userRepo = userRepo
        self.sessionRepo = sessionRepo
        self.postRepo = postRepo
        self.reloader = reloader
        self.restaurantDataSource = RestaurantDataSource(photoRepo: photoRepo)

        logoutButton = UIButton.newAutoLayoutView()
        userNameLabel = UILabel.newAutoLayoutView()
        tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)

        self.tableView.dataSource = self.restaurantDataSource
        self.tableView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )

        title = "My Profile"

        logoutButton.backgroundColor = UIColor.grayColor()
        logoutButton.setTitle("Logout", forState: .Normal)
        logoutButton.addTarget(
            self,
            action: Selector("didTapLogoutButton:"),
            forControlEvents: .TouchUpInside
        )

        let userInfoView = UIView.newAutoLayoutView()
        userInfoView.addSubview(userNameLabel)
        userInfoView.addSubview(logoutButton)
        view.addSubview(userInfoView)
        view.addSubview(tableView)

        view.backgroundColor = UIColor.whiteColor()

        userInfoView.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        userInfoView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        userInfoView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        userInfoView.autoSetDimension(.Height, toSize: 80.0)

        userNameLabel.autoPinEdgeToSuperviewEdge(.Top)
        userNameLabel.autoPinEdgeToSuperviewEdge(.Leading)
        userNameLabel.autoPinEdge(.Trailing, toEdge: .Leading, ofView: logoutButton)

        logoutButton.autoPinEdgeToSuperviewEdge(.Top)
        logoutButton.autoPinEdge(.Leading, toEdge: .Trailing, ofView: userNameLabel)
        logoutButton.autoSetDimension(.Width, toSize: 100.0)
        logoutButton.autoPinEdgeToSuperviewEdge(.Trailing)

        tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: userInfoView)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)

        userRepo.fetchCurrentUserName()
            .onSuccess { [unowned self] userName in
                self.userNameLabel.text = userName
            }

        postRepo.getAll()
            .onSuccess { [unowned self] restaurants in
                self.restaurantDataSource.myPosts = restaurants
                self.reloader.reload(self.tableView)
            }

    }

    //MARK: - Actions
    func didTapLogoutButton(sender: UIButton?) {
        sessionRepo.deleteToken()
        router.showLoginScreen()
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
}

