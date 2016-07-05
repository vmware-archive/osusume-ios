@testable import Osusume

class FakeSearchResultRestaurantSelectionDelegate: SearchResultRestaurantSelectionDelegate {
    var restaurantSelected_arg = RestaurantSuggestion(name: "", address: "", placeId: "", latitude: 0.0, longitude: 0.0)
    func searchResultRestaurantSelected(restaurantSuggestion: RestaurantSuggestion) {
        restaurantSelected_arg = restaurantSuggestion
    }
}
