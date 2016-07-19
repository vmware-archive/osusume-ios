struct Restaurant {
    let id: Int
    let name: String
    let address: String
    let placeId: String
    let latitude: Double
    let longitude: Double
    let cuisineType: String
    let cuisine: Cuisine
    let notes: String
    let liked: Bool
    let numberOfLikes: Int
    let priceRange: PriceRange
    let nearestStation: String
    let createdAt: NSDate?
    let photoUrls: [PhotoUrl]
    let createdByUser: (id: Int, name: String, email: String)
    var comments: [PersistedComment]

    init(
        id: Int,
        name: String,
        address: String,
        placeId: String,
        latitude: Double,
        longitude: Double,
        cuisineType: String,
        cuisine: Cuisine,
        notes: String,
        liked: Bool,
        numberOfLikes: Int,
        priceRange: PriceRange,
        nearestStation: String,
        createdAt: NSDate?,
        photoUrls: [PhotoUrl],
        createdByUser: (id: Int, name: String, email: String),
        comments: [PersistedComment]
        )
    {
        self.id = id
        self.name = name
        self.address = address
        self.placeId = placeId
        self.latitude = latitude
        self.longitude = longitude
        self.cuisineType = cuisineType
        self.cuisine = cuisine
        self.notes = notes
        self.liked = liked
        self.numberOfLikes = numberOfLikes
        self.priceRange = priceRange
        self.nearestStation = nearestStation
        self.createdAt = createdAt
        self.photoUrls = photoUrls
        self.createdByUser = createdByUser
        self.comments = comments
    }

    func newRetaurantWithLikeToggled() -> Restaurant {

        let updatedLikeStatus = !liked
        var updatedNumberOfLikes = numberOfLikes

        if updatedLikeStatus {
            updatedNumberOfLikes += 1
        } else {
            updatedNumberOfLikes -= 1
        }

        return Restaurant(
            id: self.id,
            name: self.name,
            address: self.address,
            placeId: self.placeId,
            latitude: self.latitude,
            longitude: self.longitude,
            cuisineType: self.cuisineType,
            cuisine: self.cuisine,
            notes: self.notes,
            liked: updatedLikeStatus,
            numberOfLikes: updatedNumberOfLikes,
            priceRange: self.priceRange,
            nearestStation: self.nearestStation,
            createdAt: self.createdAt,
            photoUrls: self.photoUrls,
            createdByUser: self.createdByUser,
            comments: self.comments
        )
    }

    func restaurantByDeletingPhotoUrl(photoUrlIdToDelete: Int) -> Restaurant {
        let updatedPhotoUrls = photoUrls.filter { photoUrl in
            return photoUrl.id != photoUrlIdToDelete
        }

        return Restaurant(
            id: self.id,
            name: self.name,
            address: self.address,
            placeId: self.placeId,
            latitude: self.latitude,
            longitude: self.longitude,
            cuisineType: self.cuisineType,
            cuisine: self.cuisine,
            notes: self.notes,
            liked: self.liked,
            numberOfLikes: self.numberOfLikes,
            priceRange: self.priceRange,
            nearestStation: self.nearestStation,
            createdAt: self.createdAt,
            photoUrls: updatedPhotoUrls,
            createdByUser: self.createdByUser,
            comments: self.comments
        )
    }

    func createdByCurrentUser(maybeAuthenticatedUser: AuthenticatedUser?) -> Bool {
        guard let authenticatedUser = maybeAuthenticatedUser else {
            return false
        }
        return authenticatedUser.id == createdByUser.id
    }
}

extension Restaurant: Equatable {}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.address == rhs.address &&
        lhs.placeId == rhs.placeId &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.cuisineType == rhs.cuisineType &&
        lhs.cuisine == rhs.cuisine &&
        lhs.notes == rhs.notes &&
        lhs.liked == rhs.liked &&
        lhs.numberOfLikes == rhs.numberOfLikes &&
        lhs.priceRange == rhs.priceRange &&
        lhs.nearestStation == rhs.nearestStation &&
        lhs.createdAt == rhs.createdAt &&
        lhs.photoUrls == rhs.photoUrls &&
        lhs.createdByUser == rhs.createdByUser
}
