import Foundation
import Quick
import Nimble
import BrightFutures
import Result
@testable import Osusume

class EditRestaurantViewControllerSpec: QuickSpec {
    var window: UIWindow?

    override func spec() {
        describe("Edit Restaurant Page") {
            var subject: EditRestaurantViewController!
            var router: FakeRouter!
            var repo: FakeRestaurantRepo!

            beforeEach {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                repo = FakeRestaurantRepo()
                repo.createdRestaurant = Restaurant(id: 1, name: "Original Restaurant Name", address: "Original Address", cuisineType: "Original Cuisine Type", offersEnglishMenu: true, walkInsOk: false, acceptsCreditCards: true, notes: "This place is great")
                subject = EditRestaurantViewController(router: router, repo: repo, restaurant: repo.createdRestaurant!)

                subject.view.layoutSubviews()
            }

            it("displays details of restaurant in text fields") {
                expect(subject.formView.nameTextField.text).to(equal("Original Restaurant Name"))
                expect(subject.formView.addressTextField.text).to(equal("Original Address"))
                expect(subject.formView.cuisineTypeTextField.text).to(equal("Original Cuisine Type"))
                expect(subject.formView.offersEnglishMenuSwitch.on).to(equal(true))
                expect(subject.formView.walkInsOkSwitch.on).to(equal(false))
                expect(subject.formView.acceptsCreditCardsSwitch.on).to(equal(true))
                expect(subject.formView.notesTextField.text).to(equal("This place is great"))
            }


            it("makes an API call with all fields") {
                subject.formView.nameTextField.text = "Updated Restaurant Name"
                subject.formView.cuisineTypeTextField.text = "Updated Restaurant Cuisine Type"
                subject.formView.walkInsOkSwitch.on = true
                subject.formView.notesTextField.text = "Try the vegetables!"

                subject.didTapUpdateButton(subject.navigationItem.rightBarButtonItem)
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
    }
}
