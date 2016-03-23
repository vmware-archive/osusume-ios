@testable import Osusume

class FakeCuisineSelection: CuisineSelectionProtocol {
    var selectedCuisine = Cuisine(id: 0, name: "")
    func cuisineSelected(cuisine: Cuisine) {
        selectedCuisine = cuisine
    }
}
