import BrightFutures
import Nimble
@testable import Osusume

private let oneHundredthOfASecond: NSTimeInterval = 0.01

extension NSRunLoop {
    static func osu_advance(by timeInterval: NSTimeInterval = oneHundredthOfASecond) {
        let stopDate = NSDate().dateByAddingTimeInterval(timeInterval)
        mainRunLoop().runUntilDate(stopDate)
    }
}

class ExtensionsForTest {}

func tapButton(button: UIButton) {
    button.sendActionsForControlEvents(.TouchUpInside)
}

func tapNavBarButton(button: UIBarButtonItem) {
    UIApplication.sharedApplication().sendAction(
        button.action,
        to: button.target,
        from: nil,
        forEvent: nil
    )
}

func testImage(named imageName: String, imageExtension: String) -> UIImage {
    let testBundle = NSBundle(forClass: ExtensionsForTest.self)
    let imagePath = testBundle.pathForResource(imageName, ofType: imageExtension)
    return UIImage(contentsOfFile: imagePath!)!
}

func waitForFutureToComplete<T, E>(future: Future<T, E>) {
    waitUntil { done in
        while !future.isCompleted {}
        done()
    }
}

func configureUIWindowWithRootViewController(viewController: UIViewController) {
    let appDelegate = UIApplication.sharedApplication().delegate as! TestingAppDelegate
    let window: UIWindow! = appDelegate.window
    window.rootViewController = viewController
    window.makeKeyAndVisible()
}
