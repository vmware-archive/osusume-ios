import Foundation

struct SearchResultRestaurant {
    let name: String
    let address: String
}

extension SearchResultRestaurant: Equatable {}

func ==(lhs: SearchResultRestaurant, rhs: SearchResultRestaurant) -> Bool {
    return lhs.name == rhs.name &&
        lhs.address == rhs.address
}