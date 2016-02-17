import Foundation

private let oneMilliSecond: NSTimeInterval = 0.01

extension NSRunLoop {
    static func osu_advance(by timeInterval: NSTimeInterval = oneMilliSecond) {
        let stopDate = NSDate().dateByAddingTimeInterval(timeInterval)
        mainRunLoop().runUntilDate(stopDate)
    }
}
