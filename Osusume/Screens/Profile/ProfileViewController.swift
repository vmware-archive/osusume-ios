import Foundation

class ProfileViewController: UIViewController {
    let router: Router
    let userRepo: UserRepo
    let sessionRepo: SessionRepo
    let reloader: Reloader
    let photoRepo: PhotoRepo
    lazy var viewControllers: [UIViewController] = {
        let viewControllers = [
            MyPostTableViewController(
                userRepo: self.userRepo,
                reloader: self.reloader,
                photoRepo: self.photoRepo
            )
        ]

        return viewControllers
    }()

    private(set) var currentPage: Int = 0

    //MARK: - View Elements
    let userInfoView: UIView
    let userNameLabel: UILabel
    let logoutButton: UIButton
    let myContentSegmentedControl: UISegmentedControl
    let pageViewController: UIPageViewController

    init(router: Router,
        userRepo: UserRepo,
        sessionRepo: SessionRepo,
        photoRepo: PhotoRepo,
        reloader: Reloader)
    {
        self.router = router
        self.userRepo = userRepo
        self.sessionRepo = sessionRepo
        self.reloader = reloader
        self.photoRepo = photoRepo

        userInfoView = UIView.newAutoLayoutView()
        userNameLabel = UILabel.newAutoLayoutView()
        logoutButton = UIButton.newAutoLayoutView()
        myContentSegmentedControl = UISegmentedControl(items:
            ["My Posts", "My Likes"]
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

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Profile"

        myContentSegmentedControl.addTarget(
            self,
            action: Selector("didChangeSelectedSegment:"),
            forControlEvents: .ValueChanged
        )
        myContentSegmentedControl.selectedSegmentIndex = 0

        pageViewController.setViewControllers(
            viewControllers,
            direction: .Forward,
            animated: true,
            completion: nil
        )

        logoutButton.backgroundColor = UIColor.grayColor()
        logoutButton.setTitle("Logout", forState: .Normal)
        logoutButton.addTarget(
            self,
            action: Selector("didTapLogoutButton:"),
            forControlEvents: .TouchUpInside
        )

        userInfoView.addSubview(userNameLabel)
        userInfoView.addSubview(logoutButton)
        userInfoView.addSubview(myContentSegmentedControl)
        view.addSubview(userInfoView)
        view.addSubview(pageViewController.view)

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

        myContentSegmentedControl.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoutButton, withOffset: 8)
        myContentSegmentedControl.autoPinEdgeToSuperviewEdge(.Left)
        myContentSegmentedControl.autoPinEdgeToSuperviewEdge(.Right)
        myContentSegmentedControl.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 2)

        pageViewController.view.autoPinEdge(.Top, toEdge: .Bottom, ofView: userInfoView)
        pageViewController.view.autoPinEdgeToSuperviewEdge(.Left)
        pageViewController.view.autoPinEdgeToSuperviewEdge(.Right)
        pageViewController.view.autoPinEdgeToSuperviewEdge(.Bottom)

        userRepo.fetchCurrentUserName()
            .onSuccess { [unowned self] userName in
                self.userNameLabel.text = userName
            }
    }

    //MARK: - Actions
    func didTapLogoutButton(sender: UIButton?) {
        sessionRepo.deleteToken()
        router.showLoginScreen()
    }

    func didChangeSelectedSegment(sender: UISegmentedControl) {
        currentPage = sender.selectedSegmentIndex

        let viewController: UIViewController!

        switch currentPage {
            case 0:
                viewController = MyPostTableViewController(
                    userRepo: self.userRepo,
                    reloader: self.reloader,
                    photoRepo: self.photoRepo
                )

            default:
                viewController = MyLikesTableViewController(
                    userRepo: self.userRepo,
                    reloader: self.reloader,
                    photoRepo: self.photoRepo
                )
        }

        pageViewController.setViewControllers(
            [viewController],
            direction: .Forward,
            animated: false,
            completion: nil
        )
    }
}
