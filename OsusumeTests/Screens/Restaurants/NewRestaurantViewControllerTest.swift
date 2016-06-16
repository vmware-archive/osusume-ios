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

    func test_tableView_containsFiveRowsForRestaurantDetails() {
        let numberOfRows = newRestaurantVC.tableView.dataSource?.tableView(
            newRestaurantVC.tableView,
            numberOfRowsInSection: 0
        )


        expect(numberOfRows).to(equal(5))
    }

    // MARK: - Tableview Cell
    func test_tableView_returnsAddRestaurantPhotoTableViewCell() {
        let cell = getAddRestaurantPhotosTableViewCell()


        expect(cell).to(beAKindOf(AddRestaurantPhotosTableViewCell))
    }

    func test_tableView_returnsAddRestaurantFormTableViewCell() {
        let cell = getAddRestaurantFormTableViewCell()


        expect(cell).to(beAKindOf(AddRestaurantFormTableViewCell))
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
            forRow: NewRestuarantTableViewRow.FormDetailsCell.rawValue,
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

    // MARK: - Actions
    func test_tappingDoneButton_savesRestaurant() {
        newRestaurantVC.restaurantSearchResult = (
            name: "Some Restaurant",
            address: ""
        )
        newRestaurantVC.selectedCuisine = Cuisine(id: 1, name: "Restaurant Cuisine Type")
        newRestaurantVC.selectedPriceRange = PriceRange(id: 1, range: "Selected Price Range")

        let cell = getAddRestaurantFormTableViewCell()
        cell.formView.notesTextField.text = "Notes"
        fakePhotoRepo.uploadPhotos_returnValue = ["apple", "truck"]


        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(doneButton)


        let newRestaurant = fakeRestaurantRepo.create_args
        expect(newRestaurant.name).to(equal("Some Restaurant"))
        expect(newRestaurant.address).to(equal(""))
        expect(newRestaurant.cuisineType).to(equal("Restaurant Cuisine Type"))
        expect(newRestaurant.priceRangeId).to(equal(1))
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

    // MARK: - Find Restaurant
    func test_selectSearchResultRestaurant_populatesNameAndAddressTextfields() {
        let selectedSearchResultRestaurant = SearchResultRestaurant(
            id: "1",
            name: "Afuri",
            address: "Roppongi Hills 5-2-1"
        )


        newRestaurantVC.searchResultRestaurantSelected(selectedSearchResultRestaurant)


        let populatedCell = getPopulatedRestaurantTableViewCell()
        expect(populatedCell?.textLabel?.text)
            .to(equal("Afuri"))
        expect(populatedCell?.detailTextLabel?.text)
            .to(equal("Roppongi Hills 5-2-1"))
    }

    func test_selectSearchResultRestaurant_changesFindRestaurantCellTypeToPopulated() {
        let selectedSearchResultRestaurant = SearchResultRestaurant(
            id: "1",
            name: "Afuri",
            address: "Roppongi Hills 5-2-1"
        )


        newRestaurantVC.searchResultRestaurantSelected(selectedSearchResultRestaurant)


        expect(self.getPopulatedRestaurantTableViewCell()).toNot(beNil())
    }

    func test_selectSearchResultRestaurant_reloadsTableView() {
        let selectedSearchResultRestaurant = SearchResultRestaurant(
            id: "", name: "", address: ""
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

    private func getAddRestaurantFormTableViewCell() -> AddRestaurantFormTableViewCell {
        let indexPath = NSIndexPath(
            forRow: NewRestuarantTableViewRow.FormDetailsCell.rawValue,
            inSection: 0
        )

        return newRestaurantVC.tableView(
            newRestaurantVC.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! AddRestaurantFormTableViewCell
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
}
