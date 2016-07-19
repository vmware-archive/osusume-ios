import Nimble
import XCTest
import BrightFutures
@testable import Osusume

class CuisineListViewControllerTest: XCTestCase {
    let fakeRouter: FakeRouter = FakeRouter()
    let fakeCuisineRepo = FakeCuisineRepo()
    let fakeTextSearch = FakeTextSearch()
    let fakeReloader = FakeReloader()
    let fakeCuisineSelection = FakeCuisineSelection()
    let cuisinePromise = Promise<[Cuisine], RepoError>()
    let fullCuisineList = [Cuisine(id: 1, name: "Soba!")]
    var selectedCuisine: Cuisine?

    var cuisineListVC: CuisineListViewController!

    override func setUp() {
        fakeCuisineRepo.getAll_returnValue = cuisinePromise.future

        cuisineListVC = CuisineListViewController(
            router: fakeRouter,
            cuisineRepo: fakeCuisineRepo,
            textSearch: fakeTextSearch,
            reloader: fakeReloader,
            delegate: fakeCuisineSelection
        )

        cuisineListVC.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        expect(self.cuisineListVC.title).to(equal("Find Cuisine"))
    }

    func test_viewDidLoad_registersCellClass() {
        let cell: UITableViewCell? = cuisineListVC.tableView
            .dequeueReusableCellWithIdentifier(String(UITableViewCell))


        expect(cell).toNot(beNil())
    }

    func test_tableView_configuresCuisineCells() {
        cuisinePromise.success([Cuisine(id: 0, name: "Soba!")])
        waitForFutureToComplete(cuisinePromise.future)

        let cuisineCell = cuisineListVC.tableView(
            cuisineListVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)
        )
        expect(self.cuisineListVC.tableView(
            self.cuisineListVC.tableView,
            numberOfRowsInSection: 1)
        ).to(equal(1))
        expect(cuisineCell.textLabel?.text).to(equal("Soba!"))
    }

    func test_tableView_configuresAnAddCuisineCell() {
        let addCuisineCell = cuisineListVC.tableView(
            cuisineListVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )
        expect(addCuisineCell.textLabel?.text).to(equal("Add Cuisine"))
        expect(addCuisineCell.userInteractionEnabled).to(beFalse())
    }

    func test_tableView_hasTwoSections() {
        let sections = cuisineListVC.numberOfSectionsInTableView(
            cuisineListVC.tableView
        )

        expect(sections).to(equal(2))
    }

    func test_tableView_numRowsInAddCuisineSectionIsOne() {
        let numCells = cuisineListVC.tableView(
            cuisineListVC.tableView,
            numberOfRowsInSection: 0
        )

        expect(numCells).to(equal(1))
    }

    func test_viewDidLoad_fetchesFullCuisineList() {
        expect(self.cuisineListVC.fullCuisineList)
            .to(equal([]))

        cuisinePromise.success(fullCuisineList)
        waitForFutureToComplete(cuisinePromise.future)

        expect(self.cuisineListVC.fullCuisineList).to(equal(fullCuisineList))
    }

    func test_initialization_assignsTheControllerAsSearchBarDelegate() {
        let expectedDelegate = cuisineListVC as UISearchBarDelegate

        XCTAssert(cuisineListVC.searchBar.delegate! === expectedDelegate)
    }

    func test_search_delegatesToTheTextSearch() {
        cuisinePromise.success(fullCuisineList)
        waitForFutureToComplete(cuisinePromise.future)


        cuisineListVC.searchBar(UISearchBar(), textDidChange: "my search")


        expect(self.fakeTextSearch.search_wasCalled).to(equal(true))
        expect(self.fakeTextSearch.search_args.searchTerm).to(equal("my search"))
        expect(self.fakeTextSearch.search_args.collection).to(equal(fullCuisineList))
    }

    func test_search_assignsNewCuisineList() {
        let japaneseCuisine = Cuisine(id: 1, name: "Japanese")
        let filteredCuisineArray = [japaneseCuisine]
        fakeTextSearch.search_returnValue = filteredCuisineArray


        cuisineListVC.searchBar(UISearchBar(), textDidChange: "my search")


        expect(self.cuisineListVC.filteredCuisineList).to(equal(filteredCuisineArray))
    }

    func test_search_emptyStringDeactivatesAddCuisineCellFromInteraction() {
        let addCuisineCell = cuisineListVC.tableView(
            cuisineListVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        cuisineListVC.searchBar(UISearchBar(), textDidChange: "")


        expect(addCuisineCell.userInteractionEnabled).to(beFalse())
    }

    func test_loadingAddCuisineCell_callsExactSearch() {
        cuisineListVC.searchBar.text = "J"


        cuisineListVC.tableView(
            cuisineListVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeTextSearch.exactSearch_wasCalled).to(beTrue())
        expect(self.fakeTextSearch.exactSearch_args.searchTerm).to(equal("J"))
        expect(self.fakeTextSearch.exactSearch_args.collection).to(equal(cuisineListVC.filteredCuisineList))
    }

    func test_enableAddCuisineCell_whenReturnsEmptyArray() {
        cuisineListVC.searchBar.text = "J"
        fakeTextSearch.exactSearch_returnValue = []

        let addCuisineCell = cuisineListVC.tableView(
            cuisineListVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )

        expect(addCuisineCell.userInteractionEnabled).to(beTrue())

    }

    func test_disableAddCuisineCell_whenReturnsCuisineArray() {
        cuisineListVC.searchBar.text = "Japanese"
        fakeTextSearch.exactSearch_returnValue = [Cuisine(id: 1, name: "Japanese")]

        let addCuisineCell = cuisineListVC.tableView(
            cuisineListVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )

        expect(addCuisineCell.userInteractionEnabled).to(beFalse())
    }

    func test_tableView_hasAConfiguredDelegate() {
        let expectedDelegate = self.cuisineListVC.tableView.delegate as! CuisineListViewController

        XCTAssert(self.cuisineListVC === expectedDelegate)
    }

    func test_tappingCuisineCell_callsCuisineDelegate() {
        cuisinePromise.success([Cuisine(id: 0, name: "Soba!")])
        waitForFutureToComplete(cuisinePromise.future)


        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)
        )


        expect(self.fakeCuisineSelection.cuisineSelected_returnValue).to(equal(Cuisine(id: 0, name: "Soba!")))
    }

    func test_tappingCuisineCell_popsCuisineListViewController() {
        cuisinePromise.success([Cuisine(id: 0, name: "Soba!")])
        waitForFutureToComplete(cuisinePromise.future)


        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)
        )


        expect(self.fakeRouter.popViewControllerOffStack_wasCalled).to(beTrue())
    }
    
    func test_tappingAddCuisineCell_callsAddCuisineOnCuisineRepo() {
        cuisineListVC.searchBar.text = "Pie"


        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeCuisineRepo.create_wasCalled).to(equal(true))
        expect(self.fakeCuisineRepo.create_arg).to(equal(NewCuisine(name: "Pie")))
        expect(self.fakeCuisineSelection.cuisineSelected_wasCalled).to(equal(false))
        expect(self.fakeRouter.popViewControllerOffStack_wasCalled).to(equal(false))
    }

    func test_tappingAddCuisineCell_uponSuccessfulCuisineCreation() {
        let createCuisinePromise = Promise<Cuisine, RepoError>()
        fakeCuisineRepo.create_returnValue = createCuisinePromise.future
        cuisineListVC.searchBar.text = "Pie"


        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )

        let expectedCuisine = Cuisine(id: 1, name: "Pie")
        createCuisinePromise.success(expectedCuisine)
        waitForFutureToComplete(createCuisinePromise.future)

        expect(self.fakeCuisineSelection.cuisineSelected_returnValue).to(equal(expectedCuisine))
        expect(self.fakeRouter.popViewControllerOffStack_wasCalled).to(equal(true))
    }

    func test_cuisineRepoGetAllSuccess_reloadsTableView() {
        cuisinePromise.success(fullCuisineList)


        waitForFutureToComplete(fakeCuisineRepo.getAll_returnValue)


        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
        expect(self.cuisineListVC.filteredCuisineList).to(equal(fullCuisineList))
    }

    func test_searchBarDelegateMethod_reloadsTableView() {
        cuisineListVC.searchBar(UISearchBar(), textDidChange: "text")


        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
    }
}
