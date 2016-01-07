import Foundation
import Quick
import Nimble
import BrightFutures
import Result
@testable import Osusume

class RestaurantDetailViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Restaurant Detail Page") {
            var subject: RestaurantDetailViewController!
            var router: FakeRouter!
            var repo: FakeRestaurantRepo!

            beforeEach {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                repo = FakeRestaurantRepo()
                subject = RestaurantDetailViewController(router: router, repo: repo, id: 1)
                subject.view.layoutSubviews()
            }

            it("displays details of a given restaurant") {
                let view = subject.view
                expect(view.subviews.contains(subject.nameLabel)).to(beTrue())
                expect(subject.nameLabel.frame).notTo(equal(CGRect.zero))
                expect(subject.nameLabel.text).to(equal("Restaurant Number 1"))
            }
        }
    }
}