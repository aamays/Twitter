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

    static func getTimeElapsedSinceDate(sinceDate: NSDate) -> String {
        DateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        DateComponentsFormatter.collapsesLargestUnit = true
        DateComponentsFormatter.maximumUnitCount = 1
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return DateComponentsFormatter.stringFromTimeInterval(interval)!
    }
}
