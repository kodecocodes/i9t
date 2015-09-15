//: Go back to [String Validation](@previous)

import UIKit

//: Define the `PasswordRequirementStringValidator` below
struct PasswordRequirementsStringValidator : StringValidator {
  var validationRules: [StringValidationRule] {
    let upper = NSCharacterSet.uppercaseLetterCharacterSet()
    let lower = NSCharacterSet.lowercaseLetterCharacterSet()
    let number = NSCharacterSet.decimalDigitCharacterSet()
    let special = NSCharacterSet(charactersInString: "!@#$%^&*()_-+<>?/\\[]}{")
    return [
      LengthStringValidationRule(type: .Min(length:8)),
      ContainsCharacterStringValidationRule(characterSet: upper, description: "upper case letter", type: .ContainAtLeast(1)),
      ContainsCharacterStringValidationRule(characterSet: lower, description: "lower case letter", type: .ContainAtLeast(1)),
      ContainsCharacterStringValidationRule(characterSet: number, description: "number", type: .ContainAtLeast(1)),
      ContainsCharacterStringValidationRule(characterSet: special, description: "special character", type: .ContainAtLeast(1)),
    ]
  }
}
//: Create a new instance of `PasswordRequirementStringValidator` and test it out.
let passwordValidator = PasswordRequirementsStringValidator()
passwordValidator.validate("abc1").errors.description
passwordValidator.validate("abc1!Fjk").errors
//: Move on to [Additional Things](@next)
