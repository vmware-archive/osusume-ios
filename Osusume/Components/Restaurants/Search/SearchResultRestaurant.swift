import Foundation

struct RestaurantSuggestion {
    let name: String
    let address: String
    let placeId: String
    let latitude: Double
    let longitude: Double
}

extension RestaurantSuggestion: Equatable {}

func ==(lhs: RestaurantSuggestion, rhs: RestaurantSuggestion) -> Bool {
    return lhs.name == rhs.name &&
        lhs.address == rhs.address &&
        lhs.placeId == rhs.placeId &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
}