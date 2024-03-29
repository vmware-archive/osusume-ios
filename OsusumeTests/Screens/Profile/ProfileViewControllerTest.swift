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
    let fetchLikesPromise = Promise<[Restaurant], RepoError>()
    var callToActionCallback_called = false

    override func setUp() {
        fakeUserRepo = FakeUserRepo()
        fakeRouter = FakeRouter()
        fakeSessionRepo = FakeSessionRepo()
        fakePhotoRepo = FakePhotoRepo()
        fakeReloader = FakeReloader()

        fakeSessionRepo.getAuthenticatedUser_returnValue = AuthenticatedUser(
            id: 1, email: "danny@gmail.com", token: "some-token-value", name: "Danny"
        )

        profileVC = ProfileViewController(
            router: fakeRouter,
            userRepo: fakeUserRepo,
            sessionRepo: fakeSessionRepo,
            photoRepo: fakePhotoRepo,
            reloader: fakeReloader
        )

        profileVC.view.setNeedsLayout()
    }

    override func tearDown() {
        callToActionCallback_called = false
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        expect(self.profileVC.title).to(equal("My Profile"))
    }

    func test_viewDidLoad_displaysUsername() {
        expect(self.profileVC.userNameLabel.text).to(equal("Danny"))
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
        let myPostsRestaurantListVC =
            profileVC.pageViewController.viewControllers?.first
                as! MyRestaurantListViewController


        expect(myPostsRestaurantListVC.getRestaurants())
            .to(beIdenticalTo(fakeUserRepo.getMyPosts_returnValue))
    }

    func test_viewDidLoad_setsSelfAsDelegateForEmptyStateView() {
        let myPostsRestaurantListVC =
            profileVC.pageViewController.viewControllers?.first
                as! MyRestaurantListViewController
        let emptyStateView = myPostsRestaurantListVC.emptyStateView

        expect(emptyStateView.delegate).to(beIdenticalTo(profileVC))
    }

    func test_tappingSegmentedControl_updatesThePageViewControllersVCs() {
        let segmentedControl = profileVC.myContentSegmentedControl
        segmentedControl.selectedSegmentIndex = 1


        segmentedControl.sendActionsForControlEvents(.ValueChanged)

        expect(self.profileVC.currentPage).to(equal(1))
    }

    func test_tappingLikeSegmentedControlButton_configuresLikesListVC() {
        let segmentedControl = profileVC.myContentSegmentedControl
        segmentedControl.selectedSegmentIndex = 1


        segmentedControl.sendActionsForControlEvents(.ValueChanged)


        let likedRestaurantListVC =
            profileVC.pageViewController.viewControllers?.first
                as! MyRestaurantListViewController

        expect(likedRestaurantListVC.getRestaurants())
            .to(beIdenticalTo(fakeUserRepo.getMyLikes_returnValue))
        expect(likedRestaurantListVC.emptyStateView.callToActionLabel.text)
            .to(equal("No restaurant yet." +
                "\nPlease like your favorite restaurant!"))
        expect(likedRestaurantListVC.emptyStateView.callToActionButton.hidden)
            .to(equal(true))
    }

    func test_tappingPostSegmentedControlButton_configuresPostsListVC() {
        let segmentedControl = profileVC.myContentSegmentedControl
        segmentedControl.selectedSegmentIndex = 0


        segmentedControl.sendActionsForControlEvents(.ValueChanged)


        let postsRestaurantListVC =
            profileVC.pageViewController.viewControllers?.first
                as! MyRestaurantListViewController

        expect(postsRestaurantListVC.getRestaurants())
            .to(beIdenticalTo(fakeUserRepo.getMyPosts_returnValue))
        expect(postsRestaurantListVC.emptyStateView.callToActionLabel.text)
            .to(equal("No restaurant yet." +
                "\nPlease share your favorite restaurant " +
                "\nwith other pivots"))
    }

    func test_restaurantSelection_showsRestaurantDetailScreen() {
        profileVC.myRestaurantSelected(RestaurantFixtures.newRestaurant())

        expect(self.fakeRouter.restaurantDetailScreenIsShowing).to(equal(true))
    }

    // MARK: Actions
    func test_tapLogout_logsOutUser() {
        profileVC.logoutButton.sendActionsForControlEvents(.TouchUpInside)


        expect(self.fakeSessionRepo.deleteAuthenticatedUser_wasCalled).to(beTrue())
        expect(self.fakeUserRepo.logout_wasCalled).to(beTrue())
        expect(self.fakeRouter.loginScreenIsShowing).to(beTrue())
    }

    // MARK: EmptyStateCallToActionDelegate
    func test_callToActionCallback_displaysAddRestaurantScreen() {
        profileVC.callToActionCallback(UIButton())

        expect(self.fakeRouter.newRestaurantScreenIsShowing).to(beTrue())
    }
}

extension ProfileViewControllerTest: EmptyStateCallToActionDelegate {
    func callToActionCallback(sender: UIButton) {
        callToActionCallback_called = true
    }
}