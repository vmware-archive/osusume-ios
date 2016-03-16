import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class ProfileViewControllerTest: XCTestCase {
    var fakeUserRepo: FakeUserRepo!
    var fakeRouter: FakeRouter!
    var fakeSessionRepo: FakeSessionRepo!
    var fakePostRepo: FakePostRepo!
    var profileVC: ProfileViewController!

    override func setUp() {
        fakeUserRepo = FakeUserRepo()
        fakeRouter = FakeRouter()
        fakeSessionRepo = FakeSessionRepo()
        fakePostRepo = FakePostRepo()

        profileVC = ProfileViewController(
            router: fakeRouter,
            userRepo: fakeUserRepo,
            sessionRepo: fakeSessionRepo,
            postRepo: fakePostRepo
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

    func test_viewDidLoad_fetchsUsersPosts() {
        let promise = Promise<[Restaurant], RepoError>()
        fakePostRepo.getAll_returnValue = promise.future

        profileVC.view.setNeedsLayout()

        expect(self.fakePostRepo.getAll_wasCalled).to(equal(true))
        let expectedRestaurant = RestaurantFixtures.newRestaurant(name: "Miya's Café")
        promise.success([expectedRestaurant])
        NSRunLoop.osu_advance()

        expect(self.profileVC.posts).to(equal([expectedRestaurant]))
    }

    //MARK: Actions
    func test_tapLogout_logsOutUser() {
        profileVC.view.setNeedsLayout()

        profileVC.logoutButton.sendActionsForControlEvents(.TouchUpInside)
        expect(self.fakeSessionRepo.deleteTokenWasCalled).to(beTrue())
        expect(self.fakeRouter.loginScreenIsShowing).to(beTrue())
    }
}