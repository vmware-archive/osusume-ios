import XCTest
import Nimble
@testable import Osusume

class EditRestaurantViewControllerTest: XCTestCase {
    var editRestaurantViewController: EditRestaurantViewController!
    var fakeRouter: FakeRouter!
    var fakeRestaurantRepo: FakeRestaurantRepo!
    var fakePhotoRepo: FakePhotoRepo!
    var fakeSessionRepo: FakeSessionRepo!
    var fakeImagePicker: FakeImagePicker!
    var fakeReloader: FakeReloader!


    override func setUp() {
        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakePhotoRepo = FakePhotoRepo()
        fakeSessionRepo = FakeSessionRepo()
        fakeImagePicker = FakeImagePicker()
        fakeReloader = FakeReloader()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))


        expect(self.editRestaurantViewController.title).to(equal("Edit Restaurant"))
    }

    func test_viewDidLoad_initializesSubviews() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))

        expect(self.editRestaurantViewController.tableView)
            .to(beAKindOf(UITableView))
    }

    func test_viewDidLoad_addsSubviews() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))

        expect(self.editRestaurantViewController.view)
            .to(containSubview(editRestaurantViewController.tableView))
    }

    func test_viewDidLoad_addsConstraints() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        
        expect(self.editRestaurantViewController.tableView)
            .to(hasConstraintsToSuperviewOrSelf())
    }

    // MARK: - Tableview
    func test_tableView_setsDatasource() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        
        expect(self.editRestaurantViewController.tableView.dataSource === self.editRestaurantViewController).to(beTrue())
    }
    
    func test_tableView_setsDelegate() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        
        expect(self.editRestaurantViewController.tableView.delegate === self.editRestaurantViewController).to(beTrue())
    }
    
    func test_tableView_containsSingleSection() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))

        let numberOfSections = editRestaurantViewController.tableView.numberOfSections
        
        
        expect(numberOfSections).to(equal(1))
    }

    func test_tableView_containsOneRowsForRestaurantDetails() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))

        let numberOfRows = editRestaurantViewController.tableView.dataSource?.tableView(
            editRestaurantViewController.tableView,
            numberOfRowsInSection: 0
        )
        
        
        expect(numberOfRows).to(equal(EditRestaurantTableViewRow.count))
    }

    func test_tableView_setsAutomaticRowHeight() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        
        expect(self.editRestaurantViewController.tableView.rowHeight).to(equal(UITableViewAutomaticDimension))
        expect(self.editRestaurantViewController.tableView.estimatedRowHeight).to(equal(44.0))
    }

    
    // MARK: - Tableview Cell
    func test_tableView_returnsEditRestaurantPhotoTableViewCell() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let cell = getEditRestaurantPhotosTableViewCell()
        
        
        expect(cell).to(beAKindOf(EditRestaurantPhotosTableViewCell))
    }
    
    func test_tableView_setsPhotoUrlsDataSourceForPhotoTableViewCell() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let cell = getEditRestaurantPhotosTableViewCell()
        
        
        expect(cell.imageCollectionView.dataSource === self.editRestaurantViewController.photoUrlDataSource).to(beTrue())
    }

    func test_tableView_returnsFindRestaurantTableViewCell() {
        instantiateEditRestaurantVCWithCuisine("", cuisine: Cuisine(id: 1, name: "Pizza"))
        let cell = getFindRestaurantTableViewCell()
        
        
        expect(cell).to(beAKindOf(FindRestaurantTableViewCell))
    }

    func test_tableView_returnsPopulatedRestaurantTableViewCell() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let cell = getPopulatedRestaurantTableViewCell()
        
        
        expect(cell).to(beAKindOf(PopulatedRestaurantTableViewCell))
    }

    func test_tableView_returnsCuisineTableViewCell() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let cell = getCuisineTableViewCell()
        
        
        expect(cell).to(beAKindOf(CuisineTableViewCell))
    }
    
    func test_tableView_returnsPriceRangeTableViewCell() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let cell = getPriceRangeTableViewCell()
        
        
        expect(cell).to(beAKindOf(PriceRangeTableViewCell))
    }

    func test_tableView_returnsEditRestaurantFormTableViewCell() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let cell = getEditRestaurantNotesTableViewCell()
        
        
        expect(cell).to(beAKindOf(NotesTableViewCell))
    }

    // MARK: - Find Restaurant
    func test_tappingFindRestaurantCell_showsFindRestaurantScreen() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.FindRestaurantCell.rawValue,
            inSection: 0
        )

        
        editRestaurantViewController.tableView.delegate?.tableView!(
            editRestaurantViewController.tableView,
            didSelectRowAtIndexPath: indexPath
        )
        
        
        expect(self.fakeRouter.showFindRestaurantScreen_wasCalled).to(beTrue())
    }
 
    func test_selectSearchResultRestaurant_populatesNameAndAddressTextfields() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let selectedSearchResultRestaurant = SearchResultRestaurant(
            name: "Afuri",
            address: "Roppongi Hills 5-2-1"
        )
        
        
        editRestaurantViewController.searchResultRestaurantSelected(selectedSearchResultRestaurant)
        
        
        let populatedCell = getPopulatedRestaurantTableViewCell()
        expect(populatedCell.textLabel?.text).to(equal("Afuri"))
        expect(populatedCell.detailTextLabel?.text).to(equal("Roppongi Hills 5-2-1"))
    }
    
    func test_selectSearchResultRestaurant_changesFindRestaurantCellTypeToPopulated() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let selectedSearchResultRestaurant = SearchResultRestaurant(
            name: "Afuri",
            address: "Roppongi Hills 5-2-1"
        )
        
        
        editRestaurantViewController.searchResultRestaurantSelected(selectedSearchResultRestaurant)
        
        
        expect(self.getPopulatedRestaurantTableViewCell()).toNot(beNil())
    }

    func test_selectSearchResultRestaurant_reloadsTableView() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let selectedSearchResultRestaurant = SearchResultRestaurant(name: "", address: "")
        
        
        editRestaurantViewController.searchResultRestaurantSelected(selectedSearchResultRestaurant)
        
        
        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    // MARK: - Cuisine
    func test_tappingCuisineCell_showsSelectCuisineScreen() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.CuisineCell.rawValue,
            inSection: 0
        )
        
        
        editRestaurantViewController.tableView.delegate?.tableView!(
            editRestaurantViewController.tableView,
            didSelectRowAtIndexPath: indexPath
        )
        
        
        expect(self.fakeRouter.showFindCuisineScreen_wasCalled).to(beTrue())
    }

    func test_selectCuisine_populatesCuisineField() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let cuisine = Cuisine(
            id: 2,
            name: "Beer"
        )
        
        
        editRestaurantViewController.cuisineSelected(cuisine)
        
        
        let cuisineCell = getCuisineTableViewCell()
        expect(cuisineCell.textLabel?.text).to(equal("Beer"))
    }

    func test_selectCuisine_reloadsTableView() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let cuisine = Cuisine(
            id: 0,
            name: "Not Selected"
        )

        
        editRestaurantViewController.cuisineSelected(cuisine)
        
        
        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }
    
    // MARK: - PriceRange
    func test_tappingPriceRangeCell_showsSelectPriceRangeScreen() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.PriceRangeCell.rawValue,
            inSection: 0
        )
        
        
        editRestaurantViewController.tableView.delegate?.tableView!(
            editRestaurantViewController.tableView,
            didSelectRowAtIndexPath: indexPath
        )
        
        
        expect(self.fakeRouter.showPriceRangeListScreen_wasCalled).to(beTrue())
    }
    
    func test_selectPriceRange_populatesPriceRangeField() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let priceRange = PriceRange(
            id: 2,
            range: "2000-3000"
        )
        
        
        editRestaurantViewController.priceRangeSelected(priceRange)
        
        
        let priceRangeCell = getPriceRangeTableViewCell()
        expect(priceRangeCell.textLabel?.text).to(equal("2000-3000"))
    }
    
    func test_selectPriceRange_reloadsTableView() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))
        let priceRange = PriceRange(
            id: 2,
            range: "2000-3000"
        )
        
        
        editRestaurantViewController.priceRangeSelected(priceRange)
        
        
        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }



    // MARK: Delete button
    func test_tappingDeleteButton_callsIntoPhotoRepo() {
        instantiateEditRestaurantVCWithCuisine(
            cuisine: Cuisine(id: 1, name: "Pizza"),
            photoUrls: [PhotoUrl(id: 10, url: NSURL(string: "url")!)]
        )
        let imageCollectionView = getEditRestaurantPhotosTableViewCell().imageCollectionView

        let cell = imageCollectionView.dataSource?.collectionView(
            imageCollectionView,
            cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        ) as! PhotoCollectionViewCell
        
        tapButton(cell.deleteButton)


        expect(self.fakePhotoRepo.deletePhoto_wasCalled).to(beTrue())
        expect(self.fakePhotoRepo.deletePhoto_args.restaurantId).to(equal(5))
        expect(self.fakePhotoRepo.deletePhoto_args.photoUrlId).to(equal(10))
    }

    func test_tappingDeleteButton_deletePhotoUrlFromRestaurant() {
        instantiateEditRestaurantVCWithCuisine(
            cuisine: Cuisine(id: 1, name: "Pizza"),
            photoUrls: [PhotoUrl(id: 10, url: NSURL(string: "url")!)]
        )

        let imageCollectionView = getEditRestaurantPhotosTableViewCell().imageCollectionView

        let cell = imageCollectionView.dataSource?.collectionView(
            imageCollectionView,
            cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        ) as! PhotoCollectionViewCell


        tapButton(cell.deleteButton)


        expect(self.editRestaurantViewController.restaurant.photoUrls.count).to(equal(0))
    }

    func test_tappingDeleteButton_reloadsCollectionView() {
        instantiateEditRestaurantVCWithCuisine(
            cuisine: Cuisine(id: 1, name: "Pizza"),
            photoUrls: [PhotoUrl(id: 10, url: NSURL(string: "url")!)]
        )

        let imageCollectionView = getEditRestaurantPhotosTableViewCell().imageCollectionView
        
        let cell = imageCollectionView.dataSource?.collectionView(
            imageCollectionView,
            cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        ) as! PhotoCollectionViewCell


        tapButton(cell.deleteButton)


        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    func test_viewDidLoad_setsImageCollectionViewDataSource() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))


        let imageCollectionView = getEditRestaurantPhotosTableViewCell().imageCollectionView

        expect(imageCollectionView.dataSource).toNot(beNil())
        expect(imageCollectionView.dataSource is PhotoUrlsCollectionViewDataSource).to(beTrue())
    }

    func test_populatesRestaurantDetailsInFields() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))

        let restaurantDetailCell = getPopulatedRestaurantTableViewCell()
        let cuisineCell = getCuisineTableViewCell()
        let priceRangeCell = getPriceRangeTableViewCell()
        let notesCell = getEditRestaurantNotesTableViewCell()

        expect(restaurantDetailCell.textLabel?.text).to(equal("Original Restaurant Name"))
        expect(restaurantDetailCell.detailTextLabel?.text).to(equal("Original Address"))
        expect(cuisineCell.textLabel?.text).to(equal("Pizza"))
        expect(priceRangeCell.textLabel?.text).to(equal("Cheap"))
        expect(notesCell.formView.notesTextField.text).to(equal("This place is great"))
    }

    func test_setsFindCellText_whenNotSpecified() {
        instantiateEditRestaurantVCWithCuisine("", cuisine: Cuisine(id: 0, name: "Not Specified"), priceRange: PriceRange(id: 0, range: "Not Specified"), notes: "")

        let restaurantDetailCell = getFindRestaurantTableViewCell()
        let cuisineCell = getCuisineTableViewCell()
        let priceRangeCell = getPriceRangeTableViewCell()
        let notesCell = getEditRestaurantNotesTableViewCell()
        
        expect(restaurantDetailCell.textLabel?.text).to(equal("Find restaurant (Required)"))
        expect(cuisineCell.textLabel?.text).to(equal("Select cuisine (Required)"))
        expect(priceRangeCell.textLabel?.text).to(equal("Select price range (Required)"))
        expect(notesCell.formView.notesTextField.text).to(equal(""))
    }

    func test_cannotDeletePhoto_whenRestaurantNotCreatedByCurrentUser() {
        fakeSessionRepo.getAuthenticatedUser_returnValue = AuthenticatedUser(
            id: 10, email: "danny@pivotal", token: "token-string", name: "Danny"
        )
        instantiateEditRestaurantVCWithCuisine(
            cuisine: Cuisine(id: 0, name: "Not Specified"),
            photoUrls: [PhotoUrl(id: 10, url: NSURL(string: "url")!)]
        )


        let imageCollectionView = getEditRestaurantPhotosTableViewCell().imageCollectionView

        let cell = imageCollectionView.dataSource?.collectionView(
                imageCollectionView,
                cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)
        ) as? PhotoCollectionViewCell


        expect(cell!.deleteButton.hidden).to(beTrue())
    }

    // MARK: - Add Photo
    func test_tappingAddPhotoButton_showsPhotoPicker() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 0, name: "Not Specified"))
        let cell = getEditRestaurantPhotosTableViewCell()


        tapButton(cell.addPhotoButton)


        expect(self.fakeImagePicker.bs_presentImagePickerController_wasCalled).to(beTrue())
    }

    // MARK: - Navigation Bar
    func test_tappingCancelButton_dismissesToDetailScreen() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 0, name: "Not Specified"))

        let cancelButton = editRestaurantViewController.navigationItem.leftBarButtonItem!


        tapNavBarButton(cancelButton)
        NSRunLoop.osu_advance()


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    func test_tappingUpdateButton_invokesUpdateWithChangedValues() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))

        let restaurantDetailCell = getPopulatedRestaurantTableViewCell()
        restaurantDetailCell.textLabel?.text = "Updated Restaurant Name"
        editRestaurantViewController.restaurantEditResult.cuisine = Cuisine(id: 2, name: "Beer")
        editRestaurantViewController.restaurantEditResult.priceRange = PriceRange(id: 1, range: "0-1000")

        let cuisineCell = getCuisineTableViewCell()
        cuisineCell.textLabel?.text = "Beer"
        let notesCell = getEditRestaurantNotesTableViewCell()
        notesCell.formView.notesTextField.text = "Try the vegetables!"
        fakePhotoRepo.uploadPhotos_returnValue = ["apple", "truck"]
        
        let updateButton = editRestaurantViewController.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)


        let actualParams = fakeRestaurantRepo.update_params
        expect(actualParams["name"] as? String).to(equal("Updated Restaurant Name"))
        expect(actualParams["address"] as? String).to(equal("Original Address"))
        expect(actualParams["cuisine_type"] as? String).to(equal("Beer"))
        expect(actualParams["cuisine_id"] as? Int).to(equal(2))
        expect(actualParams["price_range_id"] as? Int).to(equal(1))
        expect(actualParams["notes"] as? String).to(equal("Try the vegetables!"))
    }

    func test_tappingUpdateButton_withAddedPhotos_invokesUpdateAddedPhotos() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 1, name: "Pizza"))

        fakePhotoRepo.uploadPhotos_returnValue = ["apple", "truck"]

        let updateButton = editRestaurantViewController.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)


        let actualParams = fakeRestaurantRepo.update_params
        expect(actualParams["photo_urls"] as? [String]).to(equal(["apple", "truck"]))
    }

    func test_tappingUpdateButton_withAddedPhotosAndExistingPhotos_invokesUpdateWithAllPhotos() {
        instantiateEditRestaurantVCWithCuisine(
            cuisine: Cuisine(id: 1, name: "Pizza"),
            photoUrls: [PhotoUrl(id: 1, url: NSURL(string: "orange")!)]
        )

        fakePhotoRepo.uploadPhotos_returnValue = ["apple", "truck"]

        let updateButton = editRestaurantViewController.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)


        let actualParams = fakeRestaurantRepo.update_params
        expect(actualParams["photo_urls"] as? [String]).to(equal(["orange", "apple", "truck"]))
    }

    func test_tappingUpdateButton_returnsToDetailScreen() {
        instantiateEditRestaurantVCWithCuisine(cuisine: Cuisine(id: 0, name: "Not Specified"))
        let updateButton = editRestaurantViewController.navigationItem.rightBarButtonItem!


        tapNavBarButton(updateButton)
        NSRunLoop.osu_advance()


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    // MARK: - Private Methods
    private func instantiateEditRestaurantVCWithCuisine(
        name: String = "Original Restaurant Name",
        cuisine: Cuisine,
        priceRange: PriceRange = PriceRange(id: 1, range: "Cheap"),
        notes: String = "This place is great",
        photoUrls: [PhotoUrl] = [PhotoUrl]())
    {
        let restaurant = RestaurantFixtures.newRestaurant(
            id: 5,
            name: name,
            liked: false,
            cuisine: cuisine,
            notes: notes,
            createdByUser: (id: 99, name: "Witta", email: "witta@pivotal"),
            priceRange: priceRange,
            photoUrls: photoUrls
        )

        editRestaurantViewController = EditRestaurantViewController(
            router: fakeRouter,
            repo: fakeRestaurantRepo,
            photoRepo: fakePhotoRepo,
            sessionRepo: fakeSessionRepo,
            imagePicker: fakeImagePicker,
            reloader: fakeReloader,
            restaurant: restaurant
        )

        editRestaurantViewController.view.setNeedsLayout()
    }
    
    private func getEditRestaurantPhotosTableViewCell() -> EditRestaurantPhotosTableViewCell {
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.EditPhotosCell.rawValue,
            inSection: 0
        )
        
        return editRestaurantViewController.tableView(
            editRestaurantViewController.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! EditRestaurantPhotosTableViewCell
    }

    private func getFindRestaurantTableViewCell() -> FindRestaurantTableViewCell {
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.FindRestaurantCell.rawValue,
            inSection: 0
        )
        
        return editRestaurantViewController.tableView(
            editRestaurantViewController.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! FindRestaurantTableViewCell
    }

    private func getPopulatedRestaurantTableViewCell() -> PopulatedRestaurantTableViewCell {
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.FindRestaurantCell.rawValue,
            inSection: 0
        )
        
        return editRestaurantViewController.tableView(
            editRestaurantViewController.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! PopulatedRestaurantTableViewCell
    }

    private func getCuisineTableViewCell() -> CuisineTableViewCell {
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.CuisineCell.rawValue,
            inSection: 0
        )
        
        return editRestaurantViewController.tableView(
            editRestaurantViewController.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! CuisineTableViewCell
    }
    
    private func getPriceRangeTableViewCell() -> PriceRangeTableViewCell {
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.PriceRangeCell.rawValue,
            inSection: 0
        )
        
        return editRestaurantViewController.tableView(
            editRestaurantViewController.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! PriceRangeTableViewCell
    }

    private func getEditRestaurantNotesTableViewCell() -> NotesTableViewCell {
        let indexPath = NSIndexPath(
            forRow: EditRestaurantTableViewRow.NotesCell.rawValue,
            inSection: 0
        )
        
        return editRestaurantViewController.tableView(
            editRestaurantViewController.tableView,
            cellForRowAtIndexPath: indexPath
            ) as! NotesTableViewCell
    }
}
