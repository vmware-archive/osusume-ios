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

                repo.allRestaurants = [
                    Restaurant(id: 1, name: "つけめんTETSU", address: "", cuisineType: "つけめん", offersEnglishMenu: true, walkInsOk: true, acceptsCreditCards: true, notes: "This place is great", author: "Simon", createdAt: NSDate(timeIntervalSince1970: 1454480320)),
                    Restaurant(id: 2, name: "とんかつ 豚組食堂"),
                    Restaurant(id: 3, name: "Coco Curry"),
                ]
                subject = RestaurantListViewController(router: router, repo: repo)
                subject.view.layoutSubviews()
            }

            it("displays a list of restaurants") {
                let tableView = subject.tableView

                expect(tableView.numberOfSections).to(equal(1))
                expect(tableView.numberOfRowsInSection(0)).to(equal(3))

                let firstTableViewCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! RestaurantTableViewCell
                expect(firstTableViewCell.nameLabel.text).to(equal("つけめんTETSU"))
                expect(firstTableViewCell.cuisineTypeLabel.text).to(equal("つけめん"))
                expect(firstTableViewCell.authorLabel.text).to(equal("Added by Simon"))
                expect(firstTableViewCell.createdAtLabel.text).to(equal("Created on 2/3/16"))

                let secondTableViewCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)) as! RestaurantTableViewCell
                expect(secondTableViewCell.nameLabel.text).to(equal("とんかつ 豚組食堂"))

                let thirdTableViewCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 2, inSection: 0)) as! RestaurantTableViewCell
                expect(thirdTableViewCell.nameLabel.text).to(equal("Coco Curry"))
            }

            it("shows the new restaurant screen when you click 'add restaurant'") {
                expect(subject.navigationItem.rightBarButtonItem).toNot(beNil())
                expect(subject.navigationItem.rightBarButtonItem!.title).to(equal("add restaurant"))

                subject.didTapAddRestaurantButton(subject.navigationItem.rightBarButtonItem!)

                expect(router.newRestaurantScreenIsShowing).to(equal(true))
            }

            it("displays a detail view when a restaurant row is selected") {
                subject.didTapRestaurant(1)
                expect(router.restaurantDetailScreenIsShowing).to(equal(true))
            }
        }
    }
}
