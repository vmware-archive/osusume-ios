import XCTest
import Nimble

@testable import Osusume

class LoginViewControllerTest: XCTestCase {
    var loginVC: LoginViewController!
    let fakeRouter = FakeRouter()
    let fakeUserRepo = FakeUserRepo()
    let fakeSessionRepo = FakeSessionRepo()

    override func setUp() {
        loginVC = LoginViewController(
            router: fakeRouter,
            repo: fakeUserRepo,
            sessionRepo: fakeSessionRepo
        )

        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = loginVC
        window!.makeKeyAndVisible()

        loginVC.view.setNeedsLayout()
    }

    func test_logsInWithEmailAndPassword() {
        UIView.setAnimationsEnabled(false)

        loginVC.emailTextField.text = "test@email.com"
        loginVC.passwordTextField.text = "secret"

        expect(self.fakeUserRepo.submittedEmail).to(beNil())
        expect(self.fakeUserRepo.submittedPassword).to(beNil())

        tapButton(loginVC.loginButton)

        expect(self.fakeUserRepo.submittedEmail).to(equal("test@email.com"))
        expect(self.fakeUserRepo.submittedPassword).to(equal("secret"))

        expect(self.fakeSessionRepo.getToken()).to(equal("token-value"))
        expect(self.fakeRouter.restaurantListScreenIsShowing).to(beTrue())
    }

    func test_emailTextField_isFirstResponder() {
        NSRunLoop.osu_advance()
        expect(self.loginVC.emailTextField.isFirstResponder()).to(beTrue())
    }
}
