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
    var fetchCurrentUserNamePromise = Promise<String, RepoError>()
    let fetchLikesPromise = Promise<[Restaurant], RepoError>()

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

        fakeUserRepo.fetchCurrentUserName_returnValue = fetchCurrentUserNamePromise.future
        profileVC.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        expect(self.profileVC.title).to(equal("My Profile"))
    }

    func test_viewDidLoad_displaysUsername() {
        fetchCurrentUserNamePromise.success("A")


        waitForFutureToComplete(fetchCurrentUserNamePromise.future)
        expect(self.profileVC.userNameLabel.text).to(equal("A"))
    }

    func test_viewDidLoad_showsLogoutButton() {
        expect(self.profileVC.logoutButton).toNot(beNil())
        expect(self.profileVC.logoutButton.titleLabel?.text).to(equal("Logout"))
    }

    func test_viewDidLoad_showsSegmentedControl() {
        let segmentedControl = profileVC.myContentSegmentedControl

        expect(segmentedControl.selectedSegmentIndex).to(equal(0))
        expect(segmentedControl.titleForSegmentAtIndex(0)).to(equal("My Posts"))
        expect(segmentedControl.titleForSegmentAtIndex(1)).to(equal("My Likes"))
    }

    func test_viewDidLoad_defaultsToMyPostTableViewController() {
        let pageViewController = profileVC.pageViewController


        expect(self.profileVC.currentPage).to(equal(0))
        expect(pageViewController.viewControllers?.first).to(beAKindOf(MyRestaurantListViewController))
    }

    func test_viewDidLoad_retrievesMyPostedRestaurants() {
        let likedRestaurantListVC =
            profileVC.pageViewController.viewControllers?.first
                as! MyRestaurantListViewController

        
        expect(likedRestaurantListVC.getRestaurants())
            .to(beIdenticalTo(fakeUserRepo.getMyPosts_returnValue))
    }

    func test_tappingSegmentedControl_selectsCurrentPage() {
        let segmentedControl = profileVC.myContentSegmentedControl
        segmentedControl.selectedSegmentIndex = 1


        segmentedControl.sendActionsForControlEvents(.ValueChanged)

        let pageViewController = profileVC.pageViewController
        expect(pageViewController.viewControllers?.first)
            .to(beAKindOf(MyRestaurantListViewController))
        expect(self.profileVC.currentPage).to(equal(1))
    }

    func test_tappingLikeSegmentedControlButton_retrievesLikedRestaurants() {
        let segmentedControl = profileVC.myContentSegmentedControl
        segmentedControl.selectedSegmentIndex = 1


        segmentedControl.sendActionsForControlEvents(.ValueChanged)


        let likedRestaurantListVC =
            profileVC.pageViewController.viewControllers?.first
                as! MyRestaurantListViewController

        expect(likedRestaurantListVC.getRestaurants())
            .to(beIdenticalTo(fakeUserRepo.getMyLikes_returnValue))
    }

    func test_restaurantSelection_showsRestaurantDetailScreen() {
        profileVC.myRestaurantSelected(RestaurantFixtures.newRestaurant())

        expect(self.fakeRouter.restaurantDetailScreenIsShowing).to(equal(true))
    }

    // MARK: Actions
    func test_tapLogout_logsOutUser() {
        profileVC.logoutButton.sendActionsForControlEvents(.TouchUpInside)


        expect(self.fakeSessionRepo.deleteAuthenticatedUser_wasCalled).to(beTrue())
        expect(self.fakeRouter.loginScreenIsShowing).to(beTrue())
    }
}