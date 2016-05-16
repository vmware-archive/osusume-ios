import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class FindRestaurantViewControllerTest: XCTestCase {
    var findRestaurantViewController: FindRestaurantViewController!
    let fakeRouter = FakeRouter()
    let fakeRestaurantSearchRepo = FakeRestaurantSearchRepo()
    var restaurantSearchRepoResultPromise: Promise<[SearchResultRestaurant], RepoError>!

    override func setUp() {
        restaurantSearchRepoResultPromise = Promise<[SearchResultRestaurant], RepoError>()
        fakeRestaurantSearchRepo.getForSearchTerm_returnValue = restaurantSearchRepoResultPromise.future

        findRestaurantViewController = FindRestaurantViewController(
            router: fakeRouter,
            restaurantSearchRepo: fakeRestaurantSearchRepo
        )
        findRestaurantViewController.view.setNeedsLayout()
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

    func test_viewDidAppear_setsRestaurantNameTextFieldAsFirstResponder() {
        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = findRestaurantViewController
        window!.makeKeyAndVisible()


        findRestaurantViewController.view.setNeedsLayout()
        NSRunLoop.osu_advance()


        expect(self.findRestaurantViewController.restaurantNameTextField.isFirstResponder())
            .to(beTrue())
    }

    func test_configureNavigationBar_addsBackButton() {
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
}
