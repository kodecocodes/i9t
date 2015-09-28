import Foundation

import Foundation

public extension String {
  
  
  /// Given a character set, checks to see if this string starts with any character within that set.
  /// - Parameter set: The NSCharacter set to validate against.
  /// - Returns: Bool
  public func startsWithCharacterFromSet(set: NSCharacterSet) -> Bool {
    guard !isEmpty else {
      return false
    }
    
    return rangeOfCharacterFromSet(set, options: [], range: startIndex..<startIndex.successor()) != nil
  }
  
  /// Given a character set, checks to see if this string ends with any character within that set.
  /// - Parameter set: The NSCharacter set to validate against.
  /// - Returns: Bool
  public func endsWithCharacterFromSet(set: NSCharacterSet) -> Bool {
    guard !isEmpty else {
      return false
    }
    
    return rangeOfCharacterFromSet(set, options: [], range: endIndex.predecessor()..<endIndex) != nil
  }
  
  /// Given a character set, checks to see if this string contains any character within that set.
  /// - Parameter set: The NSCharacter set to validate against.
  /// - Returns: Bool
  public func containsCharacterFromSet(set: NSCharacterSet) -> Bool {
    guard !isEmpty else {
      return false
    }
    
    return rangeOfCharacterFromSet(set) != nil
  }
  
  /// Given a character set, counts the number of occurrences of characters in the given set.
  /// - Parameter set: The NSCharacter set to validate against.
  /// - Returns: Int
  public func countOfCharactersFromSet(set: NSCharacterSet) -> Int {
    guard !isEmpty else {
      return 0
    }
    var count = 0
    var range: Range? = startIndex..<endIndex
    
    repeat {
      if let newRange = rangeOfCharacterFromSet(set, options: [], range: range) {
        count += newRange.count
        range = newRange.endIndex..<endIndex
      } else {
        range = nil
      }
    } while range != nil
    
    return count
  }
}