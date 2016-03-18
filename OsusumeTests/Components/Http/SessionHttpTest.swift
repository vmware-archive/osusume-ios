import XCTest
import Nimble
@testable import Osusume

class SessionHttpTest: XCTestCase {

    func test_get_containAuthorizationToken() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        fakeSessionRepo.tokenValue = "FakeToken"

        let sessionHttp = SessionHttp(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )

        sessionHttp.get("/my-dawg", headers: [:])

        let expectedHeaders = [
            "Authorization": "Bearer FakeToken"
        ]
        expect(fakeHttp.get_args.path).to(equal("/my-dawg"))
        expect(fakeHttp.get_args.headers).to(equal(expectedHeaders))
    }

    func test_get_addsAuthorizationTokenToExistingHeaders() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        fakeSessionRepo.tokenValue = "FakeToken"

        let sessionHttp = SessionHttp(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )

        sessionHttp.get("/my-dawg", headers: ["HeaderKey" : "HeaderValue"])

        let expectedHeaders = [
            "Authorization": "Bearer FakeToken",
            "HeaderKey" : "HeaderValue"
        ]
        expect(fakeHttp.get_args.path).to(equal("/my-dawg"))
        expect(fakeHttp.get_args.headers).to(equal(expectedHeaders))
    }

    func test_post_containAuthorizationToken() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        fakeSessionRepo.tokenValue = "FakeToken"

        let sessionHttp = SessionHttp(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )

        sessionHttp.post("/my-dawg", headers: [:], parameters: [:])

        let expectedHeaders = [
            "Authorization": "Bearer FakeToken"
        ]
        expect(fakeHttp.post_args.path).to(equal("/my-dawg"))
        expect(fakeHttp.post_args.headers).to(equal(expectedHeaders))
    }

    func test_post_addsAuthorizationTokenToExistingHeaders() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        fakeSessionRepo.tokenValue = "FakeToken"

        let sessionHttp = SessionHttp(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )

        sessionHttp.post(
            "/my-dawg",
            headers: ["HeaderKey" : "HeaderValue"],
            parameters: [:]
        )

        let expectedHeaders = [
            "Authorization": "Bearer FakeToken",
            "HeaderKey" : "HeaderValue"
        ]
        expect(fakeHttp.post_args.path).to(equal("/my-dawg"))
        expect(fakeHttp.post_args.headers).to(equal(expectedHeaders))
    }

    func test_patch_containAuthorizationToken() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        fakeSessionRepo.tokenValue = "FakeToken"

        let sessionHttp = SessionHttp(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )

        sessionHttp.patch("/my-dawg", headers: [:], parameters: [:])

        let expectedHeaders = [
            "Authorization": "Bearer FakeToken"
        ]
        expect(fakeHttp.patch_args.path).to(equal("/my-dawg"))
        expect(fakeHttp.patch_args.headers).to(equal(expectedHeaders))
    }

    func test_patch_addsAuthorizationTokenToExistingHeaders() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        fakeSessionRepo.tokenValue = "FakeToken"

        let sessionHttp = SessionHttp(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )

        sessionHttp.patch(
            "/my-dawg",
            headers: ["HeaderKey" : "HeaderValue"],
            parameters: [:]
        )

        let expectedHeaders = [
            "Authorization": "Bearer FakeToken",
            "HeaderKey" : "HeaderValue"
        ]
        expect(fakeHttp.patch_args.path).to(equal("/my-dawg"))
        expect(fakeHttp.patch_args.headers).to(equal(expectedHeaders))
    }
}
