import Foundation

private let oneMilliSecond: NSTimeInterval = 0.01

extension NSRunLoop {
    static func osu_advance(by timeInterval: NSTimeInterval = oneMilliSecond) {
        let stopDate = NSDate().dateByAddingTimeInterval(timeInterval)
        mainRunLoop().runUntilDate(stopDate)
    }
}

class ExtensionsForTest {}

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
