import XCTest

// http://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        var deleteString: String = ""
        for _ in stringValue.characters {
            deleteString += "\u{8}"
        }

        self.typeText(deleteString)
        self.typeText(text)
    }
}

class OsusumeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testAddingAndEditingARestaurant() {
        let app = XCUIApplication()

        logoutIfAlreadyLoggedIn(app)

        login(app)
        app.navigationBars["Osusume.RestaurantListView"].buttons["add restaurant"].tap()
        
        let element = app.scrollViews.childrenMatchingType(.Other).element
        let textField = element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.TextField).elementBoundByIndex(0)
        textField.tap()

        let restaurantName = "testAddingAndEditingARestaurant-\(NSDate())"
        textField.typeText(restaurantName)
        textField.swipeUp()

        let tablesQuery = app.tables
        app.scrollViews.otherElements.buttons["add photo"].tap()
        app.tables.buttons["Camera Roll"].tap()
        app.collectionViews.cells.elementBoundByIndex(0).tap()

        app.navigationBars["Osusume.NewRestaurantView"].buttons["Done"].tap()

        tablesQuery.staticTexts[restaurantName].tap()

        app.navigationBars["Osusume.RestaurantDetailView"].buttons["Edit"].tap()

        let newName = "Something Else \(NSDate())"

        textField.tap()
        textField.clearAndEnterText(newName)
        app.navigationBars["Osusume.EditRestaurantView"].buttons["Update"].tap()

        tablesQuery.staticTexts[newName].tap()

        XCTAssert(app.images["Picture of \(newName)"].exists)
        XCTAssert(app.staticTexts[newName].exists)
    }

    func logoutIfAlreadyLoggedIn(app: XCUIApplication) {
        if app.buttons["Logout"].exists {
            app.buttons["Logout"].tap()
        }
    }

    func login(app: XCUIApplication) {
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("A")

        let passwordTextField = app.textFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("A")

        let loginButton = app.buttons["Login"]
        loginButton.tap()
    }

}
