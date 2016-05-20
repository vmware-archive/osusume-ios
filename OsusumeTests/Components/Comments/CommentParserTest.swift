import XCTest
import Result
import Nimble
@testable import Osusume

class CommentParserTest: XCTestCase {

    var commentParser: CommentParser!

    override func setUp() {
        super.setUp()

        commentParser = CommentParser()
    }

    func test_validJson_returnsPersistedComment() {
        let inputHttpJson: [String: AnyObject] = [
            "id": 3,
            "content": "hello this is a comment!",
            "created_at": "2016-02-29T06:07:55.000Z",
            "restaurant_id": 99,
            "user": [
                "name": "Witta",
                "id": 100
            ]
        ]

        let result: Result<PersistedComment, ParseError> = commentParser.parse(inputHttpJson)

        let expectedComment = PersistedComment(
            id: 3,
            text: "hello this is a comment!",
            createdDate: NSDate(timeIntervalSince1970: 1456726075),
            restaurantId: 99,
            userId: 100,
            userName: "Witta"
        )

        expect(result.value).to(equal(expectedComment))
    }

    func test_invalidDateTimeStampFormat_returnsParseError() {
        let inputHttpJson: [String: AnyObject] = [
            "id": 3,
            "content": "hello this is a comment!",
            "created_at": "invalid timestamp string",
            "restaurant_id": 99,
            "user": [
                "name": "Witta",
                "id": 100
            ]
        ]

        let result: Result<PersistedComment, ParseError> = commentParser.parse(inputHttpJson)

        expect(result.error).to(equal(ParseError.CommentParseError))
    }

    func test_missingInputField_returnsParseError() {
        let inputHttpJson: [String: AnyObject] = [
            "content": "hello this is a comment!",
            "restaurant_id": 99
        ]

        let result: Result<PersistedComment, ParseError> = commentParser.parse(inputHttpJson)

        expect(result.error).to(equal(ParseError.CommentParseError))
    }

    func test_invalidInputValue_returnsParseError() {
        let inputHttpJson: [String: AnyObject] = [
            "id": "three",
            "content": "hello this is a comment!",
            "restaurant_id": 99
        ]

        let result: Result<PersistedComment, ParseError> = commentParser.parse(inputHttpJson)

        expect(result.error).to(equal(ParseError.CommentParseError))
    }

}
