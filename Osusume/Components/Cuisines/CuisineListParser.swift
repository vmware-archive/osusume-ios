import Result

struct CuisineListParser: DataParser {
    typealias ParsedObject = [Cuisine]

    func parse(json: AnyObject) -> Result<[Cuisine], ParseError> {
        guard let cuisineList = json as? [[String : AnyObject]] else {
            return Result.Success([])
        }

        var cuisineArray: [Cuisine] = []

        for cuisineJson in cuisineList {
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
