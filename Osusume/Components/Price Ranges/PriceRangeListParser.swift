import Result

struct PriceRangeListParser: DataListParser {
    typealias ParsedObject = [PriceRange]

    func parse(json: AnyObject) -> Result<[PriceRange], ParseError> {
        guard let priceRangeList = json as? [[String : AnyObject]] else {
            return Result.Success([])
        }

        var priceRangeArray: [PriceRange] = []

        for priceRangeJson in priceRangeList {
            guard
                let id = priceRangeJson["id"] as? Int,
                let range = priceRangeJson["range"] as? String else
            {
                    continue
            }

            let priceRange = PriceRange(id: id, range: range)
            priceRangeArray.append(priceRange)
        }

        return Result.Success(priceRangeArray)
    }
}
