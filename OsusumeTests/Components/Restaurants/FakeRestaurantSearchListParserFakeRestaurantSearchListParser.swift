@testable import Osusume
import Result

class FakeRestaurantSearchListParser: SearchResultRestaurantListParser {
    var parse_arg: [String : AnyObject]!
    var parse_returnValue = Result<[SearchResultRestaurant], ParseError>(value: [])
    func parseGNaviResponse(json: [String : AnyObject])
        -> Result<[SearchResultRestaurant], ParseError> {
            parse_arg = json
            return parse_returnValue
    }
}
