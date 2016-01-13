import Foundation
import Quick
import Nimble
import BrightFutures
import Result
@testable import Osusume

class NewRestaurantViewControllerSpec: QuickSpec {
    var window: UIWindow?

    override func spec() {

        describe("New Restaurant Page") {
            var subject: NewRestaurantViewController!
            var router: FakeRouter!
            var repo: FakeRestaurantRepo!

            beforeEach {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                repo = FakeRestaurantRepo()
                subject = NewRestaurantViewController(router: router, repo: repo)

                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.window!.rootViewController = subject
                self.window!.makeKeyAndVisible()

                subject.view.layoutSubviews()
            }

            afterEach {
                self.window?.hidden = true
                self.window!.rootViewController = nil
                self.window = nil
            }

            it("can save restaurant and return to listing screen") {
                subject.saveButtonTapped(subject.saveButton)
                expect(router.restaurantListScreenIsShowing).to(equal(true))
            }

            it("makes an API call with all fields") {
                subject.formView.nameTextField.text = "Some Restaurant"
                subject.formView.cuisineTypeTextField.text = "Restaurant Cuisine Type"

                subject.saveButtonTapped(subject.saveButton)
                let restaurant: Restaurant = repo.createdRestaurant!

                expect(restaurant.name).to(equal("Some Restaurant"))
                expect(restaurant.address).to(equal(""))
                expect(restaurant.cuisineType).to(equal("Restaurant Cuisine Type"))
                expect(restaurant.offersEnglishMenu).to(equal(false))
                expect(restaurant.walkInsOk).to(equal(false))
                expect(restaurant.acceptsCreditCards).to(equal(false))
            }

            it("displays the camera roll when 'Add Photo from Album' button is tapped") {
                let view = subject.view
                expect(view.subviews.contains(subject.selectedImageView)).to(beTrue())
                subject.selectedImageViewTapped(UITapGestureRecognizer())
                expect(subject.presentedViewController).to(beAKindOf(UIImagePickerController))
            }
        }
    }
}
