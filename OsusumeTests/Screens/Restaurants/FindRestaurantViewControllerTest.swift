import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class FindRestaurantViewControllerTest: XCTestCase {
    var findRestaurantViewController: FindRestaurantViewController!
    let fakeRouter = FakeRouter()
    let fakeRestaurantSearchRepo = FakeRestaurantSearchRepo()
    let fakeReloader = FakeReloader()
    let fakeSearchResultRestaurantSelectionDelegate = FakeSearchResultRestaurantSelectionDelegate()
    var restaurantSearchRepoResultPromise: Promise<[RestaurantSuggestion], RepoError>!

    override func setUp() {
        restaurantSearchRepoResultPromise = Promise<[RestaurantSuggestion], RepoError>()
        fakeRestaurantSearchRepo.getForSearchTerm_returnValue = restaurantSearchRepoResultPromise.future

        findRestaurantViewController = FindRestaurantViewController(
            router: fakeRouter,
            restaurantSearchRepo: fakeRestaurantSearchRepo,
            reloader: fakeReloader,
            searchResultRestaurantSelectionDelegate: fakeSearchResultRestaurantSelectionDelegate
        )
        findRestaurantViewController.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        expect(self.findRestaurantViewController.title).to(equal("Find a restaurant"))
    }

    func test_viewDidLoad_initializesSubviews() {
        expect(self.findRestaurantViewController.restaurantNameTextField)
            .to(beAKindOf(UITextField))
        expect(self.findRestaurantViewController.restaurantSearchResultTableView)
            .to(beAKindOf(UITableView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.findRestaurantViewController.view)
            .to(containSubview(findRestaurantViewController.restaurantNameTextField))
        expect(self.findRestaurantViewController.view)
            .to(containSubview(findRestaurantViewController.restaurantSearchResultTableView))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.findRestaurantViewController.restaurantNameTextField)
            .to(hasConstraintsToSuperviewOrSelf())
        expect(self.findRestaurantViewController.restaurantSearchResultTableView)
            .to(hasConstraintsToSuperviewOrSelf())
    }

    func test_viewDidAppear_setsRestaurantNameTextFieldAsFirstResponder() {
        configureUIWindowWithRootViewController(findRestaurantViewController)


        findRestaurantViewController.view.setNeedsLayout()
        NSRunLoop.osu_advance()


        expect(self.findRestaurantViewController.restaurantNameTextField.isFirstResponder())
            .to(beTrue())
    }

    func test_viewDidLoad_setsTextFieldDelegate() {
        expect(self.findRestaurantViewController.restaurantNameTextField.delegate === self.findRestaurantViewController).to(beTrue())
    }

    func test_tappingEnterKey_executesSearch() {
        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )


        expect(self.fakeRestaurantSearchRepo.getForSearchTerm_wasCalled).to(beTrue())
    }

    func test_viewDidLoad_setsTableViewDataSource() {
        expect(self.findRestaurantViewController.restaurantSearchResultTableView.dataSource === self.findRestaurantViewController).to(beTrue())
    }

    func test_viewDidLoad_setsTableViewDelegate() {
        expect(self.findRestaurantViewController.restaurantSearchResultTableView.delegate === self.findRestaurantViewController).to(beTrue())
    }

    func test_tableView_containsExpectedNumberOfSections() {
        expect(self.findRestaurantViewController.numberOfSectionsInTableView(
            self.findRestaurantViewController.restaurantSearchResultTableView
        )).to(equal(1))
    }

    func test_tableView_containsExpectedNumberOfRows() {
        let searchResults = [
            RestaurantSuggestion(name: "Afuri", address: "Roppongi", placeId: "", latitude: 0.0, longitude: 0.0),
            RestaurantSuggestion(name: "Savoy", address: "Azabu", placeId: "", latitude: 0.0, longitude: 0.0)
        ]


        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success(searchResults)
        waitForFutureToComplete(restaurantSearchRepoResultPromise.future)

        expect(self.findRestaurantViewController.tableView(
            self.findRestaurantViewController.restaurantSearchResultTableView
            , numberOfRowsInSection: 0)).to(equal(2))
    }

    func test_tableView_cellDisplaysSearchResult() {
        let searchResults = [
            RestaurantSuggestion(name: "Afuri", address: "Roppongi", placeId: "", latitude: 0.0, longitude: 0.0)
        ]


        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success(searchResults)
        waitForFutureToComplete(restaurantSearchRepoResultPromise.future)


        let tableView = findRestaurantViewController.restaurantSearchResultTableView
        let cell = findRestaurantViewController.tableView(
            tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )
        expect(cell.textLabel?.text).to(equal("Afuri"))
        expect(cell.detailTextLabel?.text).to(equal("Roppongi"))
    }

    func test_executingSearch_reloadsTableViewData() {
        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success([])
        waitForFutureToComplete(restaurantSearchRepoResultPromise.future)


        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    func test_tappingSearchResultCell_popsViewController() {
        let searchResults = [
            RestaurantSuggestion(name: "Afuri", address: "Roppongi", placeId: "", latitude: 0.0, longitude: 0.0)
        ]

        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success(searchResults)
        waitForFutureToComplete(restaurantSearchRepoResultPromise.future)


        findRestaurantViewController.tableView(
            findRestaurantViewController.restaurantSearchResultTableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeRouter.popViewControllerOffStack_wasCalled).to(beTrue())
    }

    func test_tappingSearchResultCell_passesSelectedRestaurantsInformationToDelegate() {
        let searchResults = [
            RestaurantSuggestion(name: "Afuri", address: "Roppongi", placeId: "ChIJgYtUxUGLGGAR2LLtCdmLFbs", latitude: 35.648355, longitude: 139.710893)
        ]

        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success(searchResults)
        waitForFutureToComplete(restaurantSearchRepoResultPromise.future)


        findRestaurantViewController.tableView(
            findRestaurantViewController.restaurantSearchResultTableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeSearchResultRestaurantSelectionDelegate.restaurantSelected_arg)
            .to(equal(searchResults[0]))
    }
}
