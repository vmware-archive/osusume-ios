import Foundation

class ProfileViewController: UIViewController {
    let router: Router
    let repo: UserRepo
    let sessionRepo: SessionRepo

    //MARK: - View Elements
    let userNameLabel: UILabel
    let logoutButton: UIButton
    let restaurantsLabel: UILabel
    let restaurantsTableView: UITableView

    init(router: Router, repo: UserRepo, sessionRepo: SessionRepo) {
        self.router = router
        self.repo = repo
        self.sessionRepo = sessionRepo

        logoutButton = UIButton.newAutoLayoutView()
        userNameLabel = UILabel.newAutoLayoutView()
        restaurantsLabel = UILabel.newAutoLayoutView()
        restaurantsTableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
        view.addSubview(restaurantsTableView)

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

        restaurantsTableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantsLabel)
        restaurantsTableView.autoPinEdgeToSuperviewEdge(.Leading)
        restaurantsTableView.autoPinEdgeToSuperviewEdge(.Trailing)
        restaurantsTableView.autoPinEdgeToSuperviewEdge(.Bottom)

        repo.fetchCurrentUserName().onSuccess(callback: {userName in
            self.userNameLabel.text = userName
        })
    }

    //MARK: - Actions
    func didTapLogoutButton(sender: UIButton?) {
        sessionRepo.deleteToken()
        router.showLoginScreen()
    }
}