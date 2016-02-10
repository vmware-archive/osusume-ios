import Foundation

class Restaurant {
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
    var photoUrl: NSURL?

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
        photoUrl: NSURL?) {
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
            self.photoUrl = photoUrl
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.address = ""
        self.cuisineType = ""
        self.offersEnglishMenu = false
        self.walkInsOk = false
        self.acceptsCreditCards = false
        self.notes = ""
        self.author = ""
        self.createdAt = nil
        self.photoUrl = nil
    }
}