import Result

struct RestaurantSuggestionSearchResultListParser: DataParser {
    typealias ParsedObject = [RestaurantSuggestion]

    func parse(json: AnyObject) -> Result<[RestaurantSuggestion], ParseError> {
        guard let restaurantList = json as? [[String : AnyObject]] else {
            return Result.Success([])
        }

        return parse(restaurantList)
    }

    private func parse(json: [[String : AnyObject]]) -> Result<[RestaurantSuggestion], ParseError> {

        var resultArray: [RestaurantSuggestion] = []

        for resultJson in json {
            guard
                let name = resultJson["name"] as? String where name != "" ,
                let address = resultJson["address"] as? String where address != "" else
            {
                continue
            }

            let searchResultRestaurant = RestaurantSuggestion(name: name, address: address)
            resultArray.append(searchResultRestaurant)
        }

        return Result.Success(resultArray)
    }
}
