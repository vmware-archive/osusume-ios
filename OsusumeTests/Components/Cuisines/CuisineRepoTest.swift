import XCTest
import BrightFutures
import Result
import Nimble
@testable import Osusume

class FakeCuisineListParser: DataListParser {
    typealias ParsedObject = [Cuisine]

    var parse_arg: [[String : AnyObject]]!
    var parse_returnValue = Result<[Cuisine], ParseError>(value: [])
    func parse(json: [[String : AnyObject]]) -> Result<[Cuisine], ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}

class CuisineRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    let fakeCuisineListParser = FakeCuisineListParser()
    let cuisineJsonPromise = Promise<AnyObject, RepoError>()
    var cuisineRepo: HttpCuisineRepo<FakeCuisineListParser>!

    override func setUp() {
        fakeHttp.get_returnValue = cuisineJsonPromise.future

        cuisineRepo = HttpCuisineRepo(
            http: self.fakeHttp,
            parser: self.fakeCuisineListParser
        )
    }

    func test_getAll_makesGetRequestWithCorrectArguments() {
        cuisineRepo.getAll()

        expect(self.fakeHttp.get_args.path).to(equal("/cuisines"))
    }

    func test_getAll_parsesHttpOutputJson() {
        cuisineRepo.getAll()
        cuisineJsonPromise.success([["Cuisine" : "Json"]])


        NSRunLoop.osu_advance()

        expect(self.fakeCuisineListParser.parse_arg).to(equal([["Cuisine" : "Json"]]))
    }

    func test_getAll_returnsParsedCuisineListResult() {
        let getAllCuisinesFuture = cuisineRepo.getAll()
        fakeCuisineListParser.parse_returnValue = Result.Success(
            [Cuisine(id: 1, name: "Thai")]
        )
        cuisineJsonPromise.success([[:]])


        NSRunLoop.osu_advance()

        let expectedCuisineListArray = [Cuisine(id: 1, name: "Thai")]
        expect(getAllCuisinesFuture.value).to(equal(expectedCuisineListArray))
    }
}
