import UIKit
import Nimble
import XCTest
@testable import Osusume

import Foundation

class CuisineListTableViewControllerTest: XCTestCase {
    func test_viewDidLoad_showsCuisineListTableViewWithCuisineData() {
        let cuisineListTVC = CuisineListTableViewController()
        cuisineListTVC.view.setNeedsLayout()

        expect(cuisineListTVC.tableView).toNot(beNil())
    }
}
