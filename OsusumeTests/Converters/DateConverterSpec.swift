import Foundation
import Quick
import Nimble

@testable import Osusume

class DateConverterSpec : QuickSpec {
    override func spec() {
        describe("formattedDate") {
            var subject: DateConverter!

            beforeEach {
                subject = DateConverter()
            }

            it("returns the date as a formatted string") {
                let date = NSDate(timeIntervalSince1970: 1454480320)

                expect(subject.formattedDate(date)).to(equal("2/3/16"))
            }

            it("returns an empty string if date is not provided") {
                expect(subject.formattedDate(nil)).to(equal(""))
            }
        }
    }
}