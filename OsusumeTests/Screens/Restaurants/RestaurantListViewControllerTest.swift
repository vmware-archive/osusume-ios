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
            reloader: fakeReloader,
            photoRepo: fakePhotoRepo
        )
    }

    // MARK: - UITableView
    func test_tableView_loadsImageFromPhotoUrl() {
        restaurantListVC.view.setNeedsLayout()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        restaurantListVC.restaurantListDataSource.updateRestaurants([RestaurantFixtures.newRestaurant()])


        let promise = Promise<UIImage, RepoError>()
        fakePhotoRepo.loadImageFromUrl_returnValue = promise.future

        let cell = restaurantListVC.restaurantListDataSource.tableView(
            restaurantListVC.tableView,
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

    // MARK: View Lifecycle
    func test_viewDidLoad_showsProfileButton() {
        restaurantListVC.view.setNeedsLayout()

        let leftBarButtonItem = self.restaurantListVC.navigationItem.leftBarButtonItem

        expect(leftBarButtonItem?.title).to(equal("Profile"))
    }

    func test_viewDidLoad_registersTableViewCellClass() {
        restaurantListVC.view.setNeedsLayout()


        let cell = restaurantListVC.tableView.dequeueReusableCellWithIdentifier(
            String(RestaurantTableViewCell.self)
        )


        expect(cell).toNot(beNil())
    }

    func test_viewDidLoad_configuresTableViewDataSourceAndDelegate() {
        restaurantListVC.view.setNeedsLayout()


        expect(self.restaurantListVC.tableView.dataSource === self.restaurantListVC.restaurantListDataSource).to(beTrue())
        expect(self.restaurantListVC.tableView.delegate === self.restaurantListVC).to(beTrue())
    }

    func test_viewDidAppear_reloadsTableData() {
        restaurantListVC.view.setNeedsLayout()
        restaurantListVC.viewWillAppear(false)


        expect(self.fakeReloader.reload_wasCalled).to(equal(true))


        let actualTableView = fakeReloader.reload_args as? UITableView
        expect(actualTableView === self.restaurantListVC.tableView).to(equal(true))
    }

    func test_viewDidAppear_retrievesRestaurants() {
        restaurantListVC.view.setNeedsLayout()
        restaurantListVC.viewWillAppear(false)


        expect(self.fakeRestaurantRepo.getAll_wasCalled).to(beTrue())
    }

    // MARK: Actions
    func test_tappingNewRestaraunt_showsNewRestaurantScreen() {
        restaurantListVC.view.setNeedsLayout()

        let addRestaurantButton = self.restaurantListVC.navigationItem.rightBarButtonItem!

        expect(addRestaurantButton.title).to(equal("Add restaurant"))

        tapNavBarButton(addRestaurantButton)

        expect(self.fakeRouter.newRestaurantScreenIsShowing).to(equal(true))
    }

    func test_tappingRestaurant_showsRestaurantDetailScreen() {
        restaurantListVC.restaurantListDataSource.updateRestaurants([RestaurantFixtures.newRestaurant()])
        restaurantListVC.tableView(
            restaurantListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )

        expect(self.fakeRouter.restaurantDetailScreenIsShowing).to(equal(true))
    }

    func test_tappingProfileButton_showsProfileScreen() {
        restaurantListVC.view.setNeedsLayout()

        let profileButton = self.restaurantListVC.navigationItem.leftBarButtonItem!

        tapNavBarButton(profileButton)

        expect(self.fakeRouter.profileScreenIsShowing).to(beTrue())
    }
}
