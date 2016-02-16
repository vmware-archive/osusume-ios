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
            var newRestaurantVC: NewRestaurantViewController!
            var router: FakeRouter!
            var restaurantRepo: FakeRestaurantRepo!
            var photoRepo: FakePhotoRepo!

            beforeEach {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                restaurantRepo = FakeRestaurantRepo()
                photoRepo = FakePhotoRepo()
                newRestaurantVC = NewRestaurantViewController(
                    router: router,
                    restaurantRepo: restaurantRepo,
                    photoRepo: photoRepo
                )

                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.window!.rootViewController = newRestaurantVC
                self.window!.makeKeyAndVisible()

                newRestaurantVC.view.layoutSubviews()
            }

            afterEach {
                self.window?.hidden = true
                self.window!.rootViewController = nil
                self.window = nil
            }

            it("can save restaurant and return to listing screen") {
                expect(newRestaurantVC.navigationItem.rightBarButtonItem!.title).to(equal("Done"))

                newRestaurantVC.didTapDoneButton(newRestaurantVC.navigationItem.rightBarButtonItem)
                expect(router.restaurantListScreenIsShowing).to(equal(true))
            }

            it("creates a restaurant with the API when tapping done") {
                newRestaurantVC.formView.nameTextField.text = "Some Restaurant"
                newRestaurantVC.formView.cuisineTypeTextField.text = "Restaurant Cuisine Type"
                newRestaurantVC.formView.notesTextField.text = "Notes"

                let image = UIImage(named: "Jeana")
                newRestaurantVC.imageView.image = image

                newRestaurantVC.didTapDoneButton(newRestaurantVC.navigationItem.rightBarButtonItem)
                let restaurant: Restaurant = restaurantRepo.createdRestaurant!

                expect(restaurant.name).to(equal("Some Restaurant"))
                expect(restaurant.address).to(equal(""))
                expect(restaurant.cuisineType).to(equal("Restaurant Cuisine Type"))
                expect(restaurant.offersEnglishMenu).to(equal(false))
                expect(restaurant.walkInsOk).to(equal(false))
                expect(restaurant.acceptsCreditCards).to(equal(false))
                expect(restaurant.notes).to(equal("Notes"))
                expect(restaurant.photoUrl!.absoluteString).to(equal(photoRepo.generatedUrlAbsoluteString))
            }
        }
    }
}
