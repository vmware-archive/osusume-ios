import Result

protocol RestaurantSuggestionListParser {
    func parseGNaviResponse(json: AnyObject) -> Result<[RestaurantSuggestion], ParseError>
}
