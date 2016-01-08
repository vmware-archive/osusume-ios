import Foundation
import Quick
import Nimble
import BrightFutures
import Result
@testable import Osusume

class NewRestaurantViewControllerSpec: QuickSpec {
    var window: UIWindow?

    override func spec() {

        describe("New Restaurant Page") {
            var subject: NewRestaurantViewController!
            var router: FakeRouter!
            var repo: FakeRestaurantRepo!

            beforeEach {
                UIView.setAnimationsEnabled(false)
                router = FakeRouter()
                repo = FakeRestaurantRepo()
                subject = NewRestaurantViewController(router: router, repo: repo)

                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.window!.rootViewController = subject
                self.window!.makeKeyAndVisible()

                subject.view.layoutSubviews()
            }

            afterEach {
                self.window?.hidden = true
                self.window!.rootViewController = nil
                self.window = nil
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

            it("can update not saved text when save button is pressed") {
                let view = subject.view

                expect(view.subviews.contains(subject.saveTextLabel)).to(beTrue())
                expect(subject.saveTextLabel.text).to(equal("Not Saved"))
                expect(subject.saveTextLabel.frame).notTo(equal(CGRect.zero))

                expect(view.subviews.contains(subject.saveButton)).to(beTrue())
                expect(subject.saveButton.titleLabel!.text).to(equal("Save"))

                subject.nameTextField.text = "New Restaurant"
                subject.saveButtonTapped(subject.saveButton)
                expect(subject.saveTextLabel.text).to(equal("Saved"))
            }

            it("can save restaurant and return to listing screen") {
                subject.nameTextField.text = "New Restaurant"
                subject.saveButtonTapped(subject.saveButton)
                expect(router.restaurantListScreenIsShowing).to(equal(true))
            }

            it("makes an API call with all fields") {
                subject.nameTextField.text = "Some Restaurant"
                subject.cuisineTypeTextField.text = "Restaurant Cuisine Type"

                subject.saveButtonTapped(subject.saveButton)
                let restaurant: Restaurant = repo.createdRestaurant!

                expect(restaurant.name).to(equal("Some Restaurant"))
                expect(restaurant.address).to(equal(""))
                expect(restaurant.cuisineType).to(equal("Restaurant Cuisine Type"))
                expect(restaurant.offersEnglishMenu).to(equal(false))
                expect(restaurant.walkInsOk).to(equal(false))
                expect(restaurant.acceptsCreditCards).to(equal(false))
            }
        }
    }
}
