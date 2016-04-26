import Foundation
import XCTest
import Nimble

@testable import Osusume

class DateConverterTest: XCTestCase {

    func test_returnsDate_asFormattedString() {
        let date = NSDate(timeIntervalSince1970: 1454480320)

        expect(DateConverter.formattedDate(date)).to(equal("2/3/16"))
    }

    func test_returnsEmptyString_ifDateIsNotProvided() {
        expect(DateConverter.formattedDate(nil)).to(equal(""))
    }
}
