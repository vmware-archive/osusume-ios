@testable import Osusume

class FakeSearchResultRestaurantSelectionDelegate: SearchResultRestaurantSelectionDelegate {
    var restaurantSelected_arg = SearchResultRestaurant(name: "", address: "")
    func searchResultRestaurantSelected(searchResultRestaurant: SearchResultRestaurant) {
        restaurantSelected_arg = searchResultRestaurant
    }
}
