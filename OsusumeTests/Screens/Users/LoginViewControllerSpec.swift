import Foundation
import Quick
import Nimble

@testable import Osusume

class LoginViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Login Page") {
            var loginVC: LoginViewController!
            let fakeRouter = FakeRouter()
            let fakeUserRepo = FakeUserRepo()
            let fakeSessionRepo = FakeSessionRepo()

            beforeEach {
                UIView.setAnimationsEnabled(false)

                loginVC = LoginViewController(
                    router: fakeRouter,
                    repo: fakeUserRepo,
                    sessionRepo: fakeSessionRepo
                )

                loginVC.view.layoutSubviews()
            }

            it("makes an API call with email and password") {
                loginVC.emailTextField.text = "test@email.com"
                loginVC.passwordTextField.text = "secret"

                expect(fakeUserRepo.submittedEmail).to(beNil())
                expect(fakeUserRepo.submittedPassword).to(beNil())

                loginVC.loginButton.sendActionsForControlEvents(.TouchUpInside)

                expect(fakeUserRepo.submittedEmail).to(equal("test@email.com"))
                expect(fakeUserRepo.submittedPassword).to(equal("secret"))

                expect(fakeSessionRepo.getToken()).to(equal("token-value"))
                expect(fakeRouter.restaurantListScreenIsShowing).to(beTrue())
            }
        }
    }		
}
