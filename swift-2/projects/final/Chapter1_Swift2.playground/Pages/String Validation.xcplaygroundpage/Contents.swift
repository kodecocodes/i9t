//: Go back to [Errors](@previous)

import UIKit
//: # String Validation Errors
//: Now that you're familiar with creating custom `ErrorType`s, it's time to create a pretty robust one for string validation.

enum StringValidationError: ErrorType, CustomStringConvertible {
  
  case MustStartWith(set: NSCharacterSet, description: String)
  case MustContain(set: NSCharacterSet, description: String)
  case MustEndWith(set: NSCharacterSet, description: String)
  
  case CannotContain(set: NSCharacterSet, description: String)
  case CanOnlyContain(set: NSCharacterSet, description: String)
  case ContainAtLeast(set: NSCharacterSet, count: Int, description: String)
  
  case MinLengthNotReached(Int)
  case MaxLengthExceeded(Int)
  
  var description: String {
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

//: Do not modify what is above this line

//: Define the `StringValidationRule` protocol below
protocol StringValidationRule {
  func validate(string: String) throws -> Bool
  var errorType: StringValidationError { get }
}
//: Define the `StringValidator` protocol below
protocol StringValidator {
  var validationRules: [StringValidationRule] { get }
  func validate(string: String) -> (valid: Bool, errors: [StringValidationError])
}
//: Extend the `StringValidator` protocol to define a default implementation for `validate(string:)`
extension StringValidator {
  func validate(string: String) -> (valid: Bool, errors:[StringValidationError]) {
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
    return (valid: errors.isEmpty, errors:errors)
  }
}
//: Time to implement your very first `StringValidationRule`, starting with one forthe first error type `.MustStartWith` and name it `StartsWithCharacterStringValidationRule`
struct StartsWithCharacterStringValidationRule: StringValidationRule {
  let characterSet: NSCharacterSet
  let description: String
  var errorType: StringValidationError {
    return .MustStartWith(set: characterSet, description: description)
  }
  func validate(string: String) throws -> Bool {
    if string.startsWithCharacterFromSet(characterSet) {
      return true
    } else {
      throw errorType
    }
  }
}
//: Take this new rule for a spin!
let letterSet = NSCharacterSet.letterCharacterSet()
let startsWithRule = StartsWithCharacterStringValidationRule(characterSet: letterSet, description: "letter")
do {
  try startsWithRule.validate("foo")
  try startsWithRule.validate("123")
} catch let error {
  print(error)
}
//: Now define another rule, `EndsWithCharacterStringValidationRule` so that you can create a `StringValidator` that uses both rules in conjunction.
struct EndsWithCharacterStringValidationRule: StringValidationRule {
  let characterSet: NSCharacterSet
  let description: String
  var errorType: StringValidationError {
    return .MustEndWith(set: characterSet, description: description)
  }
  func validate(string: String) throws -> Bool {
    if string.endsWithCharacterFromSet(characterSet) {
      return true
    } else {
      throw errorType
    }
  }
}
//: Create a `StringValidator` named `StartsAndEndsWithStringValidator` that uses both the StartsWith an EndsWith rules.
struct StartsAndEndsWithStringValidator: StringValidator {
  let startsWithSet: NSCharacterSet
  let startsWithDescription: String
  let endsWithSet: NSCharacterSet
  let endsWithDescription: String
  var validationRules: [StringValidationRule] {
    return [
      StartsWithCharacterStringValidationRule(characterSet: startsWithSet, description: startsWithDescription),
      EndsWithCharacterStringValidationRule(characterSet: endsWithSet, description: endsWithDescription)
    ]
  }
}
//: Create a new instance of the validator to be used.
let numberSet = NSCharacterSet.decimalDigitCharacterSet()
let startsAndEndsWithValidator = StartsAndEndsWithStringValidator(startsWithSet: letterSet, startsWithDescription: "letter", endsWithSet: numberSet, endsWithDescription: "number")
//: Test that the validator works and view the resulting errors for invalid strings
startsAndEndsWithValidator.validate("1foo").errors.description
startsAndEndsWithValidator.validate("foo").errors.description
startsAndEndsWithValidator.validate("foo1").valid

//: Move on to [Password Validation](@next)
