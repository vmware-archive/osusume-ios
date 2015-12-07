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
                subject.view.layoutSubviews()
            }

            it("can enter restaurant name") {
                let view = subject.view

                expect(view.subviews.contains(subject.restaurantNameLabel)).to(beTrue())
                expect(subject.restaurantNameLabel.text).to(equal("restaurant name"))
                expect(subject.restaurantNameLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.restaurantNameTextField)).to(beTrue())
                expect(subject.restaurantNameTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.restaurantNameTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.restaurantNameTextField.text = "Some Restaurant"
                expect(subject.restaurantNameTextField.text).to(equal("Some Restaurant"))
            }
        }
    }
}