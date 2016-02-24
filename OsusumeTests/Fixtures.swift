import Foundation

@testable import Osusume

struct Fixtures {
    static func newRestaurant(
        id id: Int = 1,
        name: String = "Danny's Diner"
        ) -> Restaurant
    {
        return Restaurant(
            id: id,
            name: name,
            address: "",
            cuisineType: "",
            offersEnglishMenu: false,
            walkInsOk: false,
            acceptsCreditCards: false,
            notes: "",
            author: "",
            createdAt: NSDate(),
            photoUrls: []
        )
    }
}
