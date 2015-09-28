/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

class FormatHelper {

  /**
  This method formats a `Double`, as a `String`, with the specified number of digits after the fraction.

  ### Considerations:

  **Do Not** pass in a _negative_ value for `fractionDigitCount:`

      TODO: Update method to gracefully handle bad input

  - parameter number: The `Double` to format
  - parameter withFractionDigitCount: The number of digits that should be shown after the decimal.
  - returns: `number` as a string with the specified number of fraction digits
  */
  class func formatNumber(number: Double, withFractionDigitCount fractionDigitCount: Int) -> String {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = .DecimalStyle
    numberFormatter.maximumFractionDigits = fractionDigitCount
    numberFormatter.minimumFractionDigits = fractionDigitCount
    return numberFormatter.stringFromNumber(number)!
  }

}
