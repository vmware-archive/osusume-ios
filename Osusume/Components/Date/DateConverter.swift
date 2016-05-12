struct DateConverter {

    static func formattedDate(date: NSDate?) -> String {
        if let notNilDate = date {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            return formatter.stringFromDate(notNilDate)
        }
        return ""
    }

    static func formattedDateFromString(string: String?) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocaleIdentifier)
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard
            let dateString = string,
            let formattedDate = dateFormatter.dateFromString(dateString) else
        {
            return nil
        }

        return formattedDate
    }

}