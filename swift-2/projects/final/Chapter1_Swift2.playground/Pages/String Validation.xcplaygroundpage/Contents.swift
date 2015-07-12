//: [Previous](@previous)
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

//: While pretty big, this ErrorType is not too bad, at the top you can skim through the different types, each type has a different set of associative values that are pertinent to the type of error. The rest is a `description` computed property to satisfy the `CustomStringConvertible` conformance specified. This will allow you to print out human readable error messages for the thrown error type.

//: With the error types defined it is time to start throwing them! First, start with a protocol that defines a rule. You are going to be using protocol oriented programming patterns to make this solution robust and extendable.

protocol StringValidationRule {
  func validate(string: String) throws -> Bool
  var errorType: StringValidationError { get }
}

//: This protocol requires a method that returns a `Bool` regarding the validity of a given string. It can also throw an error! It also requires that you provide the type of error that can be thrown
//: - Note: Although it may appear so, the `errorType` property is not a Swift requirement. This property is accessed later to help describe the rule's requirements.

//: To use multiple rules together, define a `StringValidator` protocol.

protocol StringValidator {
  var validationRules: [StringValidationRule] { get }
  func validate(string: String) -> (valid: Bool,
    errors: [StringValidationError])
}

//: This protocol requires an array of `StringValidationRule`s as well as a function that validates a given string and returns a tuple. The first value of the tuple is the `Bool` that designates if the string is valid or not, the second is an array of `StringValidationError`s. In this case you are not using `throws` but rather returning an array of error types being that multiple errors can occur. In the case of string validation it is always a better user experience to let the user know of every rule they've broken so that they can resolve each one in a single attempt.

//: Now take a step back and think of how you might implement a `StringValidator`'s `validate(string:)` method. It will probably be that you iterate over each item in `validationRules`, collect any errors, and determine the status based on whether or not any errors occurred. This logic will likely be the same for any `StringValidator`. Surely you don't want to copy/paste that implementation into ALL of your `StringValidator`s, right? Well, good news, Swift 2.0 introduces Protocol Extensions.

//: Extend the `StringValidator` protocol to define a default implementation for `validate(string:)`


extension StringValidator {                          // 1
  func validate(string: String) -> (valid: Bool,
    errors: [StringValidationError]) {               // 2
      var errors = [StringValidationError]()         // 3
      for rule in validationRules {                  // 4
        do {                                         // 5
          try rule.validate(string)                  // 6
        } catch let error as StringValidationError { // 7
          errors.append(error)                       // 8
        } catch let error {                          // 9
          fatalError("Unexpected error type: \(error)")
        }
      }
      
      return (valid: errors.isEmpty, errors: errors) // 10
  }
}

//: Excellent! Now any and every `StringValidator` that you implement will have this method by default so that you do not need to copy/paste it in everywhere. Time to implement your very first `StringValidationRule`, starting with the first error type `.MustStartWith`.


struct StartsWithCharacterStringValidationRule: StringValidationRule {
  let characterSet: NSCharacterSet            // 1
  let description: String                     // 2
  var errorType: StringValidationError {      // 3
    return .MustStartWith(set: characterSet,
      description: description)
  }
  
  func validate(string: String) throws -> Bool {
    if string.startsWithCharacterFromSet(characterSet) {
      return true
    } else {
      throw errorType                         // 4
    }
  }
}

//: This rule defines two properties of its own, `characterSet` and `description`, then calls through to a `String` extension method, `startsWithCharacterFromSet(set:)`

//: Time to take this new rule for a spin!

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
    return .MustEndWith(set: characterSet,
      description: description)
  }
  
  func validate(string: String) throws -> Bool {
    if string.endsWithCharacterFromSet(characterSet) {
      return true
    } else {
      throw errorType
    }
  }
}

struct StartsAndEndsWithStringValidator: StringValidator {
  let startsWithSet: NSCharacterSet             // 1
  let startsWithDescription: String
  let endsWithSet: NSCharacterSet               // 2
  let endsWithDescription: String
  
  var validationRules: [StringValidationRule] { // 3
    return [
      StartsWithCharacterStringValidationRule(
        characterSet: startsWithSet,
        description: startsWithDescription),
      EndsWithCharacterStringValidationRule(
        characterSet: endsWithSet ,
        description: endsWithDescription)
    ]
  }
}

let numberSet = NSCharacterSet.decimalDigitCharacterSet()

let startsAndEndsWithStringValidator = StartsAndEndsWithStringValidator(
  startsWithSet: letterSet,
  startsWithDescription: "letter",
  endsWithSet: numberSet,
  endsWithDescription: "number")

startsAndEndsWithStringValidator.validate("1foo").errors

startsAndEndsWithStringValidator.validate("foo").errors

startsAndEndsWithStringValidator.validate("foo1").valid

