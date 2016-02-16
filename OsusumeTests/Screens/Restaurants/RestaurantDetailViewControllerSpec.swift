import XCTest
import Nimble

@testable import Osusume

class RestaurantDetailViewControllerSpec: XCTestCase {
    let creationDate = NSDate(timeIntervalSince1970: 0)
    let router = FakeRouter()
    let repo = FakeRestaurantRepo()

    var controller: RestaurantDetailViewController!

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
            photoUrl: NSURL(string: "")
        )

        controller = RestaurantDetailViewController(
            router: router,
            repo: repo,
            restaurantId: 1
        )
    }

    func test_viewDidLoad_displaysDetailsOfARestaurant() {
        let _ = controller.view


        expect(self.controller.nameLabel.text).to(equal("My Restaurant"))
        expect(self.controller.addressLabel.text).to(equal("Roppongi"))
        expect(self.controller.cuisineTypeLabel.text).to(equal("Sushi"))
        expect(self.controller.offersEnglishMenuLabel.text).to(equal("Offers English menu"))
        expect(self.controller.walkInsOkLabel.text).to(equal("Walk-ins not recommended"))
        expect(self.controller.acceptsCreditCardsLabel.text).to(equal("Accepts credit cards"))
        expect(self.controller.notesLabel.text).to(equal("This place is great"))
        expect(self.controller.creationInfoLabel.text).to(equal("Added by Danny on 1/1/70"))
    }

    func test_tappingTheEditButton_showsTheEditScreen() {
        let _ = controller.view

        expect(self.controller.navigationItem.rightBarButtonItem?.title).to(equal("Edit"))

        controller.didTapEditRestaurantButton(controller.navigationItem.rightBarButtonItem!)

        expect(self.router.editRestaurantScreenIsShowing).to(equal(true))
    }

    func test_tappingTheAddCommentButton_showsTheNewCommentScreen() {
        let _ = controller.view

        controller.addCommentButton.sendActionsForControlEvents(.TouchUpInside)

        expect(self.router.newCommentScreenIsShowing).to(equal(true))
        expect(self.router.showNewCommentScreen_args).to(equal(1)) // created restaurant
    }
}
