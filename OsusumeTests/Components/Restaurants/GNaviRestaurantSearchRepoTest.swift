import BrightFutures
import Result
import XCTest
import Nimble
@testable import Osusume

class FakeRestaurantSearchListParser: SearchResultRestaurantListParser {
    var parse_arg: [String : AnyObject]!
    var parse_returnValue = Result<[SearchResultRestaurant], ParseError>(value: [])
    func parseGNaviResponse(json: [String : AnyObject])
        -> Result<[SearchResultRestaurant], ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}

class GNaviRestaurantSearchRepoTest: XCTestCase {
    var fakeHttp: FakeHttp!
    var fakeRestaurantSearchListParser = FakeRestaurantSearchListParser()
    let searchResultJsonPromise = Promise<AnyObject, RepoError>()
    var restaurantSearchRepo: GNaviRestaurantSearchRepo!

    override func setUp() {
        fakeHttp = FakeHttp()
        fakeHttp.get_returnValue = searchResultJsonPromise.future

        restaurantSearchRepo = GNaviRestaurantSearchRepo(
            http: fakeHttp,
            parser: self.fakeRestaurantSearchListParser
        )
    }

    func test_getForSearchTerm_hitsGNaviEndpoint() {
        restaurantSearchRepo.getForSearchTerm("")


        expect(self.fakeHttp.get_args.path)
            .to(beginWith("http://api.gnavi.co.jp/RestSearchAPI/20150630/"))
    }

    func test_getForSearchTerm_passesAPIToken() {
        restaurantSearchRepo.getForSearchTerm("")


        expect(self.fakeHttp.get_args.path)
            .to(contain("?keyid=c174f342a2294ea4419083ad100a8131"))
    }

    func test_getForSearchTerm_addsSearchTermAsNameParameter() {
        restaurantSearchRepo.getForSearchTerm("search-term")


        expect(self.fakeHttp.get_args.path)
            .to(contain("&name=search-term"))
    }

    func test_getForSearchTerm_encodesSearchTerm() {
        restaurantSearchRepo.getForSearchTerm("検索項目")


        expect(self.fakeHttp.get_args.path)
            .to(contain("&name=%E6%A4%9C%E7%B4%A2%E9%A0%85%E7%9B%AE"))
    }

    func test_getForSearchTerm_asksForSearchResultsAsJson() {
        restaurantSearchRepo.getForSearchTerm("")


        expect(self.fakeHttp.get_args.path)
            .to(contain("&format=json"))
    }

    func test_getForSearchTerm_parsesHttpOutputJson() {
        restaurantSearchRepo.getForSearchTerm("")
        searchResultJsonPromise.success(["SearchResult" : "Json"])


        NSRunLoop.osu_advance()

        expect(NSDictionary(dictionary: self.fakeRestaurantSearchListParser.parse_arg)
            .isEqualToDictionary(["SearchResult" : "Json"]))
            .to(beTrue())
    }

    func test_getForSearchTerm_returnsParsedSearchResultList() {
        let getSearchResultFuture = restaurantSearchRepo.getForSearchTerm("")
        fakeRestaurantSearchListParser.parse_returnValue = Result.Success(
            [SearchResultRestaurant(id: "1", name: "afuri", address: "roppongi")]
        )
        searchResultJsonPromise.success([:])


        NSRunLoop.osu_advance()

        let expectedSearchResultListArray = [
            SearchResultRestaurant(id: "1", name: "afuri", address: "roppongi")]
        expect(getSearchResultFuture.value).to(equal(expectedSearchResultListArray))
    }
}