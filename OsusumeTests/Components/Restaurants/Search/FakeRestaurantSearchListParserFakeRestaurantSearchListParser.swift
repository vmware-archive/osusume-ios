@testable import Osusume
import Result

class FakeRestaurantSearchListParser: RestaurantSuggestionListParser {
    var parse_arg: AnyObject!
    var parse_returnValue = Result<[RestaurantSuggestion], ParseError>(value: [])
    func parseGNaviResponse(json: AnyObject)
        -> Result<[RestaurantSuggestion], ParseError> {
            parse_arg = json
            return parse_returnValue
    }
}
