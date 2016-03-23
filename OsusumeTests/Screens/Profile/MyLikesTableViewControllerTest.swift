import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class MyLikesTableViewControllerTest: XCTestCase {
    var fakeReloader: FakeReloader!
    var fakePhotoRepo: FakePhotoRepo!
    var fakeUserRepo: FakeUserRepo!
    var myLikesTVC: MyLikesTableViewController!

    override func setUp() {
        fakeReloader = FakeReloader()
        fakePhotoRepo = FakePhotoRepo()
        fakeUserRepo = FakeUserRepo()

        myLikesTVC = MyLikesTableViewController(
            userRepo: fakeUserRepo,
            reloader: fakeReloader,
            photoRepo: fakePhotoRepo
        )
    }

    func test_viewDidLoad_fetchsUsersPosts() {
        let promise = Promise<[Restaurant], RepoError>()
        fakeUserRepo.getMyLikes_returnValue = promise.future
        myLikesTVC.view.setNeedsLayout()

        expect(self.fakeUserRepo.getMyLikes_wasCalled).to(equal(true))
        let expectedRestaurant = RestaurantFixtures.newRestaurant(name: "Miya's Café")
        promise.success([expectedRestaurant])

        waitForFutureToComplete(promise.future)

        expect(self.myLikesTVC.restaurantDataSource.myPosts).to(equal([expectedRestaurant]))
        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
    }

    func test_tableView_configuresCellCount() {
        let restaurants = [RestaurantFixtures.newRestaurant()]
        myLikesTVC.restaurantDataSource.myPosts = restaurants

        let numberOfRows = myLikesTVC.restaurantDataSource.tableView(
            UITableView(),
            numberOfRowsInSection: 0
        )

        expect(numberOfRows).to(equal(restaurants.count))
    }

    func test_tableView_loadsImageFromPhotoUrl() {
        let restaurants = [RestaurantFixtures.newRestaurant()]
        myLikesTVC.restaurantDataSource.myPosts = restaurants
        myLikesTVC.view.setNeedsLayout()

        let promise = Promise<UIImage, RepoError>()
        fakePhotoRepo.loadImageFromUrl_returnValue = promise.future

        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = myLikesTVC.restaurantDataSource.tableView(
            myLikesTVC.tableView,
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
    
}
