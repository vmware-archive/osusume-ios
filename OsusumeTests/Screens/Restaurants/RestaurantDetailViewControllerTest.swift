import XCTest
import Nimble

@testable import Osusume

class RestaurantDetailViewControllerTest: XCTestCase {
    let router = FakeRouter()
    let repo = FakeRestaurantRepo()

    var restaurantDetailVC: RestaurantDetailViewController!

    override func setUp() {
        repo.createdRestaurant = Restaurant(
            id: 1,
            name: "My Restaurant",
            address: "Roppongi",
            cuisineType: "Sushi",
            offersEnglishMenu: true,
            walkInsOk: false,
            acceptsCreditCards: true,
            notes: "This place is great",
            author: "Danny",
            createdAt: NSDate(timeIntervalSince1970: 0),
            photoUrls: [NSURL(string: "my-awesome-url")!],
            comments: []
        )

        restaurantDetailVC = RestaurantDetailViewController(
            router: router,
            repo: repo,
            restaurantId: 1
        )
    }

    func test_tappingTheEditButton_showsTheEditScreen() {
        restaurantDetailVC.view.setNeedsLayout()

        expect(self.restaurantDetailVC.navigationItem.rightBarButtonItem?.title).to(equal("Edit"))

        let updateButton = restaurantDetailVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)

        expect(self.router.editRestaurantScreenIsShowing).to(equal(true))
    }

    func test_tappingTheAddCommentButton_showsTheNewCommentScreen() {
        restaurantDetailVC.view.setNeedsLayout()

        let indexOfRestaurantDetailCell = NSIndexPath(forRow: 0, inSection: 0)
        let restaurantDetailCell = restaurantDetailVC.tableView.cellForRowAtIndexPath(indexOfRestaurantDetailCell) as! RestaurantDetailTableViewCell

        restaurantDetailCell.addCommentButton.sendActionsForControlEvents(.TouchUpInside)

        expect(self.router.newCommentScreenIsShowing).to(equal(true))
        expect(self.router.showNewCommentScreen_args).to(equal(1))
    }
}
