import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class ProfileViewControllerTest: XCTestCase {
    var fakeUserRepo: FakeUserRepo!
    var fakeRouter: FakeRouter!
    var fakeSessionRepo: FakeSessionRepo!
    var profileVC: ProfileViewController!

    override func setUp() {
        fakeUserRepo = FakeUserRepo()
        fakeRouter = FakeRouter()
        fakeSessionRepo = FakeSessionRepo()
        profileVC = ProfileViewController(
            router: fakeRouter,
            userRepo: fakeUserRepo,
            sessionRepo: fakeSessionRepo
        )
    }

    // MARK: View Lifecycle
    func test_viewDidLoad_displaysUsername() {
        profileVC.view.setNeedsLayout()

        fakeUserRepo.stringPromise.success("A")
        NSRunLoop.osu_advance()
        expect(self.profileVC.userNameLabel.text).to(equal("A"))
    }

    func test_viewDidLoad_showsLogoutButton() {
        profileVC.view.setNeedsLayout()

        expect(self.profileVC.logoutButton).toNot(beNil())
        expect(self.profileVC.logoutButton.titleLabel?.text).to(equal("Logout"))
    }

    func test_viewDidLoad_showsMyPostsTab() {
        profileVC.view.setNeedsLayout()

        expect(self.profileVC.restaurantsLabel).toNot(beNil())
        expect(self.profileVC.restaurantsLabel.text).to(equal("My Posts"))
    }

    //MARK: Actions
    func test_tapLogout_logsOutUser() {
        profileVC.view.setNeedsLayout()

        profileVC.logoutButton.sendActionsForControlEvents(.TouchUpInside)
        expect(self.fakeSessionRepo.deleteTokenWasCalled).to(beTrue())
        expect(self.fakeRouter.loginScreenIsShowing).to(beTrue())
    }
}