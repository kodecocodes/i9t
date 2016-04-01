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
  
  public let logCollection = LogCollection()
  
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
    notifyObserversWithUpdateLogCollection(logCollection)
  }
  
  /// An internal (private) helper method to notify observers when there is a change in the store.
  private func notifyObserversWithUpdateLogCollection(updateCollection: LogCollection) {
    for (_, observer) in observers {
      observer.logStore(self, didUpdateLogCollection: updateCollection)
    }
  }
  
}