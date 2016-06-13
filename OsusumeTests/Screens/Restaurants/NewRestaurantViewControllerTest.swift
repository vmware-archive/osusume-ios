import XCTest
import Nimble
import BrightFutures
import Result

@testable import Osusume

class NewRestaurantViewControllerTest: XCTestCase {
    var newRestaurantVC: NewRestaurantViewController!
    var fakeRouter: FakeRouter!
    var fakeRestaurantRepo: FakeRestaurantRepo!
    var fakePhotoRepo: FakePhotoRepo!
    var fakeImagePicker: FakeImagePicker!

    override func setUp() {
        UIView.setAnimationsEnabled(false)

        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakePhotoRepo = FakePhotoRepo()
        fakeImagePicker = FakeImagePicker()

        newRestaurantVC = NewRestaurantViewController(
            router: fakeRouter,
            restaurantRepo: fakeRestaurantRepo,
            photoRepo: fakePhotoRepo,
            imagePicker: fakeImagePicker
        )

        newRestaurantVC.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_initializesSubviews() {
        expect(self.newRestaurantVC.tableView).to(beAKindOf(UITableView))
        let cell = getAddRestaurantFormTableViewCell()

        expect(cell.formView.findRestaurantButton).to(beAKindOf(UIButton))
        expect(cell.formView.findCuisineButton).to(beAKindOf(UIButton))
        expect(cell.formView.priceRangeButton).to(beAKindOf(UIButton))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.newRestaurantVC.view)
            .to(containSubview(newRestaurantVC.tableView))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.newRestaurantVC.tableView)
            .to(hasConstraintsToSuperviewOrSelf())
    }

    // MARK: - Tableview
    func test_tableView_setsDatasource() {
        expect(self.newRestaurantVC.tableView.dataSource === self.newRestaurantVC).to(beTrue())
    }

    func test_tableView_containsSingleSection() {
        let numberOfSections = newRestaurantVC.tableView.numberOfSections


        expect(numberOfSections).to(equal(1))
    }

    func test_tableView_containsTwoRowsForRestaurantDetails() {
        let numberOfRows = newRestaurantVC.tableView.dataSource?.tableView(
            newRestaurantVC.tableView,
            numberOfRowsInSection: 0
        )


        expect(numberOfRows).to(equal(2))
    }

    func test_tableView_doesNotAllowSelection() {
        expect(self.newRestaurantVC.tableView.allowsSelection).to(beFalse())
    }

    func test_tableView_returnsAddRestaurantPhotoTableViewCell() {
        let cell = getAddRestaurantPhotosTableViewCell()


        expect(cell).toNot(beNil())
        expect(cell).to(beAKindOf(AddRestaurantPhotosTableViewCell))
    }

    func test_tableView_returnsAddRestaurantFormTableViewCell() {
        let cell = getAddRestaurantFormTableViewCell()


        expect(cell).toNot(beNil())
        expect(cell).to(beAKindOf(AddRestaurantFormTableViewCell))
    }

    // MARK: - Navigation Bar
    func test_viewDidLoad_setsTitle() {
        expect(self.newRestaurantVC.title).to(equal("Add Restaurant"))
    }

    // MARK: - Actions
    func test_tappingDoneButton_savesRestaurant() {
        let cell = getAddRestaurantFormTableViewCell()
        cell.formView.nameTextField.text = "Some Restaurant"
        cell.formView.cuisineTypeValueLabel.text = "Restaurant Cuisine Type"
        cell.formView.notesTextField.text = "Notes"
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
        expect(newRestaurant.photoUrls).to(equal(["apple", "truck"]));
    }

    func test_tappingDoneButton_returnsToListScreen() {
        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!


        tapNavBarButton(doneButton)
        NSRunLoop.osu_advance()


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    func test_tappingCancelButton_dismissesToListScreen() {
        let cancelButton = newRestaurantVC.navigationItem.leftBarButtonItem!


        tapNavBarButton(cancelButton)
        NSRunLoop.osu_advance()


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    func test_tappingAddPhotoButton_showsPhotoPicker() {
        let cell = getAddRestaurantPhotosTableViewCell()
        tapButton(cell.addPhotoButton)


        expect(self.fakeImagePicker.bs_presentImagePickerController_wasCalled).to(beTrue())
    }

    func test_tappingFindRestaurantButton_showsFindRestaurantScreen() {
        let cell = getAddRestaurantFormTableViewCell()
        tapButton(cell.formView.findRestaurantButton)


        expect(self.fakeRouter.showFindRestaurantScreen_wasCalled).to(beTrue())
    }

    func test_tappingFindCuisine_showsFindCuisineScreen() {
        let cell = getAddRestaurantFormTableViewCell()
        tapButton(cell.formView.findCuisineButton)


        expect(self.fakeRouter.showFindCuisineScreen_wasCalled).to(beTrue())
    }

    func test_tappingPriceRange_showsPriceRangeListScreen() {
        let cell = getAddRestaurantFormTableViewCell()
        tapButton(cell.formView.priceRangeButton)


        expect(self.fakeRouter.showPriceRangeListScreen_wasCalled).to(beTrue())
    }

    // MARK: - Find Restaurant
    func test_selectSearchResultRestaurant_populatesNameAndAddressTextfields() {
        let selectedSearchResultRestaurant = SearchResultRestaurant(
            id: "1",
            name: "Afuri",
            address: "Roppongi Hills 5-2-1"
        )


        let cell = getAddRestaurantFormTableViewCell()
        cell.formView.searchResultRestaurantSelected(selectedSearchResultRestaurant)


        expect(cell.formView.nameTextField.text).to(equal("Afuri"))
        expect(cell.formView.addressTextField.text).to(equal("Roppongi Hills 5-2-1"))
    }

    // MARK: - Select Cuisine
    func test_selectCuisine_populatesCuisineTextfield() {
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")


        let cell = getAddRestaurantFormTableViewCell()
        cell.formView.cuisineSelected(selectedCuisine)


        expect(cell.formView.cuisineTypeValueLabel.text).to(equal("Hamburger"))
    }

    func test_selectCuisine_setsSelectedCuisinePropertyValue() {
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")


        let cell = getAddRestaurantFormTableViewCell()
        cell.formView.cuisineSelected(selectedCuisine)


        expect(cell.formView.selectedCuisine).to(equal(selectedCuisine))
    }

    // MARK: - Price Range
    func test_selectPriceRange_populatesPriceRangeTextfield() {
        let selectedPriceRange = PriceRange(id: 1, range: "0~999")


        let cell = getAddRestaurantFormTableViewCell()
        cell.formView.priceRangeSelected(selectedPriceRange)


        expect(cell.formView.priceRangeValueLabel.text).to(equal("0~999"))
    }

    func test_selectPriceRange_setsSelectedPriceRangePropertyValue() {
        let selectedPriceRange = PriceRange(id: 1, range: "0~999")


        let cell = getAddRestaurantFormTableViewCell()
        cell.formView.priceRangeSelected(selectedPriceRange)


        expect(cell.formView.selectedPriceRange).to(equal(selectedPriceRange))
    }

    // MARK: - Private Methods
    func getAddRestaurantPhotosTableViewCell() -> AddRestaurantPhotosTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.AddPhotosCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! AddRestaurantPhotosTableViewCell
    }

    func getAddRestaurantFormTableViewCell() -> AddRestaurantFormTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.FormDetailsCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! AddRestaurantFormTableViewCell
    }
}
