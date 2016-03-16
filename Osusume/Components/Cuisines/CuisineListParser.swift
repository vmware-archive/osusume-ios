import Result

struct CuisineListParser: DataListParser {
    typealias ParsedObject = CuisineList

    func parse(json: [[String: AnyObject]]) -> Result<CuisineList, ParseError> {

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

        return Result.Success(CuisineList(cuisines: cuisineArray))
    }
}
