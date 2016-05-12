class NullAppDelegate: UIResponder, UIApplicationDelegate {}

if NSClassFromString("XCTestCase") != nil {
    UIApplicationMain(
        Process.argc,
        Process.unsafeArgv,
        NSStringFromClass(UIApplication),
        NSStringFromClass(NullAppDelegate)
    )
} else {
    UIApplicationMain(
        Process.argc,
        Process.unsafeArgv,
        NSStringFromClass(UIApplication),
        NSStringFromClass(AppDelegate)
    )
}