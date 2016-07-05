struct NewRestaurant {
    var name: String?
    var address: String?
    var placeId: String?
    var latitude: Double?
    var longitude: Double?
    var cuisine: Cuisine?
    var priceRange: PriceRange?
    var notes: String = ""
    var photoUrls: [String] = []
}
