import UIKit
import Nimble
import XCTest
import BrightFutures
@testable import Osusume

import Foundation

class CuisineListTableViewControllerTest: XCTestCase {

    var cuisineListVC: CuisineListTableViewController!
    var fakeRouter: FakeRouter!
    var fakeCuisineRepo: FakeCuisineRepo!
    var cuisinePromise: Promise<CuisineList, RepoError>!
    var selectedCuisine: Cuisine?

    override func setUp() {
        fakeRouter = FakeRouter()
        fakeCuisineRepo = FakeCuisineRepo()

        cuisinePromise = Promise<CuisineList, RepoError>()
        fakeCuisineRepo.getAll_returnValue = cuisinePromise.future

        cuisineListVC = CuisineListTableViewController(
            router: fakeRouter,
            cuisineRepo: fakeCuisineRepo
        )
        cuisineListVC.view.setNeedsLayout()
    }

    func test_viewDidLoad_showsCuisineListTableViewWithCuisineData() {
        expect(self.cuisineListVC.tableView).toNot(beNil())
    }

    func test_addCuisineTitle_isShown() {
        expect(self.cuisineListVC.title).to(equal("Add Cuisine"))
    }

    func test_cancelButton_isShown() {
        let leftBarButtonItem = cuisineListVC.navigationItem.leftBarButtonItem! as UIBarButtonItem
        let systemButtonValue = leftBarButtonItem.valueForKey("systemItem") as? Int
        expect(systemButtonValue).to(equal(UIBarButtonSystemItem.Cancel.rawValue))
    }

    func test_tapCancelButton_navigatesBackToPreviousScreen() {
        let cancelButton = cuisineListVC.navigationItem.leftBarButtonItem! as UIBarButtonItem


        tapNavBarButton(cancelButton)


        expect(self.fakeRouter.dismissFindCuisineScreen_wasCalled).to(beTrue())
    }

    func test_viewDidLoad_showsCuisines() {
        let cuisineList = CuisineList(cuisines:
            [
                Cuisine(id: 1, name: "Soba!")
            ]
        )


        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()


        expect(self.cuisineListVC.tableView.numberOfSections).to(equal(1))
        expect(self.cuisineListVC.tableView.numberOfRowsInSection(0)).to(equal(1))

        let cuisineCell = cuisineListVC.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        expect(cuisineCell?.textLabel?.text).to(equal("Soba!"))
    }

    func test_tappingCuisineCell_callsCuisineDelegate() {
        cuisineListVC.delegate = self
        let cuisineList = CuisineList(cuisines:
            [
                Cuisine(id: 1, name: "Soba!")
            ]
        )
        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()


        let firstCell = NSIndexPath(forRow: 0, inSection: 0)
        cuisineListVC.tableView(cuisineListVC.tableView, didSelectRowAtIndexPath: firstCell)


        expect(self.selectedCuisine).to(equal(cuisineList.cuisines.first))
    }

    func test_tappingCuisineCell_dismissesFindCuisineScreen() {
        let cuisineList = CuisineList(cuisines:
            [
                Cuisine(id: 1, name: "Soba!")
            ]
        )
        cuisinePromise.success(cuisineList)
        NSRunLoop.osu_advance()


        let firstCell = NSIndexPath(forRow: 0, inSection: 0)
        cuisineListVC.tableView(cuisineListVC.tableView, didSelectRowAtIndexPath: firstCell)


        expect(self.fakeRouter.dismissFindCuisineScreen_wasCalled).to(beTrue())
    }
}

extension CuisineListTableViewControllerTest: CuisineSelectionProtocol {
    func cuisineSelected(cuisine: Cuisine) {
        selectedCuisine = cuisine
    }
}
