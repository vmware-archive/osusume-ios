@testable import Osusume

struct RestaurantFixtures {
    static func newRestaurant(
        id id: Int = 1,
        name: String = "Danny's Diner",
        address: String = "Original Address",
        offersEnglishMenu: Bool = true,
        acceptsCreditCards: Bool = true,
        notes: String = "This place is great",
        liked: Bool = true,
        numberOfLikes: Int = 0,
        photoUrl: String = "http://www.example.com/cat.jpg",
        cuisine: Cuisine = Cuisine(id: 0, name: "Not Specified"),
        priceRange: String = "",
        comments: [PersistedComment] = []
        ) -> Restaurant
    {
        return Restaurant(
            id: id,
            name: name,
            address: address,
            cuisineType: "",
            cuisine: cuisine,
            offersEnglishMenu: offersEnglishMenu,
            walkInsOk: false,
            acceptsCreditCards: acceptsCreditCards,
            notes: notes,
            author: "",
            liked: liked,
            numberOfLikes: numberOfLikes,
            priceRange: priceRange,
            createdAt: NSDate(),
            photoUrls: [
                NSURL(string: photoUrl)!
            ],
            comments: comments
        )
    }
}
