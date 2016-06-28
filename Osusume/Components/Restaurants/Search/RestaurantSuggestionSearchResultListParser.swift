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
                let name = restaurantSuggestionJson["name"] as? String where name != "" ,
                let address = restaurantSuggestionJson["address"] as? String where address != "" else
            {
                continue
            }

            let restaurantSuggestion = RestaurantSuggestion(name: name, address: address)
            resultArray.append(restaurantSuggestion)
        }

        return Result.Success(resultArray)
    }
}
