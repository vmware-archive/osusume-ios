import XCTest

class OsusumeUITests: XCTestCase {
    var osusume: OsusumeApplication!

    override func setUp() {
        continueAfterFailure = false

        osusume = OsusumeApplication()
    }

    func test() {
        osusume.launch()
        osusume.login(username: "A", password: "A")
        osusume.tapAddRestaurantButton()

        let restaurantName = uniqueName("test restaurant")

        osusume.enterRestaurantName(restaurantName)
        osusume.tapAddPhotosButton()
        osusume.addTwoPhotos()

        let screen = osusume.ui
        XCTAssert(screen.collectionViews["Photos to be uploaded"].cells.count == 2)

        osusume.tapDoneButton()
        osusume.tapRestaurantName(restaurantName)
        osusume.tapEditButton()

        let newName = uniqueName("updated test restaurant")
        osusume.enterRestaurantName(newName)
        osusume.tapUpdateButton()

        osusume.tapRestaurantName(newName)

        XCTAssert(screen.staticTexts[newName].exists)
    }

}
