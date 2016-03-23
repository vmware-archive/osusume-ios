import Result

struct CuisineListParser: DataListParser {
    typealias ParsedObject = [Cuisine]

    func parse(json: [[String: AnyObject]]) -> Result<[Cuisine], ParseError> {

        var cuisineArray: [Cuisine] = []

        for cuisineJson in json {
            guard
                let id = cuisineJson["id"] as? Int,
                let name = cuisineJson["name"] as? String else
            {
                continue
            }

            let cuisine = Cuisine(id: id, name: name)
            cuisineArray.append(cuisine)
        }

        return Result.Success(cuisineArray)
    }
}
