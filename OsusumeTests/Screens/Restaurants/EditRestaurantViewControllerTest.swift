import Foundation
import XCTest
import Nimble
import BrightFutures
import Result

@testable import Osusume

class EditRestaurantViewControllerTest: XCTestCase {

    var editRestaurantViewController: EditRestaurantViewController!
    var router: FakeRouter!
    var repo: FakeRestaurantRepo!

    override func setUp() {
        UIView.setAnimationsEnabled(false)
        router = FakeRouter()
        repo = FakeRestaurantRepo()

        repo.createdRestaurant = Restaurant(id: 1, name: "Original Restaurant Name", address: "Original Address", cuisineType: "Original Cuisine Type", offersEnglishMenu: true, walkInsOk: false, acceptsCreditCards: true, notes: "This place is great", author: "Jane", createdAt: NSDate(), photoUrls: [])
        editRestaurantViewController = EditRestaurantViewController(
            router: router,
            repo: repo,
            restaurant: repo.createdRestaurant!
        )

        editRestaurantViewController.view.setNeedsLayout()
    }

    func test_populatesRestaurantDetailsInFields() {
        expect(self.editRestaurantViewController.formView.nameTextField.text).to(equal("Original Restaurant Name"))
        expect(self.editRestaurantViewController.formView.addressTextField.text).to(equal("Original Address"))
        expect(self.editRestaurantViewController.formView.cuisineTypeTextField.text).to(equal("Original Cuisine Type"))
        expect(self.editRestaurantViewController.formView.offersEnglishMenuSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.walkInsOkSwitch.on).to(equal(false))
        expect(self.editRestaurantViewController.formView.acceptsCreditCardsSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.notesTextField.text).to(equal("This place is great"))
    }

    func test_invokesUpdateWithChangedValues() {
        editRestaurantViewController.formView.nameTextField.text = "Updated Restaurant Name"
        editRestaurantViewController.formView.cuisineTypeTextField.text = "Updated Restaurant Cuisine Type"
        editRestaurantViewController.formView.walkInsOkSwitch.on = true
        editRestaurantViewController.formView.notesTextField.text = "Try the vegetables!"

        let updateButton = editRestaurantViewController.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)

        let restaurant: Restaurant = repo.createdRestaurant!

        expect(restaurant.name).to(equal("Updated Restaurant Name"))
        expect(restaurant.address).to(equal("Original Address"))
        expect(restaurant.cuisineType).to(equal("Updated Restaurant Cuisine Type"))
        expect(restaurant.offersEnglishMenu).to(equal(true))
        expect(restaurant.walkInsOk).to(equal(true))
        expect(restaurant.acceptsCreditCards).to(equal(true))
        expect(restaurant.notes).to(equal("Try the vegetables!"))
    }
}