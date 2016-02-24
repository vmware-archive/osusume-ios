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

    override func setUp() {
        super.setUp()

        UIView.setAnimationsEnabled(false)
        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakeSessionRepo = FakeSessionRepo()

        fakeRestaurantRepo.allRestaurants = [
            Restaurant(
                id: 1,
                name: "つけめんTETSU",
                address: "",
                cuisineType: "つけめん",
                offersEnglishMenu: true,
                walkInsOk: true,
                acceptsCreditCards: true,
                notes: "This place is great",
                author: "Simon",
                createdAt: NSDate(timeIntervalSince1970: 1454480320),
                photoUrls: []
            ),
            Restaurant(
                id: 2,
                name: "とんかつ 豚組食堂",
                address: "",
                cuisineType: "つけめん",
                offersEnglishMenu: true,
                walkInsOk: true,
                acceptsCreditCards: true,
                notes: "This place is great",
                author: "Simon",
                createdAt: NSDate(timeIntervalSince1970: 1454480320),
                photoUrls: []
            ),
            Restaurant(
                id: 3,
                name: "Coco Curry",
                address: "",
                cuisineType: "つけめん",
                offersEnglishMenu: true,
                walkInsOk: true,
                acceptsCreditCards: true,
                notes: "This place is great",
                author: "Simon",
                createdAt: NSDate(timeIntervalSince1970: 1454480320),
                photoUrls: []
            ),
        ]

        restaurantListVC = RestaurantListViewController(
            router: fakeRouter,
            repo: fakeRestaurantRepo,
            sessionRepo: fakeSessionRepo
        )

        restaurantListVC.view.setNeedsLayout()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRestaurantListVCDisplaysListOfRestaurants() {
        let tableView = restaurantListVC.tableView

        expect(tableView.numberOfSections).to(equal(1))
        expect(tableView.numberOfRowsInSection(0)).to(equal(3))

        let firstTableViewCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(
            NSIndexPath(forItem: 0, inSection: 0)
        ) as! RestaurantTableViewCell
        expect(firstTableViewCell.nameLabel.text).to(equal("つけめんTETSU"))
        expect(firstTableViewCell.cuisineTypeLabel.text).to(equal("つけめん"))
        expect(firstTableViewCell.authorLabel.text).to(equal("Added by Simon"))
        expect(firstTableViewCell.createdAtLabel.text).to(equal("Created on 2/3/16"))

        let secondTableViewCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)) as! RestaurantTableViewCell
        expect(secondTableViewCell.nameLabel.text).to(equal("とんかつ 豚組食堂"))

        let thirdTableViewCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 2, inSection: 0)) as! RestaurantTableViewCell
        expect(thirdTableViewCell.nameLabel.text).to(equal("Coco Curry"))
    }

    func testTapNewRestarauntShowsNewRestaurantScreen() {
        let addRestaurantButton = self.restaurantListVC.navigationItem.rightBarButtonItem!
        expect(addRestaurantButton.title).to(equal("add restaurant"))

        tapNavBarButton(addRestaurantButton)

        expect(self.fakeRouter.newRestaurantScreenIsShowing).to(equal(true))
    }

    func testSelectRowShowsRestaurantDetailScreen() {
        restaurantListVC.didTapRestaurant(1)
        expect(self.fakeRouter.restaurantDetailScreenIsShowing).to(equal(true))
    }

    func testViewDidLoad_showsLogoutButton() {
        if let leftBarButtonItem = self.restaurantListVC.navigationItem.leftBarButtonItem {
            expect(leftBarButtonItem.title).to(equal("Logout"))
        } else {
            XCTFail()
        }
    }

    func testTappingTheLogoutButton_callsDeleteTokenSessionRepo_movesUserToLoginScreen() {
        let logoutButton: UIBarButtonItem! = self.restaurantListVC.navigationItem.leftBarButtonItem
        tapNavBarButton(logoutButton)

        expect(self.fakeSessionRepo.deleteTokenWasCalled).to(beTrue())
        expect(self.fakeRouter.loginScreenIsShowing).to(beTrue())
    }

}
