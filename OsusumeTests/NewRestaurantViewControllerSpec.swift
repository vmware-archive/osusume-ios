import Foundation
import Quick
import Nimble
@testable import Osusume

class NewRestaurantViewControllerSpec: QuickSpec {
    var window: UIWindow?

    override func spec() {

        describe("New Restaurant Page") {
            var subject: NewRestaurantViewController!

            beforeEach {
                subject = NewRestaurantViewController()

                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.window!.rootViewController = subject
                self.window!.makeKeyAndVisible()

                subject.view.layoutSubviews()
            }

            afterEach {
                self.window?.hidden = true
                self.window = nil
            }

            it("can enter restaurant name") {
                let view = subject.view

                expect(view.subviews.contains(subject.restaurantNameLabel)).to(beTrue())
                expect(subject.restaurantNameLabel.text).to(equal("Restaurant Name"))
                expect(subject.restaurantNameLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.restaurantNameTextField)).to(beTrue())
                expect(subject.restaurantNameTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.restaurantNameTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.restaurantNameTextField.text = "Some Restaurant"
                expect(subject.restaurantNameTextField.text).to(equal("Some Restaurant"))
            }

            it("can enter address") {
                let view = subject.view

                expect(view.subviews.contains(subject.restaurantAddressLabel)).to(beTrue())
                expect(subject.restaurantAddressLabel.text).to(equal("Address"))
                expect(subject.restaurantAddressLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.restaurantAddressTextField)).to(beTrue())
                expect(subject.restaurantAddressTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.restaurantAddressTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.restaurantAddressTextField.text = "Restaurant address"
                expect(subject.restaurantAddressTextField.text).to(equal("Restaurant address"))
            }

            it("can enter cuisine type") {
                let view = subject.view

                expect(view.subviews.contains(subject.restaurantCuisineTypeLabel)).to(beTrue())
                expect(subject.restaurantCuisineTypeLabel.text).to(equal("Cuisine Type"))
                expect(subject.restaurantCuisineTypeLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.restaurantCuisineTypeTextField)).to(beTrue())
                expect(subject.restaurantCuisineTypeTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.restaurantCuisineTypeTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.restaurantCuisineTypeTextField.text = "Restaurant Cuisine Type"
                expect(subject.restaurantCuisineTypeTextField.text).to(equal("Restaurant Cuisine Type"))
            }

            it("can enter name of a dish") {
                let view = subject.view

                expect(view.subviews.contains(subject.restaurantDishNameLabel)).to(beTrue())
                expect(subject.restaurantDishNameLabel.text).to(equal("Name of a Dish"))
                expect(subject.restaurantDishNameLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.restaurantDishNameTextField)).to(beTrue())
                expect(subject.restaurantDishNameTextField.borderStyle) == UITextBorderStyle.Line
                expect(subject.restaurantDishNameTextField.frame.origin).notTo(equal(CGPoint.zero))

                subject.restaurantDishNameTextField.text = "Sushi"
                expect(subject.restaurantDishNameTextField.text).to(equal("Sushi"))
            }

            it("displays the camera roll when 'Add Photo from Album' button is tapped") {
                let view = subject.view

                expect(view.subviews.contains(subject.addPhotoFromAlbumButton)).to(beTrue())
                expect(subject.addPhotoFromAlbumButton.titleLabel!.text).to(equal("Add Photo From Album"))

                subject.addPhotoFromAlbumButtonTapped(subject.addPhotoFromAlbumButton)

                expect(subject.presentedViewController).toEventually(beAnInstanceOf(UIImagePickerController))
            }

            it("displays the selected image") {
                expect(subject.selectedImageView.image).to(beNil())

                let sampleImage : UIImage! = UIImage(named: "Jeana")
                let imagePickerInfoDictionary = [ UIImagePickerControllerOriginalImage : sampleImage ]
                subject.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: imagePickerInfoDictionary)

                expect(subject.selectedImageView.image).to(equal(sampleImage))
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
