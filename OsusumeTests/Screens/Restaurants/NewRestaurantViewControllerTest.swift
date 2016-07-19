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
    var fakeReloader: FakeReloader!

    override func setUp() {
        UIView.setAnimationsEnabled(false)

        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakePhotoRepo = FakePhotoRepo()
        fakeImagePicker = FakeImagePicker()
        fakeReloader = FakeReloader()

        newRestaurantVC = NewRestaurantViewController(
            router: fakeRouter,
            restaurantRepo: fakeRestaurantRepo,
            photoRepo: fakePhotoRepo,
            imagePicker: fakeImagePicker,
            reloader: fakeReloader
        )

        newRestaurantVC.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_initializesSubviews() {
        expect(self.newRestaurantVC.tableView).to(beAKindOf(UITableView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.newRestaurantVC.view)
            .to(containSubview(newRestaurantVC.tableView))
    }

    func test_viewDidLoad_configuresSubviews() {
        expect(self.newRestaurantVC.addRestaurantPhotosTableViewCell.imageCollectionView.dataSource === self.newRestaurantVC).to(beTrue())
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.newRestaurantVC.tableView)
            .to(hasConstraintsToSuperviewOrSelf())
    }

    // MARK: - Tableview
    func test_tableView_setsDatasource() {
        expect(self.newRestaurantVC.tableView.dataSource === self.newRestaurantVC).to(beTrue())
    }

    func test_tableView_setsDelegate() {
        expect(self.newRestaurantVC.tableView.delegate === self.newRestaurantVC).to(beTrue())
    }

    func test_tableView_containsSingleSection() {
        let numberOfSections = newRestaurantVC.tableView.numberOfSections


        expect(numberOfSections).to(equal(1))
    }

    func test_tableView_containsSixRowsForRestaurantDetails() {
        let numberOfRows = newRestaurantVC.tableView.dataSource?.tableView(
            newRestaurantVC.tableView,
            numberOfRowsInSection: 0
        )


        expect(numberOfRows).to(equal(6))
    }

    // MARK: - Tableview Cell
    func test_tableView_returnsAddRestaurantPhotoTableViewCell() {
        let cell = getAddRestaurantPhotosTableViewCell()


        expect(cell).to(beAKindOf(AddRestaurantPhotosTableViewCell))
    }

    func test_tableView_returnsNearestStationTableViewCell() {
        let cell = getNearestStationTableViewCell()


        expect(cell).to(beAKindOf(NearestStationTableViewCell))
    }

    func test_tableView_returnsNotesTableViewCell() {
        let cell = getNotesTableViewCell()


        expect(cell).to(beAKindOf(NotesTableViewCell))
    }

    func test_tableView_returnsFindRestaurantTableViewCell() {
        let cell = getFindRestaurantTableViewCell()


        expect(cell).to(beAKindOf(FindRestaurantTableViewCell))
    }

    func test_tableView_returnsCuisineTableViewCell() {
        let cell = getCuisineTableViewCell()


        expect(cell).to(beAKindOf(CuisineTableViewCell))
    }

    func test_tableView_returnsPriceRangeTableViewCell() {
        let cell = getPriceRangeTableViewCell()


        expect(cell).to(beAKindOf(PriceRangeTableViewCell))
    }

    // MARK: - Tapping Cells
    func test_tappingAddRestaurantPhotosCell_doesNotAllowSelection() {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.AddPhotosCell.rawValue,
            inSection: 0
        )
        newRestaurantVC.tableView.delegate?.tableView!(
            newRestaurantVC.tableView,
            didSelectRowAtIndexPath: indexPath
        )


        expect(self.fakeRouter.showFindRestaurantScreen_wasCalled).to(beFalse())
    }

    func test_tappingFindRestaurantCell_showsFindRestaurantScreen() {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.FindRestaurantCell.rawValue,
            inSection: 0
        )
        newRestaurantVC.tableView.delegate?.tableView!(
            newRestaurantVC.tableView,
            didSelectRowAtIndexPath: indexPath
        )


        expect(self.fakeRouter.showFindRestaurantScreen_wasCalled).to(beTrue())
    }

    func test_tappingRestaurantFormCell_doesNotAllowSelection() {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.NotesCell.rawValue,
            inSection: 0
        )
        newRestaurantVC.tableView.delegate?.tableView!(
            newRestaurantVC.tableView,
            didSelectRowAtIndexPath: indexPath
        )


        expect(self.fakeRouter.showFindRestaurantScreen_wasCalled).to(beFalse())
    }

    func test_tappingCuisineCell_showsCuisineListViewController() {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.CuisineCell.rawValue,
            inSection: 0
        )
        newRestaurantVC.tableView.delegate?.tableView!(
            newRestaurantVC.tableView,
            didSelectRowAtIndexPath: indexPath
        )


        expect(self.fakeRouter.showFindCuisineScreen_wasCalled).to(beTrue())
    }

    func test_tappingPriceRangeCell_showPriceRangeViewController() {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.PriceRangeCell.rawValue,
            inSection: 0
        )
        newRestaurantVC.tableView.delegate?.tableView!(
            newRestaurantVC.tableView,
            didSelectRowAtIndexPath: indexPath
        )


        expect(self.fakeRouter.showPriceRangeListScreen_wasCalled).to(beTrue())
    }

    // MARK: - Navigation Bar
    func test_viewDidLoad_setsTitle() {
        expect(self.newRestaurantVC.title).to(equal("Add Restaurant"))
    }

    func test_viewDidLoad_initializesTheSaveButtonAsDisabled() {
        expect(self.newRestaurantVC.navigationItem.rightBarButtonItem!.enabled).to(beFalse())
    }

    // MARK: - Save Button
    func test_fillingInAllRequiredFields_enablesSaveButton() {
        let selectedSearchResultRestaurant = RestaurantSuggestion(
            name: "name", address: "address", placeId: "", latitude: 0, longitude: 0
        )
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")
        let selectedPriceRange = PriceRange(id: 1, range: "0~999")


        newRestaurantVC.searchResultRestaurantSelected(selectedSearchResultRestaurant)
        newRestaurantVC.cuisineSelected(selectedCuisine)
        newRestaurantVC.priceRangeSelected(selectedPriceRange)


        expect(self.newRestaurantVC.navigationItem.rightBarButtonItem!.enabled).to(beTrue())
    }

    func test_fillingSomeRequiredFields_doesNotEnablesSaveButton() {
        let selectedSearchResultRestaurant = RestaurantSuggestion(
            name: "name", address: "address", placeId: "", latitude: 0, longitude: 0
        )
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")


        newRestaurantVC.searchResultRestaurantSelected(selectedSearchResultRestaurant)
        newRestaurantVC.cuisineSelected(selectedCuisine)


        expect(self.newRestaurantVC.navigationItem.rightBarButtonItem!.enabled).to(beFalse())
    }

    // MARK: - Actions
    func test_tappingSaveButton_savesRestaurant() {
        newRestaurantVC.newRestaurant = NewRestaurant(
            name: "Some Restaurant",
            address: "Address",
            placeId: "abcd",
            latitude: 1.23,
            longitude: 2.34,
            cuisine: Cuisine(id: 1, name: "Cuisine Type"),
            priceRange: PriceRange(id: 1, range: "Price Range"),
            nearestStation: "",
            notes: "",
            photoUrls: []
        )

        let nearestStationCell = getNearestStationTableViewCell()
        nearestStationCell.textField.text = "Roppongi"
        let notesCell = getNotesTableViewCell()
        notesCell.notesTextField.text = "Notes"
        fakePhotoRepo.uploadPhotos_returnValue = ["apple", "truck"]


        let saveButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(saveButton)


        let newRestaurant = fakeRestaurantRepo.create_args
        expect(newRestaurant.name).to(equal("Some Restaurant"))
        expect(newRestaurant.address).to(equal("Address"))
        expect(newRestaurant.placeId).to(equal("abcd"))
        expect(newRestaurant.latitude).to(equal(1.23))
        expect(newRestaurant.longitude).to(equal(2.34))
        expect(newRestaurant.cuisine?.name).to(equal("Cuisine Type"))
        expect(newRestaurant.priceRange?.id).to(equal(1))
        expect(newRestaurant.priceRange?.range).to(equal("Price Range"))
        expect(newRestaurant.nearestStation).to(equal("Roppongi"))
        expect(newRestaurant.notes).to(equal("Notes"))
        expect(newRestaurant.photoUrls).to(equal(["apple", "truck"]));
    }

    func test_tappingSaveButton_returnsToListScreen() {
        let saveButton = newRestaurantVC.navigationItem.rightBarButtonItem!


        tapNavBarButton(saveButton)
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

    // MARK: - Find Restaurant
    func test_selectSearchResultRestaurant_populatesNameAndAddressTextfields() {
        let selectedSearchResultRestaurant = RestaurantSuggestion(
            name: "Afuri",
            address: "Roppongi Hills 5-2-1",
            placeId: "",
            latitude: 0.0,
            longitude: 0.0
        )


        newRestaurantVC.searchResultRestaurantSelected(selectedSearchResultRestaurant)


        let populatedCell = getPopulatedRestaurantTableViewCell()
        expect(populatedCell?.textLabel?.text)
            .to(equal("Afuri"))
        expect(populatedCell?.detailTextLabel?.text)
            .to(equal("Roppongi Hills 5-2-1"))
    }

    func test_selectSearchResultRestaurant_populatesNewRestaurant() {
        let selectedSearchResultRestaurant = RestaurantSuggestion(
            name: "Afuri",
            address: "Roppongi Hills 5-2-1",
            placeId: "ChIJgYtUxUGLGGAR2LLtCdmLFbs",
            latitude: 35.648355,
            longitude: 139.710893
        )


        newRestaurantVC.searchResultRestaurantSelected(selectedSearchResultRestaurant)

        expect(self.newRestaurantVC.newRestaurant.name).to(equal("Afuri"))
        expect(self.newRestaurantVC.newRestaurant.address).to(equal("Roppongi Hills 5-2-1"))
        expect(self.newRestaurantVC.newRestaurant.placeId).to(equal("ChIJgYtUxUGLGGAR2LLtCdmLFbs"))
        expect(self.newRestaurantVC.newRestaurant.latitude).to(equal(35.648355))
        expect(self.newRestaurantVC.newRestaurant.longitude).to(equal(139.710893))
    }

    func test_selectSearchResultRestaurant_changesFindRestaurantCellTypeToPopulated() {
        let selectedSearchResultRestaurant = RestaurantSuggestion(
            name: "Afuri",
            address: "Roppongi Hills 5-2-1",
            placeId: "",
            latitude: 0.0,
            longitude: 0.0
        )


        newRestaurantVC.searchResultRestaurantSelected(selectedSearchResultRestaurant)


        expect(self.getPopulatedRestaurantTableViewCell()).toNot(beNil())
    }
    
    func test_selectSearchResultRestaurant_reloadsTableView() {
        let selectedSearchResultRestaurant = RestaurantSuggestion(
            name: "", address: "", placeId: "", latitude: 0.0, longitude: 0.0
        )


        newRestaurantVC.searchResultRestaurantSelected(selectedSearchResultRestaurant)


        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    // MARK: - Select Cuisine
    func test_selectCuisine_populatesCuisineTextfield() {
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")


        newRestaurantVC.cuisineSelected(selectedCuisine)


        let cuisineCell = getCuisineTableViewCell()
        expect(cuisineCell.textLabel?.text).to(equal("Hamburger"))
    }

    func test_selectCuisine_reloadsTableView() {
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")

        newRestaurantVC.cuisineSelected(selectedCuisine)

        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    // MARK: - Price Range
    func test_selectPriceRange_populatesPriceRangeTextfield() {
        let selectedPriceRange = PriceRange(id: 1, range: "0~999")


        newRestaurantVC.priceRangeSelected(selectedPriceRange)


        let priceRangeCell = getPriceRangeTableViewCell()
        expect(priceRangeCell.textLabel?.text).to(equal("0~999"))
    }

    func test_selectPriceRange_reloadsTableView() {
        let selectedPriceRange = PriceRange(id: 1, range: "0~999")


        newRestaurantVC.priceRangeSelected(selectedPriceRange)

        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    // MARK: - Private Methods
    private func getAddRestaurantPhotosTableViewCell() -> AddRestaurantPhotosTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.AddPhotosCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! AddRestaurantPhotosTableViewCell
    }

    private func getNotesTableViewCell() -> NotesTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.NotesCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! NotesTableViewCell
    }

    private func getFindRestaurantTableViewCell() -> FindRestaurantTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.FindRestaurantCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! FindRestaurantTableViewCell
    }

    private func getPopulatedRestaurantTableViewCell() -> PopulatedRestaurantTableViewCell? {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.FindRestaurantCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
            ) as? PopulatedRestaurantTableViewCell
    }

    private func getCuisineTableViewCell() -> CuisineTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.CuisineCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
        ) as! CuisineTableViewCell
    }

    private func getPriceRangeTableViewCell() -> PriceRangeTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.PriceRangeCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
        ) as! PriceRangeTableViewCell
    }

    private func getNearestStationTableViewCell() -> NearestStationTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.NearestStationCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
        ) as! NearestStationTableViewCell
    }
}
