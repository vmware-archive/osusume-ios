import XCTest
import Nimble

@testable import Osusume

class RestaurantDetailViewControllerTest: XCTestCase {
    let creationDate = NSDate(timeIntervalSince1970: 0)
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
            createdAt: creationDate,
            photoUrls: [],
            comments: []
        )

        restaurantDetailVC = RestaurantDetailViewController(
            router: router,
            repo: repo,
            restaurantId: 1
        )
    }

    func test_viewDidLoad_displaysDetailsOfARestaurant() {
        restaurantDetailVC.view.setNeedsLayout()

        let indexOfRestaurantDetailCell = NSIndexPath(forRow: 0, inSection: 0)
        let restaurantDetailCell = restaurantDetailVC.tableView.cellForRowAtIndexPath(indexOfRestaurantDetailCell) as! RestaurantDetailTableViewCell

        expect(restaurantDetailCell.nameLabel.text).to(equal("My Restaurant"))
        expect(restaurantDetailCell.addressLabel.text).to(equal("Roppongi"))
        expect(restaurantDetailCell.cuisineTypeLabel.text).to(equal("Sushi"))
        expect(restaurantDetailCell.offersEnglishMenuLabel.text).to(equal("Offers English menu"))
        expect(restaurantDetailCell.walkInsOkLabel.text).to(equal("Walk-ins not recommended"))
        expect(restaurantDetailCell.acceptsCreditCardsLabel.text).to(equal("Accepts credit cards"))
        expect(restaurantDetailCell.notesLabel.text).to(equal("This place is great"))
        expect(restaurantDetailCell.creationInfoLabel.text).to(equal("Added by Danny on 1/1/70"))
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
        expect(self.router.showNewCommentScreen_args).to(equal(1)) // created restaurant
    }
}
