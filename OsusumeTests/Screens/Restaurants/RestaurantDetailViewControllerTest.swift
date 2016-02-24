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
            photoUrls: []
        )

        restaurantDetailVC = RestaurantDetailViewController(
            router: router,
            repo: repo,
            restaurantId: 1
        )
    }

    func test_viewDidLoad_displaysDetailsOfARestaurant() {
        restaurantDetailVC.view.setNeedsLayout()

        expect(self.restaurantDetailVC.nameLabel.text).to(equal("My Restaurant"))
        expect(self.restaurantDetailVC.addressLabel.text).to(equal("Roppongi"))
        expect(self.restaurantDetailVC.cuisineTypeLabel.text).to(equal("Sushi"))
        expect(self.restaurantDetailVC.offersEnglishMenuLabel.text).to(equal("Offers English menu"))
        expect(self.restaurantDetailVC.walkInsOkLabel.text).to(equal("Walk-ins not recommended"))
        expect(self.restaurantDetailVC.acceptsCreditCardsLabel.text).to(equal("Accepts credit cards"))
        expect(self.restaurantDetailVC.notesLabel.text).to(equal("This place is great"))
        expect(self.restaurantDetailVC.creationInfoLabel.text).to(equal("Added by Danny on 1/1/70"))
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

        restaurantDetailVC.addCommentButton.sendActionsForControlEvents(.TouchUpInside)

        expect(self.router.newCommentScreenIsShowing).to(equal(true))
        expect(self.router.showNewCommentScreen_args).to(equal(1)) // created restaurant
    }
}
