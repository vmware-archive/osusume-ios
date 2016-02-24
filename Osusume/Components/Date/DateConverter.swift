import Foundation

class DateConverter {

    func formattedDate(date: NSDate?) -> String {
        if let notNilDate = date {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            return formatter.stringFromDate(notNilDate)
        }
        return ""
    }

}