import Foundation
import Quick
import Nimble
@testable import Osusume

class NewRestaurantViewControllerSpec: QuickSpec {
    var window: UIWindow?

    override func spec() {

        describe("New Restaurant Page") {
            var subject: NewRestaurantViewController!
            var router: FakeRouter!
            var repo: FakeRestaurantRepo!

            beforeSuite {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                repo = FakeRestaurantRepo()
                subject = NewRestaurantViewController(router: router, repo: repo)

                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.window!.rootViewController = subject
                self.window!.makeKeyAndVisible()

                subject.view.layoutSubviews()
            }

            afterSuite {
                self.window?.hidden = true
                self.window!.rootViewController = nil
                self.window = nil
            }

            it("can enter restaurant name") {
                let view = subject.view

                expect(view.subviews.contains(subject.nameLabel)).to(beTrue())
                expect(subject.nameLabel.text).to(equal("Restaurant Name"))
                expect(subject.nameLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.nameTextField)).to(beTrue())
                expect(subject.nameTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.nameTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.nameTextField.text = "Some Restaurant"
                expect(subject.nameTextField.text).to(equal("Some Restaurant"))
            }

            it("can enter address") {
                let view = subject.view

                expect(view.subviews.contains(subject.addressLabel)).to(beTrue())
                expect(subject.addressLabel.text).to(equal("Address"))
                expect(subject.addressLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.addressTextField)).to(beTrue())
                expect(subject.addressTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.addressTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.addressTextField.text = "Restaurant address"
                expect(subject.addressTextField.text).to(equal("Restaurant address"))
            }

            it("can enter cuisine type") {
                let view = subject.view

                expect(view.subviews.contains(subject.cuisineTypeLabel)).to(beTrue())
                expect(subject.cuisineTypeLabel.text).to(equal("Cuisine Type"))
                expect(subject.cuisineTypeLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.cuisineTypeTextField)).to(beTrue())
                expect(subject.cuisineTypeTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.cuisineTypeTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.cuisineTypeTextField.text = "Restaurant Cuisine Type"
                expect(subject.cuisineTypeTextField.text).to(equal("Restaurant Cuisine Type"))
            }

            it("can enter name of a dish") {
                let view = subject.view

                expect(view.subviews.contains(subject.dishNameLabel)).to(beTrue())
                expect(subject.dishNameLabel.text).to(equal("Name of a Dish"))
                expect(subject.dishNameLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.dishNameTextField)).to(beTrue())
                expect(subject.dishNameTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.dishNameTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.dishNameTextField.text = "Sushi"
                expect(subject.dishNameTextField.text).to(equal("Sushi"))
            }

            it("displays the camera roll when 'Add Photo from Album' button is tapped") {
                let view = subject.view

                expect(view.subviews.contains(subject.addPhotoFromAlbumButton)).to(beTrue())
                expect(subject.addPhotoFromAlbumButton.titleLabel!.text).to(equal("Add Photo From Album"))

                subject.addPhotoFromAlbumButtonTapped(subject.addPhotoFromAlbumButton)

                expect(subject.presentedViewController).to(beAKindOf(UIImagePickerController))
            }

            it("displays the selected image") {
                expect(subject.selectedImageView.image).to(beNil())

                let sampleImage : UIImage! = UIImage(named: "Jeana")
                let imagePickerInfoDictionary = [ UIImagePickerControllerOriginalImage : sampleImage ]
                subject.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: imagePickerInfoDictionary)

                expect(subject.selectedImageView.image).to(equal(sampleImage))
            }

            it("can indicate that the restaurant offers english menu") {
                let view = subject.view

                expect(view.subviews.contains(subject.offersEnglishMenuSwitch)).to(beTrue())
                expect(subject.offersEnglishMenuSwitch.frame.origin).notTo(equal(CGPoint.zero))
            }

            it("can indicate that the restaurant requires reservations") {
                let view = subject.view

                expect(view.subviews.contains(subject.requiresReservationsSwitch)).to(beTrue())
                expect(subject.requiresReservationsSwitch.frame.origin).notTo(equal(CGPoint.zero))
            }

            it("can indicate that the restaurant accepts credit cards") {
                let view = subject.view

                expect(view.subviews.contains(subject.acceptsCreditCardsSwitch)).to(beTrue())
                expect(subject.acceptsCreditCardsSwitch.frame.origin).notTo(equal(CGPoint.zero))
            }

            it("can update not saved text when save button is pressed") {
                let view = subject.view

                expect(view.subviews.contains(subject.saveTextLabel)).to(beTrue())
                expect(subject.saveTextLabel.text).to(equal("Not Saved"))
                expect(subject.saveTextLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.saveButton)).to(beTrue())
                expect(subject.saveButton.titleLabel!.text).to(equal("Save"))

                subject.saveButtonTapped(subject.saveButton)
                expect(subject.saveTextLabel.text).to(equal("Saved"))
            }
        }
    }
}
