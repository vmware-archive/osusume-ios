import Foundation

struct RestaurantSuggestion {
    let name: String
    let address: String
}

extension RestaurantSuggestion: Equatable {}

func ==(lhs: RestaurantSuggestion, rhs: RestaurantSuggestion) -> Bool {
    return lhs.name == rhs.name &&
        lhs.address == rhs.address
}