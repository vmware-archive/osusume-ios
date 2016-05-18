@testable import Osusume

struct RestaurantFixtures {
    static func newRestaurant(
        id id: Int = 1,
        name: String = "Danny's Diner",
        address: String = "Original Address",
        offersEnglishMenu: Bool = true,
        walkInsOk: Bool = false,
        acceptsCreditCards: Bool = true,
        notes: String = "This place is great",
        createdAt: NSDate = NSDate(),
        author: String = "danny",
        liked: Bool = false,
        numberOfLikes: Int = 0,
        photoUrls: [NSURL] = [],
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
            walkInsOk: walkInsOk,
            acceptsCreditCards: acceptsCreditCards,
            notes: notes,
            author: author,
            liked: liked,
            numberOfLikes: numberOfLikes,
            priceRange: priceRange,
            createdAt: createdAt,
            photoUrls: photoUrls,
            comments: comments
        )
    }
}
