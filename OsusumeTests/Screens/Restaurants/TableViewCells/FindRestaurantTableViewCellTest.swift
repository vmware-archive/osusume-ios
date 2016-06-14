import XCTest
import Nimble
@testable import Osusume

class FindRestaurantTableViewCellTest: XCTestCase {

    func test_cellDisplaysDetailIndicator() {
        let findRestaurantCell = FindRestaurantTableViewCell()


        expect(findRestaurantCell.accessoryType)
            .to(equal(UITableViewCellAccessoryType.DisclosureIndicator))
    }

}
