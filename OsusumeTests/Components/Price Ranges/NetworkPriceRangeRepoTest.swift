import XCTest
import BrightFutures
import Result
import Nimble
@testable import Osusume

class NetworkPriceRangeRepoTest: XCTestCase {
    var fakeHttp: FakeHttp!
    var fakePriceRangeListParser: FakePriceRangeListParser!
    var priceRangeRepo: PriceRangeRepo!
    var httpPromise: Promise<AnyObject, RepoError>!

    override func setUp() {
        fakeHttp = FakeHttp()
        fakePriceRangeListParser = FakePriceRangeListParser()
        httpPromise = Promise<AnyObject, RepoError>()
        fakeHttp.get_returnValue = httpPromise!.future

        priceRangeRepo = NetworkPriceRangeRepo(
            http: fakeHttp,
            parser: fakePriceRangeListParser
        )
    }

    func test_getAll_hitsExpectedEndpoint() {
        priceRangeRepo.getAll()


        expect(self.fakeHttp.get_args.path).to(equal("/priceranges"))
    }

    func test_getAll_parsesHttpOutputJson() {
        priceRangeRepo.getAll()


        let httpReturnValue = [["id" : 1,"range" : "Price Range #1"]]
        httpPromise.success(httpReturnValue)
        NSRunLoop.osu_advance(by: 2)

        expect(self.fakePriceRangeListParser.parse_arg).to(equal(httpReturnValue))
    }

    func test_getAll_returnsParsedPriceRangeResult() {
        let getAllPriceRangesFuture = priceRangeRepo.getAll()
        let expectedPriceRangeList: [PriceRange] = [
            PriceRange(id: 1, range: "Price Range #1"),
            PriceRange(id: 2, range: "Price Range #2")
        ]
        fakePriceRangeListParser.parse_returnValue = Result.Success(expectedPriceRangeList)
        httpPromise.success([[:]])


        NSRunLoop.osu_advance()


        expect(getAllPriceRangesFuture.value).to(equal(expectedPriceRangeList))
    }
}
