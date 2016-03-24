//import Foundation
import UIKit
import BrightFutures

class LoginViewController: UIViewController {
    unowned let router : Router
    let userRepo : UserRepo
    let sessionRepo: SessionRepo

    // MARK: - Initializers
    init(router: Router, repo: UserRepo, sessionRepo: SessionRepo) {
        self.router = router
        self.userRepo = repo
        self.sessionRepo = sessionRepo

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Elements
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .Line
        textField.placeholder = "Email"
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .Line
        textField.placeholder = "Password"
        return textField
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton.newAutoLayoutView()

        button.setTitle("Login", forState: .Normal)
        button.backgroundColor = UIColor.grayColor()
        button.addTarget(
            self,
            action: Selector("didTapLoginButton:"),
            forControlEvents: .TouchUpInside
        )
        return button
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)

        view.backgroundColor = UIColor.whiteColor()

        emailTextField.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        emailTextField.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        emailTextField.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

        passwordTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailTextField, withOffset: 10.0)

        passwordTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: emailTextField)
        passwordTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: emailTextField)

        loginButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordTextField)
        loginButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)
    }

    override func viewDidAppear(animated: Bool) {
        emailTextField.becomeFirstResponder()
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.didTapLoginButton(loginButton)
        return true
    }
}
