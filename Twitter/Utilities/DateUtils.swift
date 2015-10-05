//
//  DateUtils.swift
//  Twitter
//
//  Created by Amay Singhal on 10/1/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class DateUtils: NSObject {
    static let DateFormatter = NSDateFormatter()
    static let DateComponentsFormatter = NSDateComponentsFormatter()

    static let TwitterApiResponseDateFormat = "EEE MMM d HH:mm:ss Z y"
    static let PresentationLongDateFormat = "yyyy'-'MM'-'dd'THH:mm"

    static func getTimeElapsedSinceDate(sinceDate: NSDate) -> String {
        DateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        DateComponentsFormatter.collapsesLargestUnit = true
        DateComponentsFormatter.maximumUnitCount = 1
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return DateComponentsFormatter.stringFromTimeInterval(interval)!
    }

    static func getPresentationDateString(sinceDate: NSDate) -> String {
        DateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        DateFormatter.timeStyle = .ShortStyle
        return DateFormatter.stringFromDate(sinceDate)
    }
}
