@testable import Osusume
import Result

class FakeRestaurantSearchListParser: DataParser {
    typealias ParsedObject = [RestaurantSuggestion]

    var parse_arg: AnyObject!
    var parse_returnValue = Result<[RestaurantSuggestion], ParseError>(value: [])
    func parse(json: AnyObject) -> Result<[RestaurantSuggestion], ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}
