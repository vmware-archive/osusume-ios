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

    func test_tappingTheAddPhotoButton_showsTheCameraRoll() {
        let image = testImage(named: "appleLogo", imageExtension: "png")
        newRestaurantVC.images.append(image)
        newRestaurantVC.addPhotoButton.sendActionsForControlEvents(.TouchUpInside)

        expect(self.newRestaurantVC.presentedViewController)
            .toEventually(beAKindOf(BSImagePickerViewController))
    }

    func test_tappingDoneButton_returnsToListScreen() {
        let image = testImage(named: "appleLogo", imageExtension: "png")
        newRestaurantVC.images.append(image)

        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(doneButton)

        expect(self.fakeRouter.restaurantListScreenIsShowing).to(equal(true))
    }

    func test_viewDidLoad_showsFindCuisineButton() {
        expect(self.newRestaurantVC.formView.findCuisineButton).to(beAKindOf(UIButton))
    }

    func test_tappingFindCuisine_showsFindCuisineScreen() {
        tapButton(newRestaurantVC.formView.findCuisineButton)

        expect(self.fakeRouter.showFindCuisineScreen_wasCalled).to(beTrue())
    }

    func test_tappingDoneButton_savesRestaurant() {
        newRestaurantVC.formView.nameTextField.text = "Some Restaurant"
        newRestaurantVC.formView.cuisineTypeTextField.text = "Restaurant Cuisine Type"
        newRestaurantVC.formView.notesTextField.text = "Notes"

        let image = testImage(named: "appleLogo", imageExtension: "png")
        newRestaurantVC.images.append(image)
        let truckImage = testImage(named: "truck", imageExtension: "png")
        newRestaurantVC.images.append(truckImage)

        fakePhotoRepo.uploadPhotos_returnValue = ["apple", "truck"]


        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(doneButton)


        let newRestaurant = fakeRestaurantRepo.create_args
        expect(newRestaurant.name).to(equal("Some Restaurant"))
        expect(newRestaurant.address).to(equal(""))
        expect(newRestaurant.cuisineType).to(equal("Restaurant Cuisine Type"))
        expect(newRestaurant.offersEnglishMenu).to(equal(false))
        expect(newRestaurant.walkInsOk).to(equal(false))
        expect(newRestaurant.acceptsCreditCards).to(equal(false))
        expect(newRestaurant.notes).to(equal("Notes"))
        expect(newRestaurant.photoUrls).to(equal(["apple", "truck"]))
    }

    func test_selectCuisine_populatesCuisineTextfield() {
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")


        newRestaurantVC.formView.cuisineSelected(selectedCuisine)


        expect(self.newRestaurantVC.formView.cuisineTypeTextField.text).to(equal("Hamburger"))
    }
}
