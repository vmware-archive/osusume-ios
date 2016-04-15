import Result

struct PriceRange {
    let id: Int
    let range: String
}

extension PriceRange: Equatable {}

func ==(lhs: PriceRange, rhs: PriceRange) -> Bool {
    return lhs.id == rhs.id &&
        lhs.range == rhs.range
}

struct PriceRangeListParser: DataListParser {
    typealias ParsedObject = [PriceRange]

    func parse(json: [[String: AnyObject]]) -> Result<[PriceRange], ParseError> {

        var priceRangeArray: [PriceRange] = []

        for priceRangeJson in json {
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
