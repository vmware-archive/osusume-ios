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

    func test_tappingDoneButton_returnsToListScreenOnSuccess() {
        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        UIApplication.sharedApplication().sendAction(
            doneButton.action,
            to: doneButton.target,
            from: nil,
            forEvent: nil
        )

        expect(self.fakeRouter.restaurantListScreenIsShowing).to(equal(true))
    }

    func test_tappingDoneButton_savesRestaurant() {
        newRestaurantVC.formView.nameTextField.text = "Some Restaurant"
        newRestaurantVC.formView.cuisineTypeTextField.text = "Restaurant Cuisine Type"
        newRestaurantVC.formView.notesTextField.text = "Notes"

        let image = UIImage(named: "Jeana")
        newRestaurantVC.images.append(image!)

        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        UIApplication.sharedApplication().sendAction(
            doneButton.action,
            to: doneButton.target,
            from: nil,
            forEvent: nil
        )

        let fakeRestaurantRepo = newRestaurantVC.restaurantRepo as? FakeRestaurantRepo
        let restaurant = fakeRestaurantRepo?.createdRestaurant

        expect(restaurant?.name).to(equal("Some Restaurant"))
        expect(restaurant?.address).to(equal(""))
        expect(restaurant?.cuisineType).to(equal("Restaurant Cuisine Type"))
        expect(restaurant?.offersEnglishMenu).to(equal(false))
        expect(restaurant?.walkInsOk).to(equal(false))
        expect(restaurant?.acceptsCreditCards).to(equal(false))
        expect(restaurant?.notes).to(equal("Notes"))

        let fakePhotoRepo = newRestaurantVC.photoRepo as! FakePhotoRepo

        expect(restaurant?.photoUrl!.absoluteString)
            .to(equal(fakePhotoRepo.generatedUrlAbsoluteString))
    }

    func test_tappingTheAddPhotoButton_showsTheCameraRoll() {
        newRestaurantVC
            .addPhotoButton
            .sendActionsForControlEvents(.TouchUpInside)

        expect(self.newRestaurantVC.presentedViewController)
            .to(beAKindOf(BSImagePickerViewController))
    }
}
