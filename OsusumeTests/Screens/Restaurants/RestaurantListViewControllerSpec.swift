import Foundation
import Quick
import Nimble
import BrightFutures
import Result
@testable import Osusume

class RestaurantListViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Restaurant List Page") {
            var subject: RestaurantListViewController!
            var router: FakeRouter!
            var repo: FakeRestaurantRepo!

            beforeSuite {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                repo = FakeRestaurantRepo()
                subject = RestaurantListViewController(router: router, repo: repo)
                subject.view.layoutSubviews()
            }

            it("displays a list of restaurants") {
                let tableView = subject.tableView

                expect(tableView.numberOfSections).to(equal(1))
                expect(tableView.numberOfRowsInSection(0)).to(equal(3))

                let firstTableViewCell : UITableViewCell! = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
                expect(firstTableViewCell.textLabel?.text).to(equal("つけめんTETSU"))

                let secondTableViewCell : UITableViewCell! = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 1, inSection: 0))
                expect(secondTableViewCell.textLabel?.text).to(equal("とんかつ 豚組食堂"))

                let thirdTableViewCell : UITableViewCell! = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 2, inSection: 0))
                expect(thirdTableViewCell.textLabel?.text).to(equal("Coco Curry"))
            }

            it("shows the new restaurant screen when you click 'add restaurant'") {
                expect(subject.navigationItem.rightBarButtonItem).toNot(beNil())
                expect(subject.navigationItem.rightBarButtonItem!.title).to(equal("add restaurant"))

                subject.addRestaurantButtonTapped(subject.navigationItem.rightBarButtonItem!)

                expect(router.newRestaurantScreenIsShowing).to(equal(true))
            }
        }
    }
}
