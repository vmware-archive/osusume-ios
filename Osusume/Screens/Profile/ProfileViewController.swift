import Foundation

class ProfileViewController: UIViewController, UITableViewDataSource {
    let router: Router
    let userRepo: UserRepo
    let sessionRepo: SessionRepo
    let postRepo: PostRepo
    let photoRepo: PhotoRepo
    let reloader: Reloader
    var posts: [Restaurant]

    let cellIdentifier = "RestaurantListItemCell"


    //MARK: - View Elements
    let userNameLabel: UILabel
    let logoutButton: UIButton
    let restaurantsLabel: UILabel
    let tableView: UITableView

    init(router: Router,
        userRepo: UserRepo,
        sessionRepo: SessionRepo,
        postRepo: PostRepo,
        photoRepo: PhotoRepo,
        reloader: Reloader) {
        self.router = router
        self.userRepo = userRepo
        self.sessionRepo = sessionRepo
        self.postRepo = postRepo
        self.photoRepo = photoRepo
        self.reloader = reloader
        self.posts = [Restaurant]()

        logoutButton = UIButton.newAutoLayoutView()
        userNameLabel = UILabel.newAutoLayoutView()
        restaurantsLabel = UILabel.newAutoLayoutView()
        tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)

        self.tableView.dataSource = self
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

        restaurantsLabel.text = "My Posts"

        let userInfoView = UIView.newAutoLayoutView()
        userInfoView.addSubview(userNameLabel)
        userInfoView.addSubview(logoutButton)
        view.addSubview(userInfoView)
        view.addSubview(restaurantsLabel)
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

        restaurantsLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: userInfoView)
        restaurantsLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        restaurantsLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

        tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantsLabel)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)

        userRepo.fetchCurrentUserName()
            .onSuccess { [unowned self] userName in
                self.userNameLabel.text = userName
            }

        postRepo.getAll()
            .onSuccess { restaurants in
                self.posts = restaurants
                self.reloader.reload(self.tableView)
            }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        if
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
                as? RestaurantTableViewCell
        {
            let presenter = RestaurantDetailPresenter(
                restaurant: posts[indexPath.row]
            )

            cell.photoImageView.image = UIImage(named: "TableCellPlaceholder")
            photoRepo.loadImageFromUrl(presenter.photoUrl)
                .onSuccess { image in
                    cell.photoImageView.image = image
            }

            cell.nameLabel.text = presenter.name
            cell.cuisineTypeLabel.text = presenter.cuisineType
            cell.authorLabel.text = presenter.author
            cell.createdAtLabel.text = presenter.creationDate

            return cell
        }

        return UITableViewCell()
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