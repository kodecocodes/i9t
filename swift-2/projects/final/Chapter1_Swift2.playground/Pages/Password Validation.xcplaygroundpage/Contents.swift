//: [Previous](@previous)

import UIKit

struct PasswordRequirementStringValidator: StringValidator {
  
  var validationRules: [StringValidationRule] {
    let upper = NSCharacterSet.uppercaseLetterCharacterSet()
    let lower = NSCharacterSet.lowercaseLetterCharacterSet()
    let number = NSCharacterSet.decimalDigitCharacterSet()
    let special = NSCharacterSet(
      charactersInString: "!@#$%^&*()_-+<>?/\\[]}{")
    return [
      LengthStringValidationRule(type: .Min(length: 8)),
      ContainsCharacterStringValidationRule(
        characterSet:upper ,
        description: "upper case letter",
        type: .ContainAtLeast(1)),
      ContainsCharacterStringValidationRule(
        characterSet: lower,
        description: "lower case letter",
        type: .ContainAtLeast(1)),
      ContainsCharacterStringValidationRule(
        characterSet:number ,
        description: "number",
        type: .ContainAtLeast(1)),
      ContainsCharacterStringValidationRule(
        characterSet:special,
        description: "special character",
        type: .ContainAtLeast(1))
    ]
  }
}

let passwordValidator = PasswordRequirementStringValidator()
passwordValidator.validate("abc1").errors


passwordValidator.validate("abc1!Fjk").errors


//: Strings are great, but here's another example of a protocol extension to give all of your validators a little bit of visualization greatness.

extension StringValidator {
  func visualize(string: String) -> UIView {
    if #available(iOS 9.0, *) { // required to get this working in the playground, perhaps a beta bug.
      var labels = [UILabel]()
      var widestLabelWidth: CGFloat = 0
      for rule in validationRules {
        let label = UILabel()
        do {
          try rule.validate(string)
          label.text = "✅ " + rule.errorType.description
        } catch let error as StringValidationError {
          label.text = "❌ " + error.description
        } catch {
          fatalError("Unexpected error type")
        }
        let width = label.sizeThatFits(CGSize(width: .max, height: 25)).width
        widestLabelWidth = width > widestLabelWidth ? width : widestLabelWidth
        labels.append(label)
      }
      let rect = CGRect(x: 0.0, y: 0.0, width: widestLabelWidth, height: CGFloat(labels.count * 25))
      let stackView = UIStackView(frame: rect)
      stackView.axis = .Vertical
      stackView.distribution = .FillEqually
      for label in labels {
        label.backgroundColor = .whiteColor()
        stackView.addArrangedSubview(label)
      }
      
      return stackView
    } else {
      fatalError("This playground requires iOS 9")
    }
  }
}


//: Take a look! This might be a nice view to put near the password field. Then as the user chooses their password they can see that they are meeting all of the defined requirements with each key stroke. Try changing the string to meet the requirements.

passwordValidator.visualize("ab@aasdadsa")
