import Result

struct CuisineParser: DataParser {
    typealias ParsedObject = Cuisine

    func parse(json: [String : AnyObject]) -> Result<Cuisine, ParseError> {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String else
        {
            return Result.Failure(ParseError.CuisineParseError)
        }
        let cuisine = Cuisine(id: id, name: name)

        return Result.Success(cuisine)

    }
}