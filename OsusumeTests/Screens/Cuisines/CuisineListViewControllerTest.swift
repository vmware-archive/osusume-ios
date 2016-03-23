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
    let cuisineList = [Cuisine(id: 1, name: "Soba!")]
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


        expect(self.fakeRouter.dismissFindCuisineScreen_wasCalled).to(beTrue())
    }

    func test_tableView_configuresCuisineCells() {
        cuisineListVC.cuisineList = cuisineList
        cuisineListVC.tableView.reloadData()


        cuisineListVC.view.setNeedsLayout()


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

    func test_initialization_savesFullCuisineList() {
        cuisineListVC.view.setNeedsLayout()

        expect(self.cuisineListVC.fullCuisineList)
            .to(equal([]))

        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()

        expect(self.cuisineListVC.fullCuisineList).to(equal(cuisineList))
    }

    func test_initialization_assignsTheControllerAsSearchBarDelegate() {
        let expectedDelegate = cuisineListVC as UISearchBarDelegate

        XCTAssert(cuisineListVC.searchBar.delegate! === expectedDelegate)
    }

    func test_search_delegatesToTheTextSearch() {
        cuisineListVC.fullCuisineList = cuisineList

        cuisineListVC.searchBar(UISearchBar(), textDidChange: "my search")

        expect(self.fakeTextSearch.search_wasCalled).to(equal(true))
        expect(self.fakeTextSearch.search_args.searchTerm).to(equal("my search"))
        expect(self.fakeTextSearch.search_args.collection).to(equal(cuisineList))
    }

    func test_search_assignsNewCuisineList() {
        let japaneseCuisine = Cuisine(id: 1, name: "Japanese")
        let filteredCuisineArray = [japaneseCuisine]
        fakeTextSearch.search_returnValue = filteredCuisineArray


        cuisineListVC.searchBar(UISearchBar(), textDidChange: "my search")


        expect(self.cuisineListVC.cuisineList).to(equal(filteredCuisineArray))
    }

    func test_tableView_hasAConfiguredDelegate() {
        let expectedDelegate = self.cuisineListVC.tableView.delegate as! CuisineListViewController

        XCTAssert(self.cuisineListVC === expectedDelegate)
    }

    func test_tappingCuisineCell_callsCuisineDelegate() {
        cuisineListVC.view.setNeedsLayout()

        let fakeCuisineSelection = FakeCuisineSelection()
        cuisineListVC.cuisineSelectionDelegate = fakeCuisineSelection
        cuisineListVC.cuisineList = [Cuisine(id: 1, name: "Soba!")]

        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)
        )


        expect(fakeCuisineSelection.selectedCuisine).to(equal(Cuisine(id: 1, name: "Soba!")))
        expect(self.fakeRouter.dismissFindCuisineScreen_wasCalled).to(beTrue())
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
        expect(self.fakeRouter.dismissFindCuisineScreen_wasCalled).to(equal(false))
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

        expect(fakeCuisineSelection.selectedCuisine).to(equal(expectedCuisine))
        expect(self.fakeRouter.dismissFindCuisineScreen_wasCalled).to(equal(true))
    }

    func test_cuisineRepoGetAllSuccess_reloadsTableView() {
        cuisineListVC.view.setNeedsLayout()


        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()


        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
        expect(self.cuisineListVC.cuisineList).to(equal(cuisineList))
    }

    func test_searchBarDelegateMethod_reloadsTableView() {
        cuisineListVC.view.setNeedsLayout()


        cuisineListVC.searchBar(UISearchBar(), textDidChange: "text")


        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
    }
}
