import XCTest
import BrightFutures
import Result
import Nimble
@testable import Osusume

class FakeCuisineListParser: DataListParser {
    var parse_arg: [[String : AnyObject]]!
    var parse_returnValue = Result<CuisineList, ParseError>(
        value: CuisineList(cuisines: [])
    )
    func parse(json: [[String : AnyObject]]) -> Result<CuisineList, ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}

class CuisineRepoTest: XCTestCase {

    func test_getAll_makesGetRequestWithCorrectArguments() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        let fakeCuisineListParser = FakeCuisineListParser()
        fakeSessionRepo.tokenValue = "A Validated Token Value"

        let cuisineRepo = HttpCuisineRepo(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo,
            parser: fakeCuisineListParser
        )


        cuisineRepo.getAll()


        let expectedHeaders = [
            "Authorization": "Bearer A Validated Token Value"
        ]
        expect(fakeHttp.get_args.path).to(equal("/cuisines"))
        expect(fakeHttp.get_args.headers).to(equal(expectedHeaders))
    }

    func test_getAll_parsesHttpOutputJson() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        let fakeCuisineListParser = FakeCuisineListParser()
        fakeSessionRepo.tokenValue = "A Validated Token Value"

        let cuisineJsonPromise = Promise<AnyObject, RepoError>()
        fakeHttp.get_returnValue = cuisineJsonPromise.future

        let cuisineRepo = HttpCuisineRepo(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo,
            parser: fakeCuisineListParser
        )


        cuisineRepo.getAll()
        cuisineJsonPromise.success([["Cuisine" : "Json"]])


        NSRunLoop.osu_advance()

        expect(fakeCuisineListParser.parse_arg).to(equal([["Cuisine" : "Json"]]))
    }

    func test_getAll_returnsParsedCuisineListResult() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        let fakeCuisineListParser = FakeCuisineListParser()
        fakeSessionRepo.tokenValue = "A Validated Token Value"

        let cuisineJsonPromise = Promise<AnyObject, RepoError>()
        fakeHttp.get_returnValue = cuisineJsonPromise.future

        let cuisineRepo = HttpCuisineRepo(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo,
            parser: fakeCuisineListParser
        )


        let getAllCuisinesFuture = cuisineRepo.getAll()
        fakeCuisineListParser.parse_returnValue = Result.Success(
            CuisineList(cuisines: [Cuisine(id: 1, name: "Thai")])
        )
        cuisineJsonPromise.success([[:]])


        NSRunLoop.osu_advance()

        let expectedCuisineListArray = [Cuisine(id: 1, name: "Thai")]
        expect(getAllCuisinesFuture.value?.cuisines).to(equal(expectedCuisineListArray))
    }
}
