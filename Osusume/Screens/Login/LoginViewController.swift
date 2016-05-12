import BrightFutures

class LoginViewController: UIViewController {
    // MARK: - Properties
    private unowned let router: Router
    private let userRepo: UserRepo
    let sessionRepo: SessionRepo

    // MARK: - View Elements
    let emailTextField: UITextField
    let passwordTextField: UITextField
    let loginButton: UIButton

    // MARK: - Initializers
    init(router: Router, repo: UserRepo, sessionRepo: SessionRepo) {
        self.router = router
        self.userRepo = repo
        self.sessionRepo = sessionRepo

        emailTextField = UITextField()
        passwordTextField = UITextField()
        loginButton = UIButton(type: UIButtonType.System)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        emailTextField.becomeFirstResponder()
    }

    // MARK: - View Setup
    private func configureNavigationBar() {}

    private func addSubviews() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }

    private func configureSubviews() {
        emailTextField.borderStyle = .Line
        emailTextField.autocapitalizationType = .None
        emailTextField.autocorrectionType = .No
        emailTextField.placeholder = "Email"
        emailTextField.delegate = self

        passwordTextField.borderStyle = .Line
        passwordTextField.autocapitalizationType = .None
        passwordTextField.autocorrectionType = .No
        passwordTextField.placeholder = "Password"
        passwordTextField.delegate = self

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.setTitleColor(.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = UIColor.grayColor()
        loginButton.addTarget(
            self,
            action: #selector(LoginViewController.didTapLoginButton(_:)),
            forControlEvents: .TouchUpInside
        )
    }

    private func addConstraints() {
        emailTextField.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        emailTextField.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        emailTextField.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

        passwordTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailTextField, withOffset: 10.0)
        passwordTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: emailTextField)
        passwordTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: emailTextField)

        loginButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordTextField, withOffset: 10.0)
        loginButton.autoPinEdgeToSuperviewEdge(.Left)
        loginButton.autoPinEdgeToSuperviewEdge(.Right)
        loginButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)
    }

    // MARK: - Actions
    @objc private func didTapLoginButton(button: UIButton) {
        userRepo.login(emailTextField.text!, password: passwordTextField.text!)
            .onSuccess(ImmediateExecutionContext) { [unowned self] token in
                self.sessionRepo.setToken(token)
                self.router.showRestaurantListScreen()
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.didTapLoginButton(loginButton)
        return true
    }
}
