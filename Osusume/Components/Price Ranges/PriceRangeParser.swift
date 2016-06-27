import Result

struct PriceRangeParser: DataParser {
    typealias ParsedObject = PriceRange
    
    func parse(json: AnyObject) -> Result<PriceRange, ParseError> {
        guard
            let id = json["id"] as? Int,
            let range = json["range"] as? String else
        {
            return Result.Failure(ParseError.PriceRangeParseError)
        }
        let priceRange = PriceRange(id: id, range: range)
        
        return Result.Success(priceRange)
        
    }
}