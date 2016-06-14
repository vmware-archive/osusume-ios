import XCTest
import Nimble
@testable import Osusume

class PopulatedRestaurantTableViewCellTest: XCTestCase {

    func test_cellDisplaysDetailIndicator() {
        let populatedRestaurantCell = PopulatedRestaurantTableViewCell()


        expect(populatedRestaurantCell.accessoryType)
            .to(equal(UITableViewCellAccessoryType.DisclosureIndicator))
    }

}