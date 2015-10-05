//
//  NumberUtils.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class NumberUtils: NSObject {
    static let NumberFormatter = NSNumberFormatter()

    static func getDecimalFormattedNumberString(number: NSNumber) -> String {
        NumberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return NumberFormatter.stringFromNumber(number)!
    }
}
