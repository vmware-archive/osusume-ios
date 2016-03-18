import XCTest
import Result
import Nimble
import BrightFutures
@testable import Osusume

class FakeCommentParser: DataParser {
    typealias ParsedObject = PersistedComment

    var parse_arg: [String: AnyObject]?
    var parse_returnValue = Result<PersistedComment, ParseError>(
        value: PersistedComment(
            id: 99,
            text: "this is a comment",
            createdDate: NSDate(),
            restaurantId: 99,
            userName: ""
        )
    )
    func parse(json: [String: AnyObject]) -> Result<PersistedComment, ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}

class NetworkCommentRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    let fakeSessionRepo = FakeSessionRepo()
    var networkCommentRepo: NetworkCommentRepo<FakeCommentParser>!
    let fakeCommentParser = FakeCommentParser()

    override func setUp() {
        fakeSessionRepo.tokenValue = "some-session-token"

        networkCommentRepo = NetworkCommentRepo(
            http: fakeHttp,
            parser: fakeCommentParser
        )
    }

    func test_persist_passesDataToHttp() {
        let comment = NewComment(text: "I loved the tonkatsu!", restaurantId: 1)
        networkCommentRepo.persist(comment)

        XCTAssertEqual("/restaurants/\(comment.restaurantId)/comments", fakeHttp.post_args.path)

        let expectedParams: [String: AnyObject] = ["comment": ["content": comment.text]]

        if
            let contentParamDict = expectedParams["comment"] as? [String: String],
            let contentCommentText = contentParamDict["content"]
        {
            let actualParamDict = fakeHttp.post_args.parameters["comment"]!
            let actualCommentText = actualParamDict["content"]
            XCTAssertEqual(contentCommentText, actualCommentText)
        } else {
            XCTFail()
        }
    }

    func test_persist_failsWhenHttpFails() {
        fakeHttp.post_returnValue = Future<[String: AnyObject], RepoError>(error: RepoError.PostFailed)

        let comment = NewComment(text: "I loved the tonkatsu!", restaurantId: 1)
        let result = networkCommentRepo.persist(comment)

        expect(result.error).toEventually(equal(RepoError.PostFailed))
    }

    func test_persist_passesJsonToParser() {
        let expectedPostResponseJson: [String: AnyObject] = [
            "id": 3,
            "content": "hello this is a comment!",
            "restaurant_id": 99
        ]

        fakeHttp.post_returnValue = Future<[String: AnyObject], RepoError>(value: expectedPostResponseJson)

        let e = self.expectationWithDescription("no description")

        let comment = NewComment(text: "hello this is a comment!", restaurantId: 99)
        let result = networkCommentRepo.persist(comment)

        result.onSuccess { _ in
            if
                let expectedId = expectedPostResponseJson["id"] as? Int,
                let expectedContent = expectedPostResponseJson["content"] as? String,
                let expectedRestaurantId = expectedPostResponseJson["restaurant_id"] as? Int
            {
                let actualId = self.fakeCommentParser.parse_arg!["id"] as! Int
                let actualContent = self.fakeCommentParser.parse_arg!["content"] as! String
                let actualRestaurantId = self.fakeCommentParser.parse_arg!["restaurant_id"] as! Int

                expect(actualId).to(equal(expectedId))
                expect(expectedContent).to(equal(actualContent))
                expect(expectedRestaurantId).to(equal(actualRestaurantId))
            } else {
                XCTFail()
            }

            e.fulfill()
        }

        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }

    func test_persist_handlesParsingError() {
        let expectedPostResponseJson: [String: AnyObject] = [
            "id": "three",
            "content": "hello this is a comment!",
            "restaurant_id": 99
        ]

        fakeHttp.post_returnValue = Future<[String: AnyObject], RepoError>(value: expectedPostResponseJson)

        fakeCommentParser.parse_returnValue = Result<PersistedComment, ParseError>(
            error: ParseError.CommentParseError
        )

        let e = self.expectationWithDescription("no description")

        let comment = NewComment(text: "hello this is a comment!", restaurantId: 99)
        let result = networkCommentRepo.persist(comment)

        result.onComplete { _ in
            print("result: \(result)")
            expect(result.error).to(equal(RepoError.ParsingFailed))
            e.fulfill()
        }

        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }

}
