import Foundation

public enum StringValidationError: ErrorType, CustomStringConvertible {
  
  case MustStartWith(set: NSCharacterSet, description: String)
  case MustContain(set: NSCharacterSet, description: String)
  case MustEndWith(set: NSCharacterSet, description: String)
  
  case CannotContain(set: NSCharacterSet, description: String)
  case CanOnlyContain(set: NSCharacterSet, description: String)
  case ContainAtLeast(set: NSCharacterSet, count: Int, description: String)
  
  case MinLengthNotReached(Int)
  case MaxLengthExceeded(Int)
  
  public var description: String {
    let errorString: String
    switch self {
    case .MustStartWith(_, let description):
      errorString = "Must start with \(description)."
    case .MustEndWith(_, let description):
      errorString = "Must end with \(description)."
    case .MustContain(_, let description):
      errorString = "Must contain \(description)."
    case .CannotContain(_, let description):
      errorString = "Cannot contain \(description)."
    case .CanOnlyContain(set: _, let description):
      errorString = "Can only contain \(description)."
    case .ContainAtLeast(_, let count, let description):
      errorString = "Must contain at least \(count) \(description)."
    case .MinLengthNotReached(let minChars):
      errorString = "Must be at least \(minChars) characters."
    case .MaxLengthExceeded(let maxChars):
      errorString = "Must be shorter than \(maxChars) characters."
    }
    
    return errorString
  }
}

public protocol StringValidationRule {
  /// Validates the given string, if validation fails a `StringValidationError` is thrown.
  func validate(string: String) throws -> Bool
  /// The type of `StringValidationError` that can be thrown.
  var errorType: StringValidationError { get }
}

public protocol StringValidator {
  var validationRules: [StringValidationRule] { get }
  func validate(string: String) -> (valid: Bool,
    errors: [StringValidationError])
}

public extension StringValidator {
  public func validate(string: String) -> (valid: Bool,
    errors: [StringValidationError]) {
      var errors = [StringValidationError]()
      for rule in validationRules {
        do {
          try rule.validate(string)
        } catch let error as StringValidationError {
          errors.append(error)
        } catch let error {
          fatalError("Unexpected error type: \(error)")
        }
      }
      
      return (valid: errors.isEmpty, errors: errors)
  }
}

/// A rule that validates a string starts with a character in the provided set.
public struct StartsWithCharacterStringValidationRule: StringValidationRule {
  public let characterSet: NSCharacterSet
  public let description: String
  public var errorType: StringValidationError {
    return .MustStartWith(set: characterSet,
      description: description)
  }
  
  public init(characterSet: NSCharacterSet, description: String) {
    self.characterSet = characterSet
    self.description = description
  }
  
  public func validate(string: String) throws -> Bool {
    if string.startsWithCharacterFromSet(characterSet) {
      return true
    } else {
      throw errorType
    }
  }
}

/// A rule that validates a string ends with a character in the provided set.
public struct EndsWithCharacterStringValidationRule: StringValidationRule {
  public let characterSet: NSCharacterSet
  public let description: String
  public var errorType: StringValidationError {
    return .MustEndWith(set: characterSet,
      description: description)
  }
  
  public init(characterSet: NSCharacterSet, description: String) {
    self.characterSet = characterSet
    self.description = description
  }
  
  public func validate(string: String) throws -> Bool {
    if string.endsWithCharacterFromSet(characterSet) {
      return true
    } else {
      throw errorType
    }
  }
}

/// A rule that validates a string contains a specific character. There are multiple Types available: 
/// - `.MustContain`: the string must contain a character in the provided set
/// - `.CannotContain`: the string cannot contain a character in the provided set
/// - `.OnlyContain`: the string can only contain characters in the provided set
/// - `.ContainAtLeast(count: Int)`: the string must contain at least `count` characters in the provided set
public struct ContainsCharacterStringValidationRule: StringValidationRule {
  public enum Type {
    case MustContain, CannotContain, OnlyContain, ContainAtLeast(Int)
  }
  
  public let characterSet: NSCharacterSet
  public let description: String
  public let type: Type
  public var errorType: StringValidationError {
    switch type {
    case .MustContain:
      return .MustContain(set: characterSet,
        description: description)
    case .CannotContain:
      return .CannotContain(set: characterSet,
        description: description)
    case .OnlyContain:
      return .CanOnlyContain(set: characterSet,
        description: description)
    case .ContainAtLeast(let count):
      return .ContainAtLeast(set: characterSet,
        count: count,
        description: description)
    }
  }
  
  public init(characterSet: NSCharacterSet, description: String, type: Type) {
    self.characterSet = characterSet
    self.description = description
    self.type = type
  }
  
  public func validate(string: String) throws -> Bool {
    switch type {
    case .MustContain:
      if !string.containsCharacterFromSet(characterSet) {
        throw errorType
      }
    case .CannotContain:
      if string.containsCharacterFromSet(characterSet) {
        throw errorType
      }
    case .OnlyContain:
      if string.containsCharacterFromSet(characterSet.invertedSet) {
        throw errorType
      }
    case .ContainAtLeast(let count):
      if string.countOfCharactersFromSet(characterSet) < count {
        throw errorType
      }
    }
    
    return true
  }
}

/// A rule that validates a string is a specified length, this rule has two Types: 
/// - `.Min(length: Int)`: must be at least `length` long
/// - `.Max(length: Int)`: cannot exceed `length`
///
/// Both types can be combined in a `StringValidator` to ensure the String is between a specific range in length.
public struct LengthStringValidationRule: StringValidationRule {
  public enum Type {
    case Min(length: Int)
    case Max(length: Int)
  }
  
  public let type: Type
  public var errorType: StringValidationError {
    switch type {
    case .Min(let length):
      return StringValidationError.MinLengthNotReached(length)
      
    case .Max(let length):
      return StringValidationError.MaxLengthExceeded(length)
    }
  }
  
  public init(type: Type) {
    self.type = type
  }
  
  public func validate(string: String) throws -> Bool {
    switch type {
    case .Min(let length):
      if string.characters.count < length {
        throw errorType
      }
    case .Max(let length):
      if string.characters.count > length {
        throw errorType
      }
    }
    
    return true
  }
}