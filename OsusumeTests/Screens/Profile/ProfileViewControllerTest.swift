import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class ProfileViewControllerTest: XCTestCase {
    var fakeUserRepo: FakeUserRepo!
    var fakeRouter: FakeRouter!
    var fakeSessionRepo: FakeSessionRepo!
    var fakePostRepo: FakePostRepo!
    var fakePhotoRepo: FakePhotoRepo!
    var fakeReloader: FakeReloader!
    var profileVC: ProfileViewController!

    override func setUp() {
        fakeUserRepo = FakeUserRepo()
        fakeRouter = FakeRouter()
        fakeSessionRepo = FakeSessionRepo()
        fakePostRepo = FakePostRepo()
        fakePhotoRepo = FakePhotoRepo()
        fakeReloader = FakeReloader()

        profileVC = ProfileViewController(
            router: fakeRouter,
            userRepo: fakeUserRepo,
            sessionRepo: fakeSessionRepo,
            postRepo: fakePostRepo,
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

        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
        expect(self.profileVC.restaurantDataSource.restaurants).to(equal([expectedRestaurant]))
    }

    func test_tableView_configuresCellCount() {
        let restaurants = [RestaurantFixtures.newRestaurant()]
        profileVC.restaurantDataSource.restaurants = restaurants

        let numberOfRows = profileVC.restaurantDataSource.tableView(
            UITableView(),
            numberOfRowsInSection: 0
        )

        expect(numberOfRows).to(equal(restaurants.count))
    }

    func test_tableView_loadsImageFromPhotoUrl() {
        let restaurants = [RestaurantFixtures.newRestaurant()]
        profileVC.restaurantDataSource.restaurants = restaurants

        profileVC.view.setNeedsLayout()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)

        let promise = Promise<UIImage, RepoError>()
        fakePhotoRepo.loadImageFromUrl_returnValue = promise.future

        let cell = profileVC.restaurantDataSource.tableView(
            profileVC.tableView,
            cellForRowAtIndexPath: indexPath
            ) as? RestaurantTableViewCell

        let placeholderImage = UIImage(named: "TableCellPlaceholder")!
        expect(cell?.photoImageView.image).to(equal(placeholderImage))

        expect(self.fakePhotoRepo.loadImageFromUrl_wasCalled).to(equal(true))
        expect(self.fakePhotoRepo.loadImageFromUrl_args)
            .to(equal(NSURL(string: "http://www.example.com/cat.jpg")!))

        let apple = testImage(named: "appleLogo", imageExtension: "png")
        promise.success(apple)
        waitForFutureToComplete(promise.future)

        expect(cell?.photoImageView.image).to(equal(apple))
    }


    //MARK: Actions
    func test_tapLogout_logsOutUser() {
        profileVC.view.setNeedsLayout()

        profileVC.logoutButton.sendActionsForControlEvents(.TouchUpInside)
        expect(self.fakeSessionRepo.deleteTokenWasCalled).to(beTrue())
        expect(self.fakeRouter.loginScreenIsShowing).to(beTrue())
    }

}