import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class FakeMyRestaurantSelectionDelegate: MyRestaurantSelectionDelegate {
    var myRestaurantSelected_arg = RestaurantFixtures.newRestaurant(id: -1)
    func myRestaurantSelected(myRestaurant: Restaurant) {
        myRestaurantSelected_arg = myRestaurant
    }
}

class MyRestaurantListViewControllerTest: XCTestCase {
    var fakeReloader: FakeReloader!
    var fakePhotoRepo: FakePhotoRepo!
    var myRestaurantListVC: MyRestaurantListViewController!
    var fakeMyRestaurantSelectionDelegate: FakeMyRestaurantSelectionDelegate!

    override func setUp() {
        fakeReloader = FakeReloader()
        fakePhotoRepo = FakePhotoRepo()
        fakeMyRestaurantSelectionDelegate = FakeMyRestaurantSelectionDelegate()

        myRestaurantListVC = MyRestaurantListViewController(
            reloader: fakeReloader,
            photoRepo: fakePhotoRepo,
            myRestaurantSelectionDelegate: fakeMyRestaurantSelectionDelegate,
            getRestaurants: getRestaurants
        )
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_callsGetRestaurants() {
        myRestaurantListVC.view.setNeedsLayout()


        expect(self.getRestaurants_wasCalled).to(equal(true))
    }

    func test_viewDidLoad_registersTableViewCellClass() {
        myRestaurantListVC.view.setNeedsLayout()


        let cell = myRestaurantListVC.tableView.dequeueReusableCellWithIdentifier(
            String(RestaurantTableViewCell.self)
        )


        expect(cell).toNot(beNil())
    }

    func test_viewDidLoad_configuresTableViewDataSourceAndDelegate() {
        myRestaurantListVC.view.setNeedsLayout()


        expect(self.myRestaurantListVC.tableView.dataSource === self.myRestaurantListVC.restaurantListDataSource).to(beTrue())
        expect(self.myRestaurantListVC.tableView.delegate === self.myRestaurantListVC).to(beTrue())
    }

    func test_viewDidLoad_fetchsUsersPosts() {
        let promise = Promise<[Restaurant], RepoError>()
        getRestaurants_returnValue = promise.future
        myRestaurantListVC.view.setNeedsLayout()


        let expectedRestaurant = RestaurantFixtures.newRestaurant(name: "Miya's Café")
        promise.success([expectedRestaurant])
        waitForFutureToComplete(promise.future)


        expect(self.myRestaurantListVC.restaurantListDataSource.restaurants)
            .to(equal([expectedRestaurant]))
    }

    func test_viewDidLoad_reloadsData_onGetRestaurantsSuccess() {
        let promise = Promise<[Restaurant], RepoError>()
        getRestaurants_returnValue = promise.future
        myRestaurantListVC.view.setNeedsLayout()


        promise.success([])
        waitForFutureToComplete(promise.future)


        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
    }

    func test_viewDidLoad_doesNotReloadData_onGetRestaurantsFailure() {
        let promise = Promise<[Restaurant], RepoError>()
        getRestaurants_returnValue = promise.future
        myRestaurantListVC.view.setNeedsLayout()


        promise.failure(RepoError.GetFailed)
        waitForFutureToComplete(promise.future)


        expect(self.fakeReloader.reload_wasCalled).to(equal(false))
    }

    func test_tableView_tappingRestaurant_callsRestaurantSelectDelegate() {
        let restaurantPromise = Promise<[Restaurant], RepoError>()
        getRestaurants_returnValue = restaurantPromise.future

        let restaurantsResult = [
            RestaurantFixtures.newRestaurant(id: 1)
        ]

        myRestaurantListVC.view.setNeedsLayout()
        restaurantPromise.success(restaurantsResult)

        waitForFutureToComplete(getRestaurants_returnValue)


        myRestaurantListVC.tableView(
            myRestaurantListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeMyRestaurantSelectionDelegate.myRestaurantSelected_arg)
            .to(equal(restaurantsResult[0]))
    }

    // MARK: Fake Methods
    var getRestaurants_wasCalled = false
    var getRestaurants_returnValue = Future<[Restaurant], RepoError>()
    private func getRestaurants() -> Future<[Restaurant], RepoError> {
        getRestaurants_wasCalled = true
        return getRestaurants_returnValue
    }
}
