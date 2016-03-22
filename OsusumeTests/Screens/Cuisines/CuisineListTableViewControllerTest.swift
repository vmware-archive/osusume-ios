import UIKit
import Nimble
import XCTest
import BrightFutures
@testable import Osusume

class FakeCuisineSelection: CuisineSelectionProtocol {
    var selectedCuisine = Cuisine(id: 0, name: "")
    func cuisineSelected(cuisine: Cuisine) {
        selectedCuisine = cuisine
    }
}

class CuisineListTableViewControllerTest: XCTestCase {
    let fakeRouter: FakeRouter = FakeRouter()
    let fakeCuisineRepo = FakeCuisineRepo()
    let cuisinePromise = Promise<CuisineList, RepoError>()
    let cuisineList = CuisineList(cuisines: [Cuisine(id: 1, name: "Soba!")])
    var selectedCuisine: Cuisine?

    var cuisineListVC: CuisineListTableViewController!

    override func setUp() {
        fakeCuisineRepo.getAll_returnValue = cuisinePromise.future

        cuisineListVC = CuisineListTableViewController(
            router: fakeRouter,
            cuisineRepo: fakeCuisineRepo
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

    func test_viewDidLoad_showsCuisines() {
        cuisineListVC.view.setNeedsLayout()

        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()

        expect(self.cuisineListVC.tableView.numberOfRowsInSection(0)).to(equal(1))

        let cuisineCell = cuisineListVC.tableView.cellForRowAtIndexPath(
            NSIndexPath(forRow: 0, inSection: 0)
        )
        expect(cuisineCell?.textLabel?.text).to(equal("Soba!"))
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
