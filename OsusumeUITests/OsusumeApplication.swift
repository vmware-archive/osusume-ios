import XCTest

class OsusumeApplication {
    var ui: XCUIApplication!

    init() {
        ui = XCUIApplication()
    }

    func launch() {
        ui.launch()
    }

    func login(username username: String, password: String) {
        if ui.buttons["Logout"].exists {
            ui.buttons["Logout"].tap()
        }

        let emailTextField = ui.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText(username)

        let passwordTextField = ui.textFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText(password)

        let loginButton = ui.buttons["Login"]
        loginButton.tap()
    }

    func tapAddRestaurantButton() {
        ui.navigationBars["Osusume.RestaurantListView"]
            .buttons["add restaurant"]
            .tap()
    }

    func enterRestaurantName(restaurantName: String) {
        let textField = ui.scrollViews
            .childrenMatchingType(.Other)
            .element.childrenMatchingType(.Other)
            .element
            .childrenMatchingType(.Other)
            .element
            .childrenMatchingType(.TextField)
            .elementBoundByIndex(0)

        textField.tap()

        textField.clearAndEnterText(restaurantName)
    }

    func tapAddPhotosButton() {
        ui.scrollViews.otherElements.buttons["add photos"].tap()
    }

    func addTwoPhotos() {
        ui.collectionViews.cells.elementBoundByIndex(0).tap()
        ui.collectionViews.cells.elementBoundByIndex(1).tap()
        ui.navigationBars.buttons["Done (2)"].tap()
    }

    func tapDoneButton() {
        ui.navigationBars["Osusume.NewRestaurantView"].buttons["Done"].tap()
    }

    func tapRestaurantName(restaurantName: String) {
        ui.tables.staticTexts[restaurantName].tap()
    }

    func tapEditButton() {
        ui.navigationBars["Osusume.RestaurantDetailView"]
            .buttons["Edit"]
            .tap()
    }

    func tapUpdateButton() {
        ui.navigationBars["Osusume.EditRestaurantView"]
            .buttons["Update"]
            .tap()
    }

    func tapRestaurantDetailBackButton() {
        ui.navigationBars["Osusume.RestaurantDetailView"]
            .childrenMatchingType(.Button)
            .matchingIdentifier("Back")
            .elementBoundByIndex(0)
            .tap()
    }

    func tapProfileButton() {
        ui.navigationBars["Osusume.RestaurantListView"]
            .buttons["Profile"]
            .tap()
    }

    func tapProfileBackButton() {
        ui.navigationBars["My Profile"]
            .childrenMatchingType(.Button)
            .matchingIdentifier("Back")
            .elementBoundByIndex(0)
            .tap()
    }
}