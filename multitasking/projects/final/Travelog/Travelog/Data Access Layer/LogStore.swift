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

class LogStore {
  
  static let sharedStore = LogStore()
  let operationQueue: NSOperationQueue = {
    let queue = NSOperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  } ()
  
  func storedLogs(completion: () -> LogCollection?) {
    operationQueue.addOperationWithBlock { () -> Void in
      let collection = LogCollection()
      let dictionaryRepresentation = NSDictionary(contentsOfURL: self.storedLogsURL) as! Dictionary<NSDate, BaseLog>
      for (_, log) in dictionaryRepresentation {
        collection.addLog(log)
      }
      
//      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//        completion(collection)
//      })
    }
  }
  
  func storeLogs(logCollection: LogCollection) {
    let dictionaryRepresentation = logCollection.dictionaryRepresentation()
    operationQueue.addOperationWithBlock { () -> Void in
      (dictionaryRepresentation as NSDictionary).writeToURL(storedLogsURL, atomically: true)
    }
  }
  
  // MARK: Private
  
  /// Returns the URL to the stored logs in user documents directory.
  let storedLogsURL: NSURL = {
    var URL: NSURL = NSURL()
    do {
      try URL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
      URL = URL.URLByAppendingPathComponent("travel-logs")
    }
    catch {}
    return URL
    }()
}