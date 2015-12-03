import Foundation
import Quick
import Nimble
@testable import Osusume

class NewRestaurantViewControllerSpec: QuickSpec {
    override func spec() {

        describe("New Restaurant Page") {
            var subject: NewRestaurantViewController!

            beforeEach {
                subject = NewRestaurantViewController()
            }

            it("can enter restaurant name") {
                let view = subject.view

                expect(view.subviews.contains(subject.restaurantNameTextField)).to(beTrue())
                expect(subject.restaurantNameTextField.borderStyle) == UITextBorderStyle.Line

                subject.restaurantNameTextField.text = "Some Restaurant"
                expect(subject.restaurantNameTextField.text).to(equal("Some Restaurant"))
            }
        }
    }
}