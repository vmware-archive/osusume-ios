import XCTest

// http://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) -> Void {
        self.clearText()
        self.typeText(text)
    }

    func typeStringAvoidingAutocorrect(text: String) -> Void {
        guard text.characters.count > 0 else { return }

        let stringAvoidingAutoCorrection: String = text + "\u{8}\(text.characters.last!)"
        self.typeText(stringAvoidingAutoCorrection)
    }

    func clearText() -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        var deleteString: String = ""
        for _ in stringValue.characters {
            deleteString += "\u{8}"
        }

        self.typeText(deleteString)
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

        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("A")

        let passwordTextField = app.textFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("A")

        let loginButton = app.buttons["Login"]
        loginButton.tap()

        app.navigationBars["Osusume.RestaurantListView"].buttons["add restaurant"].tap()

        let element = app.scrollViews.childrenMatchingType(.Other).element
        let textField = element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.TextField).elementBoundByIndex(0)
        textField.tap()

        let restaurantName = "\(NSDate())-test"
        textField.typeStringAvoidingAutocorrect(restaurantName)
        textField.swipeUp()

        let tablesQuery = app.tables

        app.scrollViews.childrenMatchingType(.Other).element.childrenMatchingType(.Image).element.tap()
        app.tables.buttons["Camera Roll"].tap()
        app.collectionViews.cells.elementBoundByIndex(0).tap()

        app.navigationBars["Osusume.NewRestaurantView"].buttons["Done"].tap()

        tablesQuery.staticTexts[restaurantName].tap()

        app.navigationBars["Osusume.RestaurantDetailView"].buttons["Edit"].tap()
        textField.tap()

        let newRestaurantName = "\(NSDate())-new-name"
        textField.clearText()
        textField.typeStringAvoidingAutocorrect(newRestaurantName)
        app.navigationBars["Osusume.EditRestaurantView"].buttons["Update"].tap()

        tablesQuery.staticTexts[newRestaurantName].tap()

        XCTAssert(app.images["Picture of \(newRestaurantName)"].exists)
        XCTAssert(app.staticTexts[newRestaurantName].exists)
        XCTAssert(app.staticTexts["Does not offer English menu"].exists)
        XCTAssert(app.staticTexts["Walk-ins not recommended"].exists)
        XCTAssert(app.staticTexts["Does not accept credit cards"].exists)
        XCTAssert(app.staticTexts["Added by A"].exists)
    }

}
    