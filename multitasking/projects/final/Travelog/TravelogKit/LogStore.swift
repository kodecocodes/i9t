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

/// A protocol to communicate with interested objects when there is a change in LogStore.
public protocol LogStoreObserver {
  
  func logStore(store: LogStore, didUpdateLogCollection collection: LogCollection)
  
}

public class LogStore {
  
  public static let sharedStore = LogStore()
  let operationQueue: NSOperationQueue = {
    let queue = NSOperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  } ()
  
  public let logCollection = LogCollection()
  
  // MARK: Initialization
  
  init() {
    unowned let weakSelf = self
    readLogs { () -> Void in
      weakSelf.notifyObserversWithUpdateLogCollection(weakSelf.logCollection)
    }
  }
  
  // MARK: Communication with observers
  
  private var observers = Dictionary<Int, LogStoreObserver>()
  
  /// Register an observer to get notified when there's a change in the store.
  public func registerObserver(observer: AnyObject) {
    let identifier = ObjectIdentifier(observer ).hashValue
    guard let observer = observer as? LogStoreObserver else { return }
    observers[identifier] = observer
  }
  
  /// Unregister an observer.
  public func unregisterObserver(observer: AnyObject) {
    let identifier = ObjectIdentifier(observer ).hashValue
    guard let _ = observer as? LogStoreObserver else { return }
    observers[identifier] = nil
  }
  
  public func save() {
    saveCollectionLog()
    notifyObserversWithUpdateLogCollection(logCollection)
  }
  
  /// An internal (private) helper method to notify observers when there is a change in the store.
  private func notifyObserversWithUpdateLogCollection(updateCollection: LogCollection) {
    for (_, observer) in observers {
      observer.logStore(self, didUpdateLogCollection: updateCollection)
    }
  }
  
  // MARK: Private
  
  /// Read and restore log collection from disk.
  /// Upon completion it will notify observers.
  private func readLogs(completion: (() -> Void)) {
    // Read logs from disk in the background...
    unowned let weakSelf = self
    operationQueue.addOperationWithBlock { () -> Void in
      guard let dataRepresentation = NSData(contentsOfURL: weakSelf.storedLogsURL) else { return }
      guard let dictionaryRepresentation = NSKeyedUnarchiver.unarchiveObjectWithData(dataRepresentation) else { return }
      for (_, log) in dictionaryRepresentation as! Dictionary<NSDate, BaseLog>{
        weakSelf.logCollection.addLog(log)
      }
      
      // Notfiy observers on the main thread.
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completion()
      })
    }
  }
  
  /// Saves log collection to disk.
  private func saveCollectionLog() {
    // Get a dictionary representation of the log.
    let dictionaryRepresentation = logCollection.dictionaryRepresentation()
    unowned let weakSelf = self
    operationQueue.addOperationWithBlock { () -> Void in
      
      let dataRepresentation = NSKeyedArchiver.archivedDataWithRootObject(dictionaryRepresentation)
      let success = dataRepresentation.writeToURL(weakSelf.storedLogsURL, atomically: true)
      print("Saved collection log: \(success)")
    }
  }
  
  /// Returns the URL to the stored logs in user documents directory.
  private let storedLogsURL: NSURL = {
    var URL: NSURL = NSURL()
    do {
      try URL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
      URL = URL.URLByAppendingPathComponent("travel-logs.plist")
    }
    catch {}
    return URL
    }()
}