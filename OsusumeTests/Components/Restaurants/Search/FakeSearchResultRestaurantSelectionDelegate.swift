@testable import Osusume

class FakeSearchResultRestaurantSelectionDelegate: SearchResultRestaurantSelectionDelegate {
    var restaurantSelected_arg = SearchResultRestaurant(id: "-1", name: "", address: "")
    func searchResultRestaurantSelected(searchResultRestaurant: SearchResultRestaurant) {
        restaurantSelected_arg = searchResultRestaurant
    }
}
