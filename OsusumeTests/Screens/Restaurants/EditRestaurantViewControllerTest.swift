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
    }

    private func instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine) {
        repo.createdRestaurant = RestaurantFixtures.newRestaurant(
            name: "Original Restaurant Name",
            liked: false,
            cuisine: cuisine
        )

        editRestaurantViewController = EditRestaurantViewController(
            router: router,
            repo: repo,
            restaurant: repo.createdRestaurant!
        )

        editRestaurantViewController.view.setNeedsLayout()
    }

    func test_populatesRestaurantDetailsInFields() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))

        expect(self.editRestaurantViewController.formView.nameTextField.text).to(equal("Original Restaurant Name"))
        expect(self.editRestaurantViewController.formView.addressTextField.text).to(equal("Original Address"))
        expect(self.editRestaurantViewController.formView.cuisineValueLabel.text).to(equal("Pizza"))
        expect(self.editRestaurantViewController.formView.offersEnglishMenuSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.walkInsOkSwitch.on).to(equal(false))
        expect(self.editRestaurantViewController.formView.acceptsCreditCardsSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.notesTextView.text).to(equal("This place is great"))
    }

    func test_populatesRestaurantDetailsInFieldsWithoutCuisine() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 0, name: "Not Specified"))

        expect(self.editRestaurantViewController.formView.nameTextField.text).to(equal("Original Restaurant Name"))
        expect(self.editRestaurantViewController.formView.addressTextField.text).to(equal("Original Address"))
        expect(self.editRestaurantViewController.formView.cuisineValueLabel.text).to(equal(""))
        expect(self.editRestaurantViewController.formView.offersEnglishMenuSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.walkInsOkSwitch.on).to(equal(false))
        expect(self.editRestaurantViewController.formView.acceptsCreditCardsSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.notesTextView.text).to(equal("This place is great"))
    }

    func test_tappingUpdateButton_invokesUpdateWithChangedValues() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))

        editRestaurantViewController.formView.nameTextField.text = "Updated Restaurant Name"
        editRestaurantViewController.formView.walkInsOkSwitch.on = true
        editRestaurantViewController.formView.notesTextView.text = "Try the vegetables!"


        let updateButton = editRestaurantViewController.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)


        let actualParams = repo.update_params
        expect(actualParams["name"] as? String).to(equal("Updated Restaurant Name"))
        expect(actualParams["address"] as? String).to(equal("Original Address"))
        expect(actualParams["cuisine_type"] as? String).to(equal("Pizza"))
        expect(actualParams["cuisine_id"] as? Int).to(equal(1))
        expect(actualParams["offers_english_menu"] as? Bool).to(equal(true))
        expect(actualParams["walk_ins_ok"] as? Bool).to(equal(true))
        expect(actualParams["accepts_credit_cards"] as? Bool).to(equal(true))
        expect(actualParams["notes"] as? String).to(equal("Try the vegetables!"))
    }
}
