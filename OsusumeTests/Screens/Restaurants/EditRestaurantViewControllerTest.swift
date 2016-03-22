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
        repo.createdRestaurant = RestaurantFixtures.newRestaurant(name: "Original Restaurant Name", liked: false, cuisine: cuisine)

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
        expect(self.editRestaurantViewController.formView.cuisineTypeValueLabel.text).to(equal("Pizza"))
        expect(self.editRestaurantViewController.formView.offersEnglishMenuSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.walkInsOkSwitch.on).to(equal(false))
        expect(self.editRestaurantViewController.formView.acceptsCreditCardsSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.notesTextField.text).to(equal("This place is great"))
    }

    func test_populatesRestaurantDetailsInFieldsWithoutCuisine() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 0, name: "Not Specified"))

        expect(self.editRestaurantViewController.formView.nameTextField.text).to(equal("Original Restaurant Name"))
        expect(self.editRestaurantViewController.formView.addressTextField.text).to(equal("Original Address"))
        expect(self.editRestaurantViewController.formView.cuisineTypeValueLabel.text).to(equal(""))
        expect(self.editRestaurantViewController.formView.offersEnglishMenuSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.walkInsOkSwitch.on).to(equal(false))
        expect(self.editRestaurantViewController.formView.acceptsCreditCardsSwitch.on).to(equal(true))
        expect(self.editRestaurantViewController.formView.notesTextField.text).to(equal("This place is great"))
    }


    func test_invokesUpdateWithChangedValues() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))

        editRestaurantViewController.formView.nameTextField.text = "Updated Restaurant Name"
        editRestaurantViewController.formView.cuisineTypeValueLabel.text = "Updated Restaurant Cuisine Type"
        editRestaurantViewController.formView.cuisine = Cuisine(id: 2, name: "Gyouza")
        editRestaurantViewController.formView.walkInsOkSwitch.on = true
        editRestaurantViewController.formView.notesTextField.text = "Try the vegetables!"

        let updateButton = editRestaurantViewController.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)

        let restaurant: Restaurant = repo.createdRestaurant!

        expect(restaurant.name).to(equal("Updated Restaurant Name"))
        expect(restaurant.address).to(equal("Original Address"))
        expect(restaurant.cuisineType).to(equal("Updated Restaurant Cuisine Type"))
        expect(restaurant.cuisine == Cuisine(id: 2, name: "Gyouza"))
        expect(restaurant.offersEnglishMenu).to(equal(true))
        expect(restaurant.walkInsOk).to(equal(true))
        expect(restaurant.acceptsCreditCards).to(equal(true))
        expect(restaurant.notes).to(equal("Try the vegetables!"))
    }
}