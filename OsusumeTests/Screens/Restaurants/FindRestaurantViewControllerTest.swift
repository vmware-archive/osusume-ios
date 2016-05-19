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
    var restaurantSearchRepoResultPromise: Promise<[SearchResultRestaurant], RepoError>!

    override func setUp() {
        restaurantSearchRepoResultPromise = Promise<[SearchResultRestaurant], RepoError>()
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
            .to(haveConstraints())
        expect(self.findRestaurantViewController.restaurantSearchResultTableView)
            .to(haveConstraints())
    }

    func test_configureNavigationBar_addsCancelButton() {
        expect(self.findRestaurantViewController.navigationItem.leftBarButtonItem?.title)
            .to(equal("Cancel"))
    }

    func test_tappingCancelButton_dismissesFindRestaurantVC() {
        let cancelButton = findRestaurantViewController.navigationItem.leftBarButtonItem!


        tapNavBarButton(cancelButton)


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
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
            SearchResultRestaurant(id: "0", name: "Afuri", address: "Roppongi"),
            SearchResultRestaurant(id: "1", name: "Savoy", address: "Azabu")
        ]


        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success(searchResults)
        NSRunLoop.osu_advance()


        expect(self.findRestaurantViewController.tableView(
            self.findRestaurantViewController.restaurantSearchResultTableView
            , numberOfRowsInSection: 0)).to(equal(2))
    }

    func test_tableView_cellDisplaysSearchResult() {
        let searchResults = [
            SearchResultRestaurant(id: "0", name: "Afuri", address: "Roppongi")
        ]


        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success(searchResults)
        NSRunLoop.osu_advance()


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
        NSRunLoop.osu_advance()


        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    func test_tappingSearchResultCell_callsDismissPresentedViewControllerOnRouter() {
        let searchResults = [
            SearchResultRestaurant(id: "0", name: "Afuri", address: "Roppongi")
        ]

        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success(searchResults)
        NSRunLoop.osu_advance()


        findRestaurantViewController.tableView(
            findRestaurantViewController.restaurantSearchResultTableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    func test_tappingSearchResultCell_passesSelectedRestaurantsInformationToDelegate() {
        let searchResults = [
            SearchResultRestaurant(id: "0", name: "Afuri", address: "Roppongi")
        ]

        findRestaurantViewController.textFieldShouldReturn(
            findRestaurantViewController.restaurantNameTextField
        )
        restaurantSearchRepoResultPromise.success(searchResults)
        NSRunLoop.osu_advance()


        findRestaurantViewController.tableView(
            findRestaurantViewController.restaurantSearchResultTableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeSearchResultRestaurantSelectionDelegate.restaurantSelected_arg)
            .to(equal(searchResults[0]))
    }
}
