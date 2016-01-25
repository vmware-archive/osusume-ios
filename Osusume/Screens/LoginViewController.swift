//import Foundation
import UIKit

class LoginViewController: UIViewController {
    unowned let router : Router
    let repo : UserRepo

    //MARK: - Initializers
    init(router: Router, repo: UserRepo) {
        self.router = router
        self.repo = repo

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View Elements
    let emailLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Email"
        return label
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .Line
        return textField
    }()

    let passwordLabel : UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Password"
        return label
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .Line
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

        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)

        view.backgroundColor = UIColor.whiteColor()

        emailLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        emailLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
        emailLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)

        emailTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailLabel)
        emailTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: emailLabel)
        emailTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: emailLabel)

        passwordLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailTextField)
        passwordLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: emailLabel)
        passwordLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: emailLabel)

        passwordTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordLabel)
        passwordTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: emailLabel)
        passwordTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: emailLabel)

        submitButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordTextField)
        submitButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)
    }

    //MARK: - Actions
    @objc private func didTapSubmitButton(button: UIButton) {
        repo.login(emailTextField.text!, password: passwordTextField.text!)
    }
}