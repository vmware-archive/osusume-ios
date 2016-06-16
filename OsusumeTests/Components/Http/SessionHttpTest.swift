import XCTest
import Nimble
@testable import Osusume

class SessionHttpTest: XCTestCase {
    let fakeHttp = FakeHttp()
    let fakeSessionRepo = FakeSessionRepo()
    var sessionHttp: SessionHttp!

    override func setUp() {
        fakeSessionRepo.getAuthenticatedUser_returnValue =
            AuthenticatedUser(id: 1, email: "email", token: "FakeToken", name: "Danny")
        sessionHttp = SessionHttp(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )
    }

    func test_get_containAuthorizationToken() {
       sessionHttp.get("/my-dawg", headers: [:])


        let expectedHeaders = [
            "Authorization": "Bearer FakeToken"
        ]
        expect(self.fakeHttp.get_args.path).to(equal("/my-dawg"))
        expect(self.fakeHttp.get_args.headers).to(equal(expectedHeaders))
    }

    func test_get_addsAuthorizationTokenToExistingHeaders() {
        sessionHttp.get("/my-dawg", headers: ["HeaderKey" : "HeaderValue"])


        let expectedHeaders = [
            "Authorization": "Bearer FakeToken",
            "HeaderKey" : "HeaderValue"
        ]
        expect(self.fakeHttp.get_args.path).to(equal("/my-dawg"))
        expect(self.fakeHttp.get_args.headers).to(equal(expectedHeaders))
    }

    func test_post_containAuthorizationToken() {
        sessionHttp.post("/my-dawg", headers: [:], parameters: [:])


        let expectedHeaders = [
            "Authorization": "Bearer FakeToken"
        ]
        expect(self.fakeHttp.post_args.path).to(equal("/my-dawg"))
        expect(self.fakeHttp.post_args.headers).to(equal(expectedHeaders))
    }

    func test_post_addsAuthorizationTokenToExistingHeaders() {
        sessionHttp.post(
            "/my-dawg",
            headers: ["HeaderKey" : "HeaderValue"],
            parameters: [:]
        )


        let expectedHeaders = [
            "Authorization": "Bearer FakeToken",
            "HeaderKey" : "HeaderValue"
        ]
        expect(self.fakeHttp.post_args.path).to(equal("/my-dawg"))
        expect(self.fakeHttp.post_args.headers).to(equal(expectedHeaders))
    }

    func test_patch_containAuthorizationToken() {
        sessionHttp.patch("/my-dawg", headers: [:], parameters: [:])


        let expectedHeaders = [
            "Authorization": "Bearer FakeToken"
        ]
        expect(self.fakeHttp.patch_args.path).to(equal("/my-dawg"))
        expect(self.fakeHttp.patch_args.headers).to(equal(expectedHeaders))
    }

    func test_patch_addsAuthorizationTokenToExistingHeaders() {
        sessionHttp.patch(
            "/my-dawg",
            headers: ["HeaderKey" : "HeaderValue"],
            parameters: [:]
        )


        let expectedHeaders = [
            "Authorization": "Bearer FakeToken",
            "HeaderKey" : "HeaderValue"
        ]
        expect(self.fakeHttp.patch_args.path).to(equal("/my-dawg"))
        expect(self.fakeHttp.patch_args.headers).to(equal(expectedHeaders))
    }

    func test_delete_addsAuthorizationToken() {
        sessionHttp.delete("/comment", headers: [:])


        let expectedHeaders = [
            "Authorization": "Bearer FakeToken"
        ]
        expect(self.fakeHttp.delete_args.path).to(equal("/comment"))
        expect(self.fakeHttp.delete_args.headers).to(equal(expectedHeaders))
    }
}
