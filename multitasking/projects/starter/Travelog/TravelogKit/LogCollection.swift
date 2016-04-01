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

import UIKit

public class LogCollection {
  
  // MARK: Private
  
  private var logs = [NSDate: BaseLog]()
  
  func dictionaryRepresentation() -> Dictionary <NSDate, NSCoding> {
    return logs
  }
  
  // MARK: Public
  
  public init() {}
  
  /// Adds a BaseLog or any of its subclasses to the collection.
  public func addLog(log: BaseLog) {
    logs[log.date] = log
  }
  
  /// Removes a BaseLog or any of its subclasses from the collection.
  public func removeLog(log: BaseLog) {
    logs[log.date] = nil
  }
  
  /// Returns an array of BaseLog or any of its subclasses sorted by date of creation.
  public func sortedLogs(ordered: NSComparisonResult) -> [BaseLog] {
    let allLogs = logs.values
    let sorted = allLogs.sort { return $0.date.compare($1.date) == ordered }
    return sorted
  }
  
}