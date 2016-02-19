import XCTest
import Nimble
import BSImagePicker
import Photos

@testable import Osusume

class NewRestaurantViewControllerTests: XCTestCase {

    var window: UIWindow?
    var newRestaurantVC: NewRestaurantViewController!
    var fakeRouter: FakeRouter!
    var fakeRestaurantRepo: FakeRestaurantRepo!
    var fakePhotoRepo: FakePhotoRepo!

    override func setUp() {
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

        newRestaurantVC.view.layoutSubviews()
    }

    func test_tappingDoneButton_savesRestaurant_returnsToListScreenOnSuccess() {
        newRestaurantVC.formView.nameTextField.text = "Some Restaurant"
        newRestaurantVC.formView.cuisineTypeTextField.text = "Cuisine Type"
        newRestaurantVC.formView.notesTextField.text = "Notes"

        let image = UIImage(named: "Jeana")
        newRestaurantVC.images.append(image!)

        fakePhotoRepo.uploadPhoto_returnValue = "http://www.example.com"

        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(doneButton)

        let restaurant = fakeRestaurantRepo.createdRestaurant

        expect(restaurant?.photoUrl?.URLString).to(equal("http://www.example.com"))
        expect(restaurant?.name).to(equal("Some Restaurant"))
        expect(restaurant?.address).to(equal(""))
        expect(restaurant?.cuisineType).to(equal("Cuisine Type"))
        expect(restaurant?.offersEnglishMenu).to(equal(false))
        expect(restaurant?.walkInsOk).to(equal(false))
        expect(restaurant?.acceptsCreditCards).to(equal(false))
        expect(restaurant?.notes).to(equal("Notes"))
        expect(self.fakeRouter.restaurantListScreenIsShowing).to(equal(true))
    }

    func test_tappingTheAddPhotoButton_showsTheCameraRoll() {
        newRestaurantVC
            .addPhotoButton
            .sendActionsForControlEvents(.TouchUpInside)

        expect(self.newRestaurantVC.presentedViewController)
            .to(beAKindOf(BSImagePickerViewController))
    }

    func test_tappingTheDoneButton_passesImagesToPhotoRepo() {
        newRestaurantVC.formView.nameTextField.text = "Some Restaurant"
        newRestaurantVC.formView.addressTextField.text = "123 Main Street"
        newRestaurantVC.formView.cuisineTypeTextField.text = "Cuisine Type"
        newRestaurantVC.formView.notesTextField.text = "Notes"
        let restaurantImage = UIImage(named: "Jeana")!
        newRestaurantVC.images = [restaurantImage]

        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(doneButton)

        expect(self.fakePhotoRepo.uploadPhoto_arg).to(equal(restaurantImage))
    }
}
