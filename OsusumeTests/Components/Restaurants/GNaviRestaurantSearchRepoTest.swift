import BrightFutures
import Result
import XCTest
import Nimble
@testable import Osusume

class FakeRestaurantSearchListParser: DataListParser {
    typealias ParsedObject = [SearchResultRestaurant]

    var parse_arg: [[String : AnyObject]]!
    var parse_returnValue = Result<[SearchResultRestaurant], ParseError>(value: [])
    func parse(json: [[String : AnyObject]])
        -> Result<[SearchResultRestaurant], ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}

class GNaviRestaurantSearchRepoTest: XCTestCase {
    var fakeHttp: FakeHttp!
    var fakeRestaurantSearchListParser = FakeRestaurantSearchListParser()
    let searchResultJsonPromise = Promise<AnyObject, RepoError>()
    var restaurantSearchRepo: GNaviRestaurantSearchRepo<FakeRestaurantSearchListParser>!

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
            .to(contain("?keyid=deb049ee1e0f97fa5d9ff3899e77ab54"))
    }

     func test_getForSearchTerm_addsSearchTermAsNameParameter() {
        restaurantSearchRepo.getForSearchTerm("search-term")


        expect(self.fakeHttp.get_args.path)
            .to(contain("&name=search-term"))
    }

    func test_getForSearchTerm_asksForSearchResultsAsJson() {
        restaurantSearchRepo.getForSearchTerm("")


        expect(self.fakeHttp.get_args.path)
            .to(contain("&format=json"))
    }

    func test_getForSearchTerm_parsesHttpOutputJson() {
        restaurantSearchRepo.getForSearchTerm("")
        searchResultJsonPromise.success([["SearchResult" : "Json"]])


        NSRunLoop.osu_advance()

        expect(self.fakeRestaurantSearchListParser.parse_arg)
            .to(equal([["SearchResult" : "Json"]]))
    }

    func test_getForSearchTerm_returnsParsedSearchResultList() {
        let getSearchResultFuture = restaurantSearchRepo.getForSearchTerm("")
        fakeRestaurantSearchListParser.parse_returnValue = Result.Success(
            [SearchResultRestaurant(id: "1", name: "afuri", address: "roppongi")]
        )
        searchResultJsonPromise.success([[:]])


        NSRunLoop.osu_advance()

        let expectedSearchResultListArray = [
            SearchResultRestaurant(id: "1", name: "afuri", address: "roppongi")]
        expect(getSearchResultFuture.value).to(equal(expectedSearchResultListArray))
    }
}