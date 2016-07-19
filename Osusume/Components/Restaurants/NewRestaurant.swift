struct NewRestaurant {
    var name: String?
    var address: String?
    var placeId: String?
    var latitude: Double?
    var longitude: Double?
    var cuisine: Cuisine?
    var priceRange: PriceRange?
    var nearestStation: String?
    var notes: String = ""
    var photoUrls: [String] = []

    var allRequiredFieldsArePopulated: Bool {
        return
            name != nil &&
            address != nil &&
            cuisine != nil &&
            priceRange != nil
    }
}
