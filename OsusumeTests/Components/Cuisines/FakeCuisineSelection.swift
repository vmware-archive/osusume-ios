@testable import Osusume

class FakeCuisineSelection: CuisineSelectionDelegate {
    var cuisineSelected_wasCalled = false
    var cuisineSelected_returnValue = Cuisine(id: 0, name: "")
    func cuisineSelected(cuisine: Cuisine) {
        cuisineSelected_wasCalled = true
        cuisineSelected_returnValue = cuisine
    }
}
