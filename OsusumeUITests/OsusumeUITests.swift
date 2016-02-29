import XCTest

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
        let textField = element.childrenMatchingType(.Other)
            .element
            .childrenMatchingType(.Other)
            .element
            .childrenMatchingType(.TextField)
            .elementBoundByIndex(0)
        textField.tap()

        let restaurantName = "testAddingAndEditingARestaurant-\(NSDate())"
        textField.typeText(restaurantName)

        let tablesQuery = app.tables
        app.scrollViews.otherElements.buttons["add photos"].tap()
        app.collectionViews.cells.elementBoundByIndex(0).tap()
        app.collectionViews.cells.elementBoundByIndex(1).tap()
        app.navigationBars.buttons["Done (2)"].tap()

        XCTAssert(app.collectionViews["Photos to be uploaded"].cells.count == 2)

        app.navigationBars["Osusume.NewRestaurantView"].buttons["Done"].tap()

        tablesQuery.staticTexts[restaurantName].tap()

        app.navigationBars["Osusume.RestaurantDetailView"].buttons["Edit"].tap()

        let newName = "Something Else \(NSDate())"

        textField.tap()

        textField.clearAndEnterText(newName)
        app.navigationBars["Osusume.EditRestaurantView"].buttons["Update"].tap()

        tablesQuery.staticTexts[newName].tap()

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
