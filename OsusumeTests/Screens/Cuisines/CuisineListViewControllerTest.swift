import UIKit
import Nimble
import XCTest
import BrightFutures
@testable import Osusume

class CuisineListViewControllerTest: XCTestCase {
    let fakeRouter: FakeRouter = FakeRouter()
    let fakeCuisineRepo = FakeCuisineRepo()
    let fakeTextSearch = FakeTextSearch()
    let fakeReloader = FakeReloader()
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
            reloader: fakeReloader
        )
    }

    func test_addCuisineTitle_isShown() {
        cuisineListVC.view.setNeedsLayout()

        expect(self.cuisineListVC.title).to(equal("Find Cuisine"))
    }

    func test_tapCancelButton_navigatesBackToPreviousScreen() {
        cuisineListVC.view.setNeedsLayout()

        let cancelButton = cuisineListVC.navigationItem.leftBarButtonItem! as UIBarButtonItem


        tapNavBarButton(cancelButton)


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    func test_tableView_configuresCuisineCells() {
        let promise = Promise<[Cuisine], RepoError>()
        fakeCuisineRepo.getAll_returnValue = promise.future


        cuisineListVC.view.setNeedsLayout()
        promise.success([Cuisine(id: 0, name: "Soba!")])
        NSRunLoop.osu_advance()


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
        cuisineListVC.view.setNeedsLayout()


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
        cuisineListVC.view.setNeedsLayout()

        expect(self.cuisineListVC.fullCuisineList)
            .to(equal([]))

        cuisinePromise.success(fullCuisineList)
        NSRunLoop.osu_advance()

        expect(self.cuisineListVC.fullCuisineList).to(equal(fullCuisineList))
    }

    func test_initialization_assignsTheControllerAsSearchBarDelegate() {
        cuisineListVC.view.setNeedsLayout()

        let expectedDelegate = cuisineListVC as UISearchBarDelegate

        XCTAssert(cuisineListVC.searchBar.delegate! === expectedDelegate)
    }

    func test_search_delegatesToTheTextSearch() {
        let promise = Promise<[Cuisine], RepoError>()
        fakeCuisineRepo.getAll_returnValue = promise.future

        cuisineListVC.view.setNeedsLayout()
        promise.success(fullCuisineList)
        NSRunLoop.osu_advance()


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
        cuisineListVC.view.setNeedsLayout()

        let expectedDelegate = self.cuisineListVC.tableView.delegate as! CuisineListViewController

        XCTAssert(self.cuisineListVC === expectedDelegate)
    }

    func test_tappingCuisineCell_callsCuisineDelegate() {
        let promise = Promise<[Cuisine], RepoError>()
        fakeCuisineRepo.getAll_returnValue = promise.future

        cuisineListVC.view.setNeedsLayout()

        promise.success([Cuisine(id: 0, name: "Soba!")])
        NSRunLoop.osu_advance()

        let fakeCuisineSelection = FakeCuisineSelection()
        cuisineListVC.cuisineSelectionDelegate = fakeCuisineSelection


        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)
        )


        expect(fakeCuisineSelection.cuisineSelected_returnValue).to(equal(Cuisine(id: 0, name: "Soba!")))
        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    func test_tappingAddCuisineCell_callsAddCuisineOnCuisineRepo() {
        let fakeCuisineSelection = FakeCuisineSelection()
        cuisineListVC.cuisineSelectionDelegate = fakeCuisineSelection
        cuisineListVC.searchBar.text = "Pie"


        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeCuisineRepo.create_wasCalled).to(equal(true))
        expect(self.fakeCuisineRepo.create_arg).to(equal(NewCuisine(name: "Pie")))
        expect(fakeCuisineSelection.cuisineSelected_wasCalled).to(equal(false))
        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(equal(false))
    }

    func test_tappingAddCuisineCell_uponSuccessfulCuisineCreation() {
        let promise = Promise<Cuisine, RepoError>()
        fakeCuisineRepo.create_returnValue = promise.future
        let fakeCuisineSelection = FakeCuisineSelection()
        cuisineListVC.cuisineSelectionDelegate = fakeCuisineSelection
        cuisineListVC.searchBar.text = "Pie"


        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )

        let expectedCuisine = Cuisine(id: 1, name: "Pie")
        promise.success(expectedCuisine)
        NSRunLoop.osu_advance()

        expect(fakeCuisineSelection.cuisineSelected_returnValue).to(equal(expectedCuisine))
        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(equal(true))
    }

    func test_cuisineRepoGetAllSuccess_reloadsTableView() {
        cuisineListVC.view.setNeedsLayout()


        cuisinePromise.success(fullCuisineList)
        NSRunLoop.osu_advance()


        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
        expect(self.cuisineListVC.filteredCuisineList).to(equal(fullCuisineList))
    }

    func test_searchBarDelegateMethod_reloadsTableView() {
        cuisineListVC.view.setNeedsLayout()


        cuisineListVC.searchBar(UISearchBar(), textDidChange: "text")


        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
    }
}
