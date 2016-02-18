import Foundation
import XCTest
import Nimble

@testable import Osusume

class DateConverterTest: XCTestCase {

    func test_returnsDate_asFormattedString() {
        let dateConverter = DateConverter()
        let date = NSDate(timeIntervalSince1970: 1454480320)

        expect(dateConverter.formattedDate(date)).to(equal("2/3/16"))
    }

    func test_returnsEmptyString_ifDateIsNotProvided() {
        let dateConverter = DateConverter()
        expect(dateConverter.formattedDate(nil)).to(equal(""))
    }
}
