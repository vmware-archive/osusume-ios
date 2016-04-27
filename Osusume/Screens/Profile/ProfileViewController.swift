import BrightFutures

class ProfileViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let userRepo: UserRepo
    private let sessionRepo: SessionRepo
    private let reloader: Reloader
    private let photoRepo: PhotoRepo
    private(set) var currentPage: Int
    private var viewControllers: [UIViewController]

    // MARK: - View Elements
    let userInfoView: UIView
    let userNameLabel: UILabel
    let logoutButton: UIButton
    let myContentSegmentedControl: UISegmentedControl
    let pageViewController: UIPageViewController

    // MARK: - Initializers
    init(router: Router,
        userRepo: UserRepo,
        sessionRepo: SessionRepo,
        photoRepo: PhotoRepo,
        reloader: Reloader)
    {
        self.router = router
        self.userRepo = userRepo
        self.sessionRepo = sessionRepo
        self.photoRepo = photoRepo
        self.reloader = reloader
        currentPage = 0
        viewControllers = [
            MyRestaurantListViewController(
                reloader: self.reloader,
                photoRepo: self.photoRepo,
                getRestaurants: self.userRepo.getMyPosts
            )
        ]

        userInfoView = UIView.newAutoLayoutView()
        userNameLabel = UILabel.newAutoLayoutView()
        logoutButton = UIButton(type: UIButtonType.System)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        myContentSegmentedControl = UISegmentedControl(
            items: ["My Posts", "My Likes"]
        )
        pageViewController = UIPageViewController(
            transitionStyle: .Scroll,
            navigationOrientation: .Horizontal,
            options: [:]
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Profile"
        view.backgroundColor = UIColor.whiteColor()

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()

        userRepo.fetchCurrentUserName()
            .onSuccess { [unowned self] userName in
                self.userNameLabel.text = userName
            }
    }

    // MARK: - View Setup
    private func configureNavigationBar() {}

    private func addSubviews() {
        userInfoView.addSubview(userNameLabel)
        userInfoView.addSubview(logoutButton)
        userInfoView.addSubview(myContentSegmentedControl)

        view.addSubview(userInfoView)
        view.addSubview(pageViewController.view)
    }

    private func configureSubviews() {
        logoutButton.setTitleColor(.whiteColor(), forState: .Normal)
        logoutButton.backgroundColor = UIColor.grayColor()
        logoutButton.setTitle("Logout", forState: .Normal)
        logoutButton.addTarget(
            self,
            action: #selector(ProfileViewController.didTapLogoutButton(_:)),
            forControlEvents: .TouchUpInside
        )

        myContentSegmentedControl.addTarget(
            self,
            action: #selector(ProfileViewController.didChangeSelectedSegment(_:)),
            forControlEvents: .ValueChanged
        )
        myContentSegmentedControl.selectedSegmentIndex = 0

        pageViewController.setViewControllers(
            viewControllers,
            direction: .Forward,
            animated: true,
            completion: nil
        )
    }

    private func addConstraints() {
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

        myContentSegmentedControl.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoutButton, withOffset: 8)
        myContentSegmentedControl.autoPinEdgeToSuperviewEdge(.Left)
        myContentSegmentedControl.autoPinEdgeToSuperviewEdge(.Right)
        myContentSegmentedControl.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 2)

        pageViewController.view.autoPinEdge(.Top, toEdge: .Bottom, ofView: userInfoView)
        pageViewController.view.autoPinEdgeToSuperviewEdge(.Left)
        pageViewController.view.autoPinEdgeToSuperviewEdge(.Right)
        pageViewController.view.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Actions
    @objc private func didTapLogoutButton(sender: UIButton?) {
        sessionRepo.deleteToken()
        router.showLoginScreen()
    }

    @objc private func didChangeSelectedSegment(sender: UISegmentedControl) {
        currentPage = sender.selectedSegmentIndex

        let getRestaurants: () -> Future<[Restaurant], RepoError>

        if (currentPage == 0) {
            getRestaurants = userRepo.getMyPosts
        } else {
            getRestaurants = userRepo.getMyLikes
        }

        let viewController = MyRestaurantListViewController(
            reloader: reloader,
            photoRepo: photoRepo,
            getRestaurants: getRestaurants
        )

        pageViewController.setViewControllers(
            [viewController],
            direction: .Forward,
            animated: false,
            completion: nil
        )
    }
}
