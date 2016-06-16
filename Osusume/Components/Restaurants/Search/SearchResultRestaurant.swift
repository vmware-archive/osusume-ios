import Foundation

struct SearchResultRestaurant {
    let id: String
    let name: String
    let address: String
}

extension SearchResultRestaurant: Equatable {}

func ==(lhs: SearchResultRestaurant, rhs: SearchResultRestaurant) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.address == rhs.address
}