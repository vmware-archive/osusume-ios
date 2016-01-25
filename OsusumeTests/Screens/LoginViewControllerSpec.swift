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

            beforeEach {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                repo = FakeUserRepo()
                subject = LoginViewController(router: router, repo: repo)
                subject.view.layoutSubviews()
            }

            it("makes an API call with email and password") {
                subject.emailTextField.text = "test@email.com"
                subject.passwordTextField.text = "secret"

                expect(repo.submittedEmail).to(beNil())
                expect(repo.submittedPassword).to(beNil())

                subject.submitButton.sendActionsForControlEvents(.TouchUpInside)

                expect(repo.submittedEmail).to(equal("test@email.com"))
                expect(repo.submittedPassword).to(equal("secret"))

            }
        }
    }
}
