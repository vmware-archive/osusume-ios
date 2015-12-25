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

            beforeSuite {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                repo = FakeRestaurantRepo()
                subject = RestaurantDetailViewController(router: router, repo: repo)
                subject.view.layoutSubviews()
            }

            it("displays details of a given restaurant") {
            }
        }
    }
}