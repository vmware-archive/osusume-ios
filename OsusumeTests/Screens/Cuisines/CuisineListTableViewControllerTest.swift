import UIKit
import Nimble
import XCTest
import BrightFutures
@testable import Osusume

import Foundation

class CuisineListTableViewControllerTest: XCTestCase {

    var cuisineListTVC: CuisineListTableViewController!
    var fakeRouter: FakeRouter!
    var fakeCuisineRepo: FakeCuisineRepo!
    var cuisinePromise: Promise<CuisineList, RepoError>!

    override func setUp() {
        fakeRouter = FakeRouter()
        fakeCuisineRepo = FakeCuisineRepo()

        cuisinePromise = Promise<CuisineList, RepoError>()
        fakeCuisineRepo.getAll_returnValue = cuisinePromise.future

        cuisineListTVC = CuisineListTableViewController(
            router: fakeRouter,
            cuisineRepo: fakeCuisineRepo
        )
        cuisineListTVC.view.setNeedsLayout()
    }

    func test_viewDidLoad_showsCuisineListTableViewWithCuisineData() {
        expect(self.cuisineListTVC.tableView).toNot(beNil())
    }

    func test_addCuisineTitle_isShown() {
        expect(self.cuisineListTVC.title).to(equal("Add Cuisine"))
    }

    func test_cancelButton_isShown() {
        let leftBarButtonItem = cuisineListTVC.navigationItem.leftBarButtonItem! as UIBarButtonItem
        let systemButtonValue = leftBarButtonItem.valueForKey("systemItem") as? Int
        expect(systemButtonValue).to(equal(UIBarButtonSystemItem.Cancel.rawValue))
    }

    func test_tapCancelButton_navigatesBackToPreviousScreen() {
        let cancelButton = cuisineListTVC.navigationItem.leftBarButtonItem! as UIBarButtonItem


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


        expect(self.cuisineListTVC.tableView.numberOfSections).to(equal(1))
        expect(self.cuisineListTVC.tableView.numberOfRowsInSection(0)).to(equal(1))

        let cuisineCell = cuisineListTVC.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        expect(cuisineCell?.textLabel?.text).to(equal("Soba!"))
    }
}
