import XCTest
import Nimble
import BrightFutures

@testable import Osusume

class LoginViewControllerTest: XCTestCase {
    var loginVC: LoginViewController!
    let fakeRouter = FakeRouter()
    let fakeUserRepo = FakeUserRepo()
    let fakeSessionRepo = FakeSessionRepo()
    let loginPromise = Promise<AuthenticatedUser, RepoError>()

    override func setUp() {
        loginVC = LoginViewController(
            router: fakeRouter,
            repo: fakeUserRepo,
            sessionRepo: fakeSessionRepo
        )

        configureUIWindowWithRootViewController(loginVC)
        loginVC.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        expect(self.loginVC.title).to(equal("Osusume"))
    }

    func test_logsInWithEmailAndPassword() {
        UIView.setAnimationsEnabled(false)
        fakeUserRepo.login_returnValue = loginPromise.future


        loginVC.emailTextField.text = "test@email.com"
        loginVC.passwordTextField.text = "secret"
        tapButton(loginVC.loginButton)


        loginPromise.success(
            AuthenticatedUser(id: 1, email: "email", token: "token", name: "Danny")
        )
        waitForFutureToComplete(fakeUserRepo.login_returnValue)

        expect(self.fakeUserRepo.login_args.email).to(equal("test@email.com"))
        expect(self.fakeUserRepo.login_args.password).to(equal("secret"))
    }

    func test_tappingLoginButton_callsSetAuthenticatedUser() {
        UIView.setAnimationsEnabled(false)
        fakeUserRepo.login_returnValue = loginPromise.future


        tapButton(loginVC.loginButton)


        let authenticatedUser = AuthenticatedUser(id: 1, email: "email", token: "token", name: "Danny")
        loginPromise.success(authenticatedUser)
        waitForFutureToComplete(fakeUserRepo.login_returnValue)

        expect(self.fakeSessionRepo.setAuthenticatedUser_arg).to(equal(authenticatedUser))
    }

    func test_tappingLoginButton_showsRestaurantListWhenLoginSuccess() {
        UIView.setAnimationsEnabled(false)
        fakeUserRepo.login_returnValue = loginPromise.future


        tapButton(loginVC.loginButton)

        loginPromise.success(
            AuthenticatedUser(id: 1, email: "email", token: "token", name: "Danny")
        )
        waitForFutureToComplete(fakeUserRepo.login_returnValue)


        expect(self.fakeRouter.restaurantListScreenIsShowing).to(beTrue())
    }

    func test_emailTextField_isFirstResponder() {
        NSRunLoop.osu_advance()
        expect(self.loginVC.emailTextField.isFirstResponder()).to(beTrue())
    }
}
