import Result

struct GNaviRestaurantListParser: SearchResultRestaurantListParser {
    typealias ParsedObject = [SearchResultRestaurant]

    func parseGNaviResponse(json: [String : AnyObject])
        -> Result<[SearchResultRestaurant], ParseError> {
            let restaurantList = json["rest"] as? [[String : AnyObject]]
            return parse(restaurantList!)
    }

    func parse(json: [[String : AnyObject]])-> Result<[SearchResultRestaurant], ParseError> {

        var resultArray: [SearchResultRestaurant] = []

        for resultJson in json {
            guard
                let id = resultJson["id"] as? String,
                let name = resultJson["name"] as? String where name != "" ,
                let address = resultJson["address"] as? String where address != "" else
            {
                continue
            }

            let searchResultRestaurant = SearchResultRestaurant(id: id, name: name, address: address)
            resultArray.append(searchResultRestaurant)
        }

        return Result.Success(resultArray)
    }
}
