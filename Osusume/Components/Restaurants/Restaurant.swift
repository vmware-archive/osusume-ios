import Foundation

struct Restaurant {
    var id: Int
    var name: String
    var address: String
    var cuisineType: String
    var offersEnglishMenu: Bool
    var walkInsOk: Bool
    var acceptsCreditCards: Bool
    var notes: String
    var author: String
    var createdAt: NSDate?
    var photoUrls: [NSURL]

    init(
        id: Int,
        name: String,
        address: String,
        cuisineType: String,
        offersEnglishMenu: Bool,
        walkInsOk: Bool,
        acceptsCreditCards: Bool,
        notes: String,
        author: String,
        createdAt: NSDate?,
        photoUrls: [NSURL]
        )
    {
            self.id = id
            self.name = name
            self.address = address
            self.cuisineType = cuisineType
            self.offersEnglishMenu = offersEnglishMenu
            self.walkInsOk = walkInsOk
            self.acceptsCreditCards = acceptsCreditCards
            self.notes = notes
            self.author = author
            self.createdAt = createdAt
            self.photoUrls = photoUrls
    }
}

extension Restaurant: Equatable {}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.address == rhs.address &&
        lhs.cuisineType == rhs.cuisineType &&
        lhs.offersEnglishMenu == rhs.offersEnglishMenu &&
        lhs.walkInsOk  == rhs.walkInsOk &&
        lhs.acceptsCreditCards == rhs.acceptsCreditCards &&
        lhs.notes == rhs.notes &&
        lhs.author == rhs.author &&
        lhs.createdAt == rhs.createdAt &&
        lhs.photoUrls == rhs.photoUrls
}