import Foundation
import Quick
import Nimble

@testable import Osusume

class LoginViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Login Page") {
            var subject: LoginViewController!
            var router: FakeRouter!
            var repo: FakeUserRepo!
            var sessionRepo: SessionRepo!

            beforeEach {
                UIView.setAnimationsEnabled(false)

                router = FakeRouter()
                repo = FakeUserRepo()
                sessionRepo = SessionRepo()

                subject = LoginViewController(router: router, repo: repo, sessionRepo: sessionRepo)
                subject.view.layoutSubviews()
                sessionRepo.deleteToken()
            }

            it("makes an API call with email and password") {
                subject.emailTextField.text = "test@email.com"
                subject.passwordTextField.text = "secret"

                expect(repo.submittedEmail).to(beNil())
                expect(repo.submittedPassword).to(beNil())

                subject.loginButton.sendActionsForControlEvents(.TouchUpInside)

                expect(repo.submittedEmail).to(equal("test@email.com"))
                expect(repo.submittedPassword).to(equal("secret"))
                expect(subject.sessionRepo.getToken()).to(equal("token-value"))
            }
        }
    }
}
