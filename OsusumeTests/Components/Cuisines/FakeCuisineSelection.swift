@testable import Osusume

class FakeCuisineSelection: CuisineSelectionProtocol {
    var cuisineSelected_wasCalled = false
    var selectedCuisine = Cuisine(id: 0, name: "")
    func cuisineSelected(cuisine: Cuisine) {
        cuisineSelected_wasCalled = true
        selectedCuisine = cuisine
    }
}
