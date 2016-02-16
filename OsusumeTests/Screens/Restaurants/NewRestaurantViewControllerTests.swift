import XCTest
import Nimble

@testable import Osusume

class NewRestaurantViewControllerTests: XCTestCase {

    var window: UIWindow?
    var newRestaurantViewController: NewRestaurantViewController!
    var fakeRouter: FakeRouter!
    var fakeRestaurantRepo: FakeRestaurantRepo!
    var fakePhotoRepo: FakePhotoRepo!

    override func setUp() {
        super.setUp()

        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakePhotoRepo = FakePhotoRepo()

        newRestaurantViewController = NewRestaurantViewController(
            router: fakeRouter,
            restaurantRepo: fakeRestaurantRepo,
            photoRepo: fakePhotoRepo
        )

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = newRestaurantViewController
        self.window!.makeKeyAndVisible()

        newRestaurantViewController.view.layoutSubviews()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_tappingDoneButton_returnsToListScreen() {
        let doneButton = newRestaurantViewController.navigationItem.rightBarButtonItem!
        UIApplication.sharedApplication().sendAction(
            doneButton.action,
            to: doneButton.target,
            from: nil,
            forEvent: nil
        )
        expect(self.fakeRouter.restaurantListScreenIsShowing).to(equal(true))
    }

    func test_tappingDoneButton_savesRestaurant() {
        newRestaurantViewController.formView.nameTextField.text = "Some Restaurant"
        newRestaurantViewController.formView.cuisineTypeTextField.text = "Restaurant Cuisine Type"
        newRestaurantViewController.formView.notesTextField.text = "Notes"

        let image = UIImage(named: "Jeana")
        newRestaurantViewController.imageView.image = image

        let doneButton = newRestaurantViewController.navigationItem.rightBarButtonItem!
        UIApplication.sharedApplication().sendAction(
            doneButton.action,
            to: doneButton.target,
            from: nil,
            forEvent: nil
        )

        let fakeRestaurantRepo = newRestaurantViewController.restaurantRepo as! FakeRestaurantRepo
        let restaurant: Restaurant = fakeRestaurantRepo.createdRestaurant!
        expect(restaurant.name).to(equal("Some Restaurant"))
        expect(restaurant.address).to(equal(""))
        expect(restaurant.cuisineType).to(equal("Restaurant Cuisine Type"))
        expect(restaurant.offersEnglishMenu).to(equal(false))
        expect(restaurant.walkInsOk).to(equal(false))
        expect(restaurant.acceptsCreditCards).to(equal(false))
        expect(restaurant.notes).to(equal("Notes"))

        let fakePhotoRepo = newRestaurantViewController.photoRepo as! FakePhotoRepo
        expect(restaurant.photoUrl!.absoluteString).to(equal(fakePhotoRepo.generatedUrlAbsoluteString))
    }

    func test_tappingTheAddPhotoButton_showsTheCameraRoll() {

        newRestaurantViewController.addPhotoButton.sendActionsForControlEvents(.TouchUpInside)
        expect(self.newRestaurantViewController.presentedViewController).to(beAKindOf(UIImagePickerController))
    }

}
