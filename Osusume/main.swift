import Foundation
import UIKit

func isRunningTests() -> Bool {
    let environment = NSProcessInfo.processInfo().environment
    if let injectBundle = environment["XCInjectBundle"] as? NSString {
        return injectBundle.pathExtension == "xctest"
    }
    return false
}


class UnitTestsAppDelegate: UIResponder, UIApplicationDelegate {

}

if isRunningTests() {
    UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(UIApplication), NSStringFromClass(UnitTestsAppDelegate))
} else {
    UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(UIApplication), NSStringFromClass(AppDelegate))
}