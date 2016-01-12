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
                repo.createdRestaurant = Restaurant(id: 1, name: "My Restaurant", address: "Roppongi", cuisineType: "Sushi", offersEnglishMenu: true, walkInsOk: false, acceptsCreditCards: true)
                subject = RestaurantDetailViewController(router: router, repo: repo, id: 1)
                subject.view.layoutSubviews()
            }

            it("displays details of a given restaurant") {
                expect(subject.nameLabel.text).to(equal("My Restaurant"))
                expect(subject.addressLabel.text).to(equal("Roppongi"))
                expect(subject.cuisineTypeLabel.text).to(equal("Sushi"))
                expect(subject.offersEnglishMenuLabel.text).to(equal("Offers English menu"))
                expect(subject.walkInsOkLabel.text).to(equal("Walk-ins not recommended"))
                expect(subject.acceptsCreditCardsLabel.text).to(equal("Accepts credit cards"))
            }

            describe("Editing") {
                it("has Edit button on top right") {
                    expect(subject.navigationItem.rightBarButtonItem!.title).to(equal("Edit"))
                }

                it("shows the edit screen when the edit button is clicked") {
                    subject.editRestaurantButtonTapped(subject.navigationItem.rightBarButtonItem!)
                    expect(router.editRestaurantScreenIsShowing).to(equal(true))
                }
            }
        }
    }
}