import XCTest
import Nimble
import BrightFutures
import Result
@testable import Osusume

class RestaurantListViewControllerTest: XCTestCase {

    var restaurantListVC: RestaurantListViewController!
    var fakeRouter: FakeRouter!
    var fakeRestaurantRepo: FakeRestaurantRepo!
    var fakeSessionRepo: FakeSessionRepo!
    var fakeReloader: FakeReloader!
    var fakePhotoRepo: FakePhotoRepo!

    override func setUp() {
        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakeSessionRepo = FakeSessionRepo()
        fakeReloader = FakeReloader()
        fakePhotoRepo = FakePhotoRepo()

        fakeRestaurantRepo.allRestaurants = [RestaurantFixtures.newRestaurant()]

        restaurantListVC = RestaurantListViewController(
            router: fakeRouter,
            repo: fakeRestaurantRepo,
            sessionRepo: fakeSessionRepo,
            reloader: fakeReloader,
            photoRepo: fakePhotoRepo
        )
    }

    // MARK: - UITableView
    func test_tableView_displaysListOfRestaurants() {
        restaurantListVC.view.setNeedsLayout()

        let tableView = restaurantListVC.tableView

        expect(tableView.numberOfSections).to(equal(1))
        expect(tableView.numberOfRowsInSection(0)).to(equal(1))
    }

    func test_tableView_loadsImageFromPhotoUrl() {
        restaurantListVC.view.setNeedsLayout()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)

        let promise = Promise<UIImage, RepoError>()
        fakePhotoRepo.loadImageFromUrl_returnValue = promise.future

        let cell = restaurantListVC.tableView(
            restaurantListVC.tableView,
            cellForRowAtIndexPath: indexPath
        ) as? RestaurantTableViewCell

        expect(self.fakePhotoRepo.loadImageFromUrl_wasCalled).to(equal(true))
        expect(self.fakePhotoRepo.loadImageFromUrl_args.url)
            .to(equal(NSURL(string: "http://www.example.com/cat.jpg")!))
        expect(self.fakePhotoRepo.loadImageFromUrl_args.placeholder)
            .to(equal(UIImage(named: "TableCellPlaceholder")!))

        let apple = testImage(named: "appleLogo", imageExtension: "png")
        promise.success(apple)

        waitUntil { done in
            while !promise.future.isCompleted {}
            done()
        }

        expect(cell?.photoImageView.image).to(equal(apple))
    }


    // MARK: View Lifecycle
    func test_viewDidLoad_showsLogoutButton() {
        restaurantListVC.view.setNeedsLayout()

        let leftBarButtonItem = self.restaurantListVC.navigationItem.leftBarButtonItem

        expect(leftBarButtonItem?.title).to(equal("Logout"))
    }

    func test_viewDidLoad_reloadsTableData() {
        restaurantListVC.view.setNeedsLayout()

        let actualTableView = fakeReloader.reload_args as? UITableView

        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
        expect(actualTableView === self.restaurantListVC.tableView).to(equal(true))
    }

    // MARK: Actions
    func test_tappingNewRestaraunt_showsNewRestaurantScreen() {
        restaurantListVC.view.setNeedsLayout()

        let addRestaurantButton = self.restaurantListVC.navigationItem.rightBarButtonItem!

        expect(addRestaurantButton.title).to(equal("add restaurant"))

        tapNavBarButton(addRestaurantButton)

        expect(self.fakeRouter.newRestaurantScreenIsShowing).to(equal(true))
    }

    func test_tappingRestaurant_showsRestaurantDetailScreen() {
        restaurantListVC.didTapRestaurant(1)

        expect(self.fakeRouter.restaurantDetailScreenIsShowing).to(equal(true))
    }

    func test_tappingLogoutButton_callsDeleteTokenSessionRepo_movesUserToLoginScreen() {
        restaurantListVC.view.setNeedsLayout()

        let logoutButton = self.restaurantListVC.navigationItem.leftBarButtonItem!


        tapNavBarButton(logoutButton)


        expect(self.fakeSessionRepo.deleteTokenWasCalled).to(beTrue())
        expect(self.fakeRouter.loginScreenIsShowing).to(beTrue())
    }

}
