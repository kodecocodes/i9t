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



//: Define the `StringValidator` protocol below



//: Extend the `StringValidator` protocol to define a default implementation for `validate(string:)`



//: Time to implement your very first `StringValidationRule`, starting with one forthe first error type `.MustStartWith` and name it `StartsWithCharacterStringValidationRule`



//: Take this new rule for a spin!



//: Now define another rule, `EndsWithCharacterStringValidationRule` so that you can create a `StringValidator` that uses both rules in conjunction.



//: Create a `StringValidator` named `StartsAndEndsWithStringValidator` that uses both the StartsWith an EndsWith rules.



//: Create a new instance of the validator to be used.



//: Test that the validator works and view the resulting errors for invalid strings



//: Move on to [Password Validation](@next)
