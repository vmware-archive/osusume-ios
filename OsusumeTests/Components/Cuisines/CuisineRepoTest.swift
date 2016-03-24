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
    var cuisineRepo: NetworkCuisineRepo<FakeCuisineListParser>!

    override func setUp() {
        fakeHttp.get_returnValue = cuisineJsonPromise.future

        cuisineRepo = NetworkCuisineRepo(
            http: self.fakeHttp,
            parser: self.fakeCuisineListParser
        )
    }

    func test_create_formatsPostRequest() {
        cuisineRepo.create(NewCuisine(name: "Mexican"))

        expect(self.fakeHttp.post_args.path).to(equal("/cuisines"))
        let expectedName = self.fakeHttp.post_args.parameters["name"] as? String
        expect(expectedName).to(equal("Mexican"))
    }

    func test_create_parsesCuisineFromReponse() {
        let promise = Promise<[String: AnyObject], RepoError>()
        fakeHttp.post_returnValue = promise.future

        var actualCuisine = Cuisine(id: 0, name: "")
        cuisineRepo.create(NewCuisine(name: "Mexican"))
            .onSuccess { cuisine in actualCuisine = cuisine }

        promise.success(["id": 1, "name": "Mexican"])

        expect(actualCuisine).toEventually(equal(Cuisine(id: 1, name: "Mexican")))
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
