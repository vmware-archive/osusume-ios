import XCTest
import Nimble
import Result
import BrightFutures

@testable import Osusume

class NetworkRestaurantSearchRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    var networkRestaurantSearchRepo: NetworkRestaurantSearchRepo<FakeRestaurantSearchListParser>!
    let fakeRestaurantSearchListParser = FakeRestaurantSearchListParser()
    let searchResultJsonPromise = Promise<AnyObject, RepoError>()

    override func setUp() {
        fakeHttp.post_returnValue = searchResultJsonPromise.future
        networkRestaurantSearchRepo = NetworkRestaurantSearchRepo(
            http: fakeHttp,
            parser: fakeRestaurantSearchListParser
        )
    }

    func test_getForSearchTerm_hitsExpectedEndpoint() {
        networkRestaurantSearchRepo.getForSearchTerm("")


        XCTAssertEqual("/restaurant_suggestions", fakeHttp.post_args.path)
    }

    func test_getForSearchTerm_passesPostParam() {
        networkRestaurantSearchRepo.getForSearchTerm("Afuri")


        let actualRestaurantName = fakeHttp.post_args.parameters["restaurantName"] as? String
        XCTAssertEqual("Afuri", actualRestaurantName)
    }

    func test_getForSearchTerm_parsesHttpOutputJson() {
        networkRestaurantSearchRepo.getForSearchTerm("Afuri")

        let httpReturnValue = "response-json"
        searchResultJsonPromise.success(httpReturnValue)
        NSRunLoop.osu_advance()

        expect(self.fakeRestaurantSearchListParser.parse_arg as? String).to(equal(httpReturnValue))
    }

    func test_getForSearchTerm_returnsParsedSearchResultList() {
        let getSearchResultFuture = networkRestaurantSearchRepo.getForSearchTerm("")
        fakeRestaurantSearchListParser.parse_returnValue = Result.Success(
            [RestaurantSuggestion(name: "afuri", address: "roppongi")]
        )
        searchResultJsonPromise.success([:])


        NSRunLoop.osu_advance()

        let expectedSearchResultListArray = [
            RestaurantSuggestion(name: "afuri", address: "roppongi")]
        expect(getSearchResultFuture.value).to(equal(expectedSearchResultListArray))
    }
    
}