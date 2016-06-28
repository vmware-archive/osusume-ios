@testable import Osusume

class FakeSearchResultRestaurantSelectionDelegate: SearchResultRestaurantSelectionDelegate {
    var restaurantSelected_arg = RestaurantSuggestion(name: "", address: "")
    func searchResultRestaurantSelected(restaurantSuggestion: RestaurantSuggestion) {
        restaurantSelected_arg = restaurantSuggestion
    }
}
