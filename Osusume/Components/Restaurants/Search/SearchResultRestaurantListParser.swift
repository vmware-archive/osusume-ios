import Result

protocol SearchResultRestaurantListParser {
    func parseGNaviResponse(json: [String : AnyObject]) -> Result<[SearchResultRestaurant], ParseError>
}
