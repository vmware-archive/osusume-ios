import Result

struct RestaurantSuggestionSearchResultListParser: DataParser {
    typealias ParsedObject = [RestaurantSuggestion]

    func parse(json: AnyObject) -> Result<[RestaurantSuggestion], ParseError> {
        guard let restaurantSuggestionList = json as? [[String : AnyObject]] else {
            return Result.Success([])
        }

        var resultArray: [RestaurantSuggestion] = []

        for restaurantSuggestionJson in restaurantSuggestionList {
            guard
                let name = restaurantSuggestionJson["name"] as? String where name != "",
                let address = restaurantSuggestionJson["address"] as? String where address != "",
                let placeId = restaurantSuggestionJson["place_id"] as? String where placeId != "",
                let latitude = restaurantSuggestionJson["latitude"] as? Double,
                let longitude = restaurantSuggestionJson["longitude"] as? Double else
            {
                continue
            }

            let restaurantSuggestion = RestaurantSuggestion(
                name: name,
                address: address,
                placeId: placeId,
                latitude: latitude,
                longitude: longitude)
            resultArray.append(restaurantSuggestion)
        }

        return Result.Success(resultArray)
    }
}
