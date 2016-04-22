import Foundation

struct Restaurant {
    var id: Int
    var name: String
    var address: String
    var cuisineType: String
    var cuisine: Cuisine
    var offersEnglishMenu: Bool
    var walkInsOk: Bool
    var acceptsCreditCards: Bool
    var notes: String
    var author: String
    var liked: Bool
    var numberOfLikes: Int
    var priceRange: String
    var createdAt: NSDate?
    var photoUrls: [NSURL]
    var comments: [PersistedComment]

    init(
        id: Int,
        name: String,
        address: String,
        cuisineType: String,
        cuisine: Cuisine,
        offersEnglishMenu: Bool,
        walkInsOk: Bool,
        acceptsCreditCards: Bool,
        notes: String,
        author: String,
        liked: Bool,
        numberOfLikes: Int,
        priceRange: String,
        createdAt: NSDate?,
        photoUrls: [NSURL],
        comments: [PersistedComment]
        )
    {
            self.id = id
            self.name = name
            self.address = address
            self.cuisineType = cuisineType
            self.cuisine = cuisine
            self.offersEnglishMenu = offersEnglishMenu
            self.walkInsOk = walkInsOk
            self.acceptsCreditCards = acceptsCreditCards
            self.notes = notes
            self.author = author
            self.liked = liked
            self.numberOfLikes = numberOfLikes
            self.priceRange = priceRange
            self.createdAt = createdAt
            self.photoUrls = photoUrls
            self.comments = comments
    }
}

extension Restaurant: Equatable {}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.address == rhs.address &&
        lhs.cuisineType == rhs.cuisineType &&
        lhs.cuisine == rhs.cuisine &&
        lhs.offersEnglishMenu == rhs.offersEnglishMenu &&
        lhs.walkInsOk  == rhs.walkInsOk &&
        lhs.acceptsCreditCards == rhs.acceptsCreditCards &&
        lhs.notes == rhs.notes &&
        lhs.author == rhs.author &&
        lhs.liked == rhs.liked &&
        lhs.numberOfLikes == rhs.numberOfLikes &&
        lhs.priceRange == rhs.priceRange &&
        lhs.createdAt == rhs.createdAt &&
        lhs.photoUrls == rhs.photoUrls
}
