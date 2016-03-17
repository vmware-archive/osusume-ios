import UIKit
import Nimble
import XCTest
@testable import Osusume

import Foundation

class CuisineListTableViewControllerTest: XCTestCase {

    var cuisineListTVC: CuisineListTableViewController!
    var fakeRouter: FakeRouter!

    override func setUp() {
        fakeRouter = FakeRouter()
        
        cuisineListTVC = CuisineListTableViewController(router: fakeRouter)
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
}
