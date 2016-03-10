import Foundation

class ProfileViewController: UIViewController {
    let router: Router
    let repo: UserRepo
    let sessionRepo: SessionRepo

    //MARK: - View Elements
    let userNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var logoutButton: UIButton = {
        let button = UIButton.newAutoLayoutView()
        button.backgroundColor = UIColor.grayColor()
        button.setTitle("Logout", forState: .Normal)
        button.addTarget(
            self,
            action: Selector("didTapLogoutButton:"),
            forControlEvents: .TouchUpInside
        )
        return button
    }()


    init(router: Router, repo: UserRepo, sessionRepo: SessionRepo) {
        self.router = router
        self.repo = repo
        self.sessionRepo = sessionRepo

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Profile"

        view.addSubview(userNameLabel)
        view.addSubview(logoutButton)

        view.backgroundColor = UIColor.whiteColor()

        userNameLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        userNameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        userNameLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 100.0)

        logoutButton.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        logoutButton.autoPinEdge(.Leading, toEdge: .Trailing, ofView: userNameLabel)
        logoutButton.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

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