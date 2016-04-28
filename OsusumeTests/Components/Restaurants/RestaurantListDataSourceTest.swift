import XCTest
import Nimble
@testable import Osusume

class RestaurantListDataSourceTest: XCTestCase {
    var restaurantListDataSource: RestaurantListDataSource!
    let fakePhotoRepo = FakePhotoRepo()
    var restaurants: [Restaurant]!

    override func setUp() {
        restaurantListDataSource = RestaurantListDataSource(photoRepo: fakePhotoRepo)
        restaurants = [
            RestaurantFixtures.newRestaurant(name: "Pizzakaya"),
            RestaurantFixtures.newRestaurant(name: "Savoy")
        ]
        restaurantListDataSource.updateRestaurants(restaurants)
    }

    func test_tableView_configuresCellCount() {
        let numberOfRows = restaurantListDataSource.tableView(
            UITableView(),
            numberOfRowsInSection: 0
        )


        expect(numberOfRows).to(equal(self.restaurants.count))
    }

    func test_tableView_configuresCellsWithAppropriateType() {
        let tableView = UITableView()
        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantTableViewCell)
        )


        let firstCell = restaurantListDataSource.tableView(
            tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(firstCell).to(beAKindOf(RestaurantTableViewCell))
    }
}
