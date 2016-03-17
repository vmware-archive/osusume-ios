import Foundation

@testable import Osusume

struct RestaurantFixtures {
    static func newRestaurant(
        id id: Int = 1,
        name: String = "Danny's Diner",
        liked: Bool = true,
        photoUrl: String = "http://www.example.com/cat.jpg"
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
            liked: liked,
            createdAt: NSDate(),
            photoUrls: [
                NSURL(string: photoUrl)!
            ],
            comments: []
        )
    }
}
