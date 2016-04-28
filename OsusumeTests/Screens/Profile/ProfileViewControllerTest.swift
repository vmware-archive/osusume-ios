import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class ProfileViewControllerTest: XCTestCase {
    var fakeUserRepo: FakeUserRepo!
    var fakeRouter: FakeRouter!
    var fakeSessionRepo: FakeSessionRepo!
    var fakePhotoRepo: FakePhotoRepo!
    var fakeReloader: FakeReloader!
    var profileVC: ProfileViewController!

    override func setUp() {
        fakeUserRepo = FakeUserRepo()
        fakeRouter = FakeRouter()
        fakeSessionRepo = FakeSessionRepo()
        fakePhotoRepo = FakePhotoRepo()
        fakeReloader = FakeReloader()

        profileVC = ProfileViewController(
            router: fakeRouter,
            userRepo: fakeUserRepo,
            sessionRepo: fakeSessionRepo,
            photoRepo: fakePhotoRepo,
            reloader: fakeReloader
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

    func test_viewDidLoad_showsSegmentedControl() {
        profileVC.view.setNeedsLayout()

        let segmentedControl = profileVC.myContentSegmentedControl

        expect(segmentedControl.selectedSegmentIndex).to(equal(0))
        expect(segmentedControl.titleForSegmentAtIndex(0)).to(equal("My Posts"))
        expect(segmentedControl.titleForSegmentAtIndex(1)).to(equal("My Likes"))
    }

    func test_viewDidLoad_defaultsToMyPostTableViewController() {
        profileVC.view.setNeedsDisplay()
        let pageViewController = profileVC.pageViewController

        expect(self.profileVC.currentPage).to(equal(0))
        expect(pageViewController.viewControllers?.first).to(beAKindOf(MyRestaurantListViewController))
        expect(self.fakeUserRepo.getMyPosts_wasCalled).to(beTrue())
    }

    func test_tappingSegmentedControl_selectsCurrentPage() {
        profileVC.view.setNeedsLayout()

        let segmentedControl = profileVC.myContentSegmentedControl
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.sendActionsForControlEvents(.ValueChanged)

        let pageViewController = profileVC.pageViewController
        expect(pageViewController.viewControllers?.first)
            .to(beAKindOf(MyRestaurantListViewController))
        expect(self.profileVC.currentPage).to(equal(1))
        expect(self.fakeUserRepo.getMyLikes_wasCalled).to(beTrue())
    }

    // MARK: Actions
    func test_tapLogout_logsOutUser() {
        profileVC.view.setNeedsLayout()

        profileVC.logoutButton.sendActionsForControlEvents(.TouchUpInside)
        expect(self.fakeSessionRepo.deleteTokenWasCalled).to(beTrue())
        expect(self.fakeRouter.loginScreenIsShowing).to(beTrue())
    }
}