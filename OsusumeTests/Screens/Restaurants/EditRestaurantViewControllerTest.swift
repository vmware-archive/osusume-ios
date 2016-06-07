import XCTest
import Nimble
@testable import Osusume

class EditRestaurantViewControllerTest: XCTestCase {
    var editRestaurantViewController: EditRestaurantViewController!
    var fakeRouter: FakeRouter!
    var fakeRestaurantRepo: FakeRestaurantRepo!
    var fakePhotoRepo: FakePhotoRepo!
    var fakeSessionRepo: FakeSessionRepo!
    var fakeReloader: FakeReloader!


    override func setUp() {
        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakePhotoRepo = FakePhotoRepo()
        fakeSessionRepo = FakeSessionRepo()
        fakeReloader = FakeReloader()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))


        expect(self.editRestaurantViewController.title).to(equal("Edit Restaurant"))
    }

    func test_viewDidLoad_initializesSubviews() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))

        expect(self.editRestaurantViewController.scrollView)
            .to(beAKindOf(UIScrollView))
        expect(self.editRestaurantViewController.scrollViewContentView)
            .to(beAKindOf(UIView))
        expect(self.editRestaurantViewController.formViewContainer)
            .to(beAKindOf(UIView))
        expect(self.editRestaurantViewController.formView)
            .to(beAKindOf(EditRestaurantFormView))
        expect(self.editRestaurantViewController.imageCollectionView)
            .to(beAKindOf(UICollectionView))
    }

    func test_viewDidLoad_addsSubviews() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))

        expect(self.editRestaurantViewController.view)
            .to(containSubview(editRestaurantViewController.scrollView))
        expect(self.editRestaurantViewController.view)
            .to(containSubview(editRestaurantViewController.scrollViewContentView))
        expect(self.editRestaurantViewController.view)
            .to(containSubview(editRestaurantViewController.formViewContainer))
        expect(self.editRestaurantViewController.view)
            .to(containSubview(editRestaurantViewController.formView))
        expect(self.editRestaurantViewController.view)
            .to(containSubview(editRestaurantViewController.imageCollectionView))
    }

    func test_tappingDeleteButton_callsIntoPhotoRepo() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))
        let cell = self.editRestaurantViewController.imageCollectionView
            .dataSource?.collectionView(
                self.editRestaurantViewController.imageCollectionView,
                cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
            ) as! PhotoCollectionViewCell


        tapButton(cell.deleteButton)


        expect(self.fakePhotoRepo.deletePhoto_wasCalled).to(beTrue())
        expect(self.fakePhotoRepo.deletePhoto_args.restaurantId).to(equal(5))
        expect(self.fakePhotoRepo.deletePhoto_args.photoUrlId).to(equal(10))
    }

    func test_tappingDeleteButton_deletePhotoUrlFromRestaurant() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))
        let cell = self.editRestaurantViewController.imageCollectionView
            .dataSource?.collectionView(
                self.editRestaurantViewController.imageCollectionView,
                cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
            ) as! PhotoCollectionViewCell


        tapButton(cell.deleteButton)


        expect(self.editRestaurantViewController.restaurant.photoUrls.count).to(equal(0))
    }

    func test_tappingDeleteButton_reloadsCollectionView() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))
        let cell = self.editRestaurantViewController.imageCollectionView
            .dataSource?.collectionView(
                self.editRestaurantViewController.imageCollectionView,
                cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
            ) as! PhotoCollectionViewCell


        tapButton(cell.deleteButton)


        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    func test_viewDidLoad_addsConstraints() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))

        expect(self.editRestaurantViewController.scrollView)
            .to(haveConstraints())
        expect(self.editRestaurantViewController.scrollViewContentView)
            .to(haveConstraints())
        expect(self.editRestaurantViewController.formViewContainer)
            .to(haveConstraints())
        expect(self.editRestaurantViewController.formView)
            .to(haveConstraints())
        expect(self.editRestaurantViewController.imageCollectionView)
            .to(haveConstraints())
    }

    func test_viewDidLoad_setsImageCollectionViewDataSource() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))


        expect(self.editRestaurantViewController.imageCollectionView.dataSource)
            .toNot(beNil())
        expect(self.editRestaurantViewController.imageCollectionView.dataSource is PhotoUrlsCollectionViewDataSource).to(beTrue())
    }

    func test_viewDidLoad_registersCollectionViewCellClass() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))


        let cell = editRestaurantViewController.imageCollectionView.dequeueReusableCellWithReuseIdentifier(
            String(PhotoCollectionViewCell),
            forIndexPath: NSIndexPath(forItem: 0, inSection: 0)
        )


        expect(cell).toNot(beNil())
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

    func test_cannotDeletePhoto_whenRestaurantNotCreatedByCurrentUser() {
        fakeSessionRepo.getAuthenticatedUser_returnValue = AuthenticatedUser(
            id: 10, email: "danny@pivotal", token: "token-string"
        )
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 0, name: "Not Specified"))


        let cell = editRestaurantViewController.imageCollectionView
            .dataSource?
            .collectionView(
                editRestaurantViewController.imageCollectionView,
                cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
        ) as? PhotoCollectionViewCell


        expect(cell!.deleteButton.hidden).to(beTrue())
    }

    // MARK: - Navigation Bar
    func test_tappingUpdateButton_invokesUpdateWithChangedValues() {
        instantiateEditRestaurantVCWithCuisine(Cuisine(id: 1, name: "Pizza"))

        editRestaurantViewController.formView.nameTextField.text = "Updated Restaurant Name"
        editRestaurantViewController.formView.walkInsOkSwitch.on = true
        editRestaurantViewController.formView.notesTextView.text = "Try the vegetables!"


        let updateButton = editRestaurantViewController.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)


        let actualParams = fakeRestaurantRepo.update_params
        expect(actualParams["name"] as? String).to(equal("Updated Restaurant Name"))
        expect(actualParams["address"] as? String).to(equal("Original Address"))
        expect(actualParams["cuisine_type"] as? String).to(equal("Pizza"))
        expect(actualParams["cuisine_id"] as? Int).to(equal(1))
        expect(actualParams["offers_english_menu"] as? Bool).to(equal(true))
        expect(actualParams["walk_ins_ok"] as? Bool).to(equal(true))
        expect(actualParams["accepts_credit_cards"] as? Bool).to(equal(true))
        expect(actualParams["notes"] as? String).to(equal("Try the vegetables!"))
    }

    // MARK: - Private Methods
    private func instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine) {
        let restaurant = RestaurantFixtures.newRestaurant(
            id: 5,
            name: "Original Restaurant Name",
            liked: false,
            cuisine: cuisine,
            createdByUser: (id: 99, name: "Witta", email: "witta@pivotal"),
            photoUrls: [
                PhotoUrl(id: 10, url: NSURL(string: "url")!)
            ]
        )

        editRestaurantViewController = EditRestaurantViewController(
            router: fakeRouter,
            repo: fakeRestaurantRepo,
            photoRepo: fakePhotoRepo,
            sessionRepo: fakeSessionRepo,
            reloader: fakeReloader,
            restaurant: restaurant
        )

        editRestaurantViewController.view.setNeedsLayout()
    }
}
