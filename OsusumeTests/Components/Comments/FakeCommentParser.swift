@testable import Osusume
import Result

class FakeCommentParser: DataParser {
    typealias ParsedObject = PersistedComment

    var parse_arg: [String: AnyObject]?
    var parse_returnValue = Result<PersistedComment, ParseError>(
        value: PersistedComment(
            id: 99,
            text: "this is a comment",
            createdDate: NSDate(),
            restaurantId: 99,
            userId: 0,
            userName: ""
        )
    )
    func parse(json: [String: AnyObject]) -> Result<PersistedComment, ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}
