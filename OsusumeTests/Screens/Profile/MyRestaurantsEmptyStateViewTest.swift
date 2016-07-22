import XCTest
import Nimble
@testable import Osusume

class MyRestaurantsEmptyStateViewTest: XCTestCase {
    var myRestaurantsEmptyStateView: MyRestaurantsEmptyStateView!
    var callToActionCallback_called = false

    override func setUp() {
        myRestaurantsEmptyStateView = MyRestaurantsEmptyStateView(
            delegate: self
        )
    }

    override func tearDown() {
        callToActionCallback_called = false
    }

    // MARK: - Initialize View
    func test_init_initializesSubviews() {
        expect(self.myRestaurantsEmptyStateView.callToActionLabel)
            .to(beAKindOf(UILabel))
        expect(self.myRestaurantsEmptyStateView.callToActionButton)
            .to(beAKindOf(UIButton))
    }

    func test_init_addsSubviews() {
        expect(self.myRestaurantsEmptyStateView)
            .to(containSubview(self.myRestaurantsEmptyStateView.callToActionLabel))
        expect(self.myRestaurantsEmptyStateView)
            .to(containSubview(self.myRestaurantsEmptyStateView.callToActionButton))
    }

    func test_init_addsConstraints() {
        expect(self.myRestaurantsEmptyStateView.callToActionLabel)
            .to(hasConstraintsToSuperview())
        expect(self.myRestaurantsEmptyStateView.callToActionButton)
            .to(hasConstraintsToSuperview())
    }

    func test_clickCallToActionButton_callsCallToActionCallback() {
        tapButton(myRestaurantsEmptyStateView.callToActionButton)

        expect(self.callToActionCallback_called).to(beTrue())
    }
}

extension MyRestaurantsEmptyStateViewTest: EmptyStateCallToActionDelegate {
    func callToActionCallback(sender: UIButton) {
        callToActionCallback_called = true
    }
}