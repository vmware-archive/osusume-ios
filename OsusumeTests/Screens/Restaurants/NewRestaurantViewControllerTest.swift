import Foundation
import XCTest
import Nimble
import BrightFutures
import Result
import BSImagePicker
import Photos

@testable import Osusume

class NewRestaurantViewControllerTest: XCTestCase {
    var window: UIWindow?

    var newRestaurantVC: NewRestaurantViewController!
    var fakeRouter: FakeRouter!
    var fakeRestaurantRepo: FakeRestaurantRepo!
    var fakePhotoRepo: FakePhotoRepo!

    override func setUp() {
        UIView.setAnimationsEnabled(false)

        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakePhotoRepo = FakePhotoRepo()
        newRestaurantVC = NewRestaurantViewController(
            router: fakeRouter,
            restaurantRepo: fakeRestaurantRepo,
            photoRepo: fakePhotoRepo
        )

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = newRestaurantVC
        self.window!.makeKeyAndVisible()

        newRestaurantVC.view.setNeedsLayout()
    }

    override func tearDown() {
        self.window?.hidden = true
        self.window!.rootViewController = nil
        self.window = nil
    }

    func test_tappingDoneButton_returnsToListScreen() {
        let image = testImage(named: "appleLogo", imageExtension: "png")
        newRestaurantVC.images.append(image)

        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(doneButton)

        expect(self.fakeRouter.restaurantListScreenIsShowing).to(equal(true))
    }

    func test_tappingDoneButton_savesRestaurant() {
        newRestaurantVC.formView.nameTextField.text = "Some Restaurant"
        newRestaurantVC.formView.cuisineTypeTextField.text = "Restaurant Cuisine Type"
        newRestaurantVC.formView.notesTextField.text = "Notes"

        let image = testImage(named: "appleLogo", imageExtension: "png")
        newRestaurantVC.images.append(image)

        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(doneButton)

        let restaurant: Restaurant = fakeRestaurantRepo.createdRestaurant!

        expect(restaurant.name).to(equal("Some Restaurant"))
        expect(restaurant.address).to(equal(""))
        expect(restaurant.cuisineType).to(equal("Restaurant Cuisine Type"))
        expect(restaurant.offersEnglishMenu).to(equal(false))
        expect(restaurant.walkInsOk).to(equal(false))
        expect(restaurant.acceptsCreditCards).to(equal(false))
        expect(restaurant.notes).to(equal("Notes"))
        expect(restaurant.photoUrl!.absoluteString).to(equal(fakePhotoRepo.generatedUrlAbsoluteString))
    }

    func test_tappingTheAddPhotoButton_showsTheCameraRoll() {
        let image = testImage(named: "appleLogo", imageExtension: "png")
        newRestaurantVC.images.append(image)
        newRestaurantVC.addPhotoButton.sendActionsForControlEvents(.TouchUpInside)

        expect(self.newRestaurantVC.presentedViewController).toEventually(beAKindOf(BSImagePickerViewController))
    }
}
