@testable import Osusume

class FakePriceRangeSelectionDelegate: PriceRangeSelectionDelegate {
    var priceRangeSelected_arg = PriceRange(id: -1, range: "")
    func priceRangeSelected(priceRange: PriceRange) {
        priceRangeSelected_arg = priceRange
    }
}
