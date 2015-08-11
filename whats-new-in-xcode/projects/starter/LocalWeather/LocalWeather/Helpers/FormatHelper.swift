//
//  FormatHelper.swift
//  LocalWeather
//
//  Created by Jawwad Ahmad on 8/8/15.
//  Copyright © 2015 Jawwad Ahmad. All rights reserved.
//

import Foundation

class FormatHelper {

  /**
  This method formats a `Double`, as a `String`, with the specified number of digits after the fraction.

  ### Considerations:

  **Do Not** pass in a _negative_ value for `fractionDigitCount:`

      TODO: Update method to gracefully handle bad input

  - parameter number: The `Double` to format
  - parameter withFractionDigitCount: The number of digits that should be shown after the decimal.
  - returns: The number with the specified number of digits as a string
  */
  class func formatNumber(number: Double, withFractionDigitCount fractionDigitCount: Int) -> String {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = .DecimalStyle
    numberFormatter.maximumFractionDigits = fractionDigitCount
    numberFormatter.minimumFractionDigits = fractionDigitCount
    return numberFormatter.stringFromNumber(number)!
  }

}
