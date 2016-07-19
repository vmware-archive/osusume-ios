@testable import Osusume

struct RestaurantFixtures {
    static func newRestaurant(
        id id: Int = 1,
        name: String = "Danny's Diner",
        address: String = "Original Address",
        placeId: String = "abcd",
        latitude: Double = 0.0,
        longitide: Double = 0.0,
        notes: String = "This place is great",
        createdAt: NSDate = NSDate(),
        liked: Bool = false,
        numberOfLikes: Int = 0,
        photoUrls: [PhotoUrl] = [],
        cuisine: Cuisine = Cuisine(id: 0, name: "Not Specified"),
        priceRange: PriceRange = PriceRange(id: 0, range: "Not Specified"),
        nearestStation: String = "Roppongi",
        createdByUser: (id: Int, name: String, email: String) = (id: 99, name: "Danny", email: "danny@pivotal"),
        comments: [PersistedComment] = []
        ) -> Restaurant
    {
        return Restaurant(
            id: id,
            name: name,
            address: address,
            placeId: "",
            latitude: 0,
            longitude: 0,
            cuisineType: "",
            cuisine: cuisine,
            notes: notes,
            liked: liked,
            numberOfLikes: numberOfLikes,
            priceRange: priceRange,
            nearestStation: nearestStation,
            createdAt: createdAt,
            photoUrls: photoUrls,
            createdByUser: createdByUser,
            comments: comments
        )
    }
}
