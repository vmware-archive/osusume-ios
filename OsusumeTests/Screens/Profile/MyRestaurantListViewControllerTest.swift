import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class MyRestaurantListViewControllerTest: XCTestCase {
    var fakeReloader: FakeReloader!
    var fakePhotoRepo: FakePhotoRepo!
    var myRestaurantListVC: MyRestaurantListViewController!

    override func setUp() {
        fakeReloader = FakeReloader()
        fakePhotoRepo = FakePhotoRepo()

        myRestaurantListVC = MyRestaurantListViewController(
            reloader: fakeReloader,
            photoRepo: fakePhotoRepo,
            getRestaurants: getRestaurants
        )
    }

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

    // MARK: Fake Methods
    var getRestaurants_wasCalled = false
    var getRestaurants_returnValue = Future<[Restaurant], RepoError>()
    private func getRestaurants() -> Future<[Restaurant], RepoError> {
        getRestaurants_wasCalled = true
        return getRestaurants_returnValue
    }
}
