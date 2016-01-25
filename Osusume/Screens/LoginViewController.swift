//import Foundation
import UIKit
import BrightFutures

class LoginViewController: UIViewController {
    unowned let router : Router
    let repo : UserRepo
    let sessionRepo: SessionRepo

    //MARK: - Initializers
    init(router: Router, repo: UserRepo, sessionRepo: SessionRepo) {
        self.router = router
        self.repo = repo
        self.sessionRepo = sessionRepo

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View Elements
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

    lazy var submitButton: UIButton = {
        let button = UIButton.newAutoLayoutView()

        button.setTitle("Submit", forState: .Normal)
        button.backgroundColor = UIColor.grayColor()
        button.addTarget(self, action: Selector("didTapSubmitButton:"), forControlEvents: .TouchUpInside)
        return button
    }()

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)

        view.backgroundColor = UIColor.whiteColor()

        emailTextField.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        emailTextField.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        emailTextField.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

        passwordTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailTextField, withOffset: 10.0)

        passwordTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: emailTextField)
        passwordTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: emailTextField)

        submitButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordTextField)
        submitButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)
    }

    //MARK: - Actions
    @objc private func didTapSubmitButton(button: UIButton) {
        repo.login(emailTextField.text!, password: passwordTextField.text!)
            .onSuccess(ImmediateExecutionContext) { [unowned self] token in
                self.sessionRepo.setToken(token)
                self.router.showRestaurantListScreen()
        }
    }
}