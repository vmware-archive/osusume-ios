import UIKit
import Nimble
import XCTest
import BrightFutures
@testable import Osusume

class CuisineListTableViewControllerTest: XCTestCase {
    let fakeRouter: FakeRouter = FakeRouter()
    let fakeCuisineRepo = FakeCuisineRepo()
    let fakeTextSearch = FakeTextSearch()
    let cuisinePromise = Promise<CuisineList, RepoError>()
    let cuisineList = CuisineList(cuisines: [Cuisine(id: 1, name: "Soba!")])
    var selectedCuisine: Cuisine?

    var cuisineListVC: CuisineListTableViewController!

    override func setUp() {
        fakeCuisineRepo.getAll_returnValue = cuisinePromise.future

        cuisineListVC = CuisineListTableViewController(
            router: fakeRouter,
            cuisineRepo: fakeCuisineRepo,
            textSearch: fakeTextSearch
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

    func test_viewDidLoad_showsCuisinesInTableViewCells() {
        cuisineListVC.view.setNeedsLayout()

        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()

        expect(self.cuisineListVC.tableView.numberOfRowsInSection(0)).to(equal(1))

        let cuisineCell = cuisineListVC.tableView.cellForRowAtIndexPath(
            NSIndexPath(forRow: 0, inSection: 0)
        )
        expect(cuisineCell?.textLabel?.text).to(equal("Soba!"))
    }

    // MARK: - UISearchBarDelegate
    func test_initialization_savesFullCuisineList() {
        cuisineListVC.view.setNeedsLayout()

        expect(self.cuisineListVC.fullCuisineList)
            .to(equal(CuisineList(cuisines: [])))

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
        expect(self.fakeTextSearch.search_args.collection).to(equal(cuisineList.cuisines))
    }

    func test_search_assignsNewCuisineList() {
        let japaneseCuisine = Cuisine(id: 1, name: "Japanese")
        let filteredCuisineArray = [japaneseCuisine]
        fakeTextSearch.search_returnValue = filteredCuisineArray


        cuisineListVC.searchBar(UISearchBar(), textDidChange: "my search")


        expect(self.cuisineListVC.cuisineList.cuisines).to(equal(filteredCuisineArray))
    }

    func test_tappingCuisineCell_callsCuisineDelegate() {
        cuisineListVC.view.setNeedsLayout()

        let fakeCuisineSelection = FakeCuisineSelection()
        cuisineListVC.delegate = fakeCuisineSelection
        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()

        let firstCell = NSIndexPath(forRow: 0, inSection: 0)
        cuisineListVC.tableView(
            cuisineListVC.tableView,
            didSelectRowAtIndexPath: firstCell
        )


        expect(fakeCuisineSelection.selectedCuisine).to(equal(cuisineList.cuisines.first))
    }

    func test_tappingCuisineCell_dismissesFindCuisineScreen() {
        cuisineListVC.view.setNeedsLayout()

        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()


        let firstCell = NSIndexPath(forRow: 0, inSection: 0)
        cuisineListVC.tableView(cuisineListVC.tableView, didSelectRowAtIndexPath: firstCell)


        expect(self.fakeRouter.dismissFindCuisineScreen_wasCalled).to(beTrue())
    }
}
