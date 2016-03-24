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

    func test_viewDidLoad_fetchsUsersPosts() {
        let promise = Promise<[Restaurant], RepoError>()
        getRestaurants_returnValue = promise.future
        myRestaurantListVC.view.setNeedsLayout()

        expect(self.getRestaurants_wasCalled).to(equal(true))
        let expectedRestaurant = RestaurantFixtures.newRestaurant(name: "Miya's Café")
        promise.success([expectedRestaurant])

        waitForFutureToComplete(promise.future)

        expect(self.myRestaurantListVC.restaurantDataSource.myPosts).to(equal([expectedRestaurant]))
        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
    }

    func test_tableView_configuresCellCount() {
        let restaurants = [RestaurantFixtures.newRestaurant()]
        myRestaurantListVC.restaurantDataSource.myPosts = restaurants

        let numberOfRows = myRestaurantListVC.restaurantDataSource.tableView(
            UITableView(),
            numberOfRowsInSection: 0
        )

        expect(numberOfRows).to(equal(restaurants.count))
    }

    func test_tableView_loadsImageFromPhotoUrl() {
        let restaurants = [RestaurantFixtures.newRestaurant()]
        myRestaurantListVC.restaurantDataSource.myPosts = restaurants
        myRestaurantListVC.view.setNeedsLayout()

        let promise = Promise<UIImage, RepoError>()
        fakePhotoRepo.loadImageFromUrl_returnValue = promise.future

        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = myRestaurantListVC.restaurantDataSource.tableView(
            myRestaurantListVC.tableView,
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

    // MARK: Fake Methods
    var getRestaurants_wasCalled = false
    var getRestaurants_returnValue = Future<[Restaurant], RepoError>()
    private func getRestaurants() -> Future<[Restaurant], RepoError> {
        getRestaurants_wasCalled = true
        return getRestaurants_returnValue
    }
}
