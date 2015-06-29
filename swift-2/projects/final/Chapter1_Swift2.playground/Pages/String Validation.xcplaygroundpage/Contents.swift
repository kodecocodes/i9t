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
    func validate(string: String) -> (valid: Bool, errors: [StringValidationError])
}

//: This protocol requires an array of `StringValidationRule`s as well as a function that validates a given string and returns a tuple. The first value of the tuple is the `Bool` that designates if the string is valid or not, the second is an array of `StringValidationError`s. In this case you are not using `throws` but rather returning an array of error types being that multiple errors can occur. In the case of string validation it is always a better user experience to let the user know of every rule they've broken so that they can resolve each one in a single attempt.

//: Now take a step back and think of how you might implement a `StringValidator`'s `validate(string:)` method. It will probably be that you iterate over each item in `validationRules`, collect any errors, and determine the status based on whether or not any errors occurred. This logic will likely be the same for any `StringValidator`. Surely you don't want to copy/paste that implementation into ALL of your `StringValidator`s, right? Well, good news, Swift 2.0 introduces Protocol Extensions.

//: Extend the `StringValidator` protocol to define a default implementation for `validate(string:)`


extension StringValidator {
    func validate(string: String) -> (valid: Bool, errors: [StringValidationError]) {
        var errors = [StringValidationError]()
        for rule in validationRules {
            do {
                try rule.validate(string)
            } catch let error as StringValidationError {
                errors.append(error)
                print("Validation error: \(error)")
                continue
            } catch {
                fatalError("Unexpected error type")
            }
        }

        return (errors.count == 0, errors)
    }
}

//: Excellent! Now any and every `StringValidator` that you implement will have this method by default so that you do not need to copy/paste it in everywhere. Time to implement your very first `StringValidationRule`, starting with the first error type `.MustStartWith`.


struct StartsWithCharacterStringValidationRule: StringValidationRule {
    let characterSet: NSCharacterSet
    let description: String
    var errorType: StringValidationError {
        return StringValidationError.MustStartWith(set: characterSet, description: description)
    }

    func validate(string: String) throws -> Bool {
        if string.startsWithCharacterFromSet(characterSet) == false {
            throw errorType
        } else {
            return true
        }
    }
}

//: This rule defines two properties of its own, `characterSet` and `description`, then calls through to the `String` extension method defined earlier, `startsWithCharacterFromSet(set:)`

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
        return StringValidationError.MustEndWith(set: characterSet, description: description)
    }

    func validate(string: String) throws -> Bool {
        if string.endsWithCharacterFromSet(characterSet) == false {
            throw errorType
        } else {
            return true
        }
    }
}

struct StartsAndEndsWithStringValidator: StringValidator {
    let startsWithSet: NSCharacterSet
    let startsWithDescription: String
    let endsWithSet: NSCharacterSet
    let endsWithDescription: String
    
    var validationRules: [StringValidationRule] {
        return [
            StartsWithCharacterStringValidationRule(characterSet: startsWithSet, description: startsWithDescription),
            EndsWithCharacterStringValidationRule(characterSet: endsWithSet , description: endsWithDescription)
        ]
    }
}

let numberSet = NSCharacterSet.decimalDigitCharacterSet()

let startsAndEndsWithStringValidator = StartsAndEndsWithStringValidator(startsWithSet: letterSet, startsWithDescription: "letter", endsWithSet: numberSet, endsWithDescription: "number")

startsAndEndsWithStringValidator.validate("1foo").errors

startsAndEndsWithStringValidator.validate("foo").errors

startsAndEndsWithStringValidator.validate("foo1").valid

//: Great! The validators work and have human readable error messages when the validation fails. Below are a couple more to be used next.


struct ContainsCharacterStringValidationRule: StringValidationRule {
    enum Type {
        case MustContain, CannotContain, OnlyContain, ContainAtLeast(Int)
    }

    let characterSet: NSCharacterSet
    let description: String
    let type: Type
    var errorType: StringValidationError {
        switch type {
        case .MustContain:
            return StringValidationError.MustContain(set: characterSet, description: description)
        case .CannotContain:
            return StringValidationError.CannotContain(set: characterSet, description: description)
        case .OnlyContain:
            return StringValidationError.CanOnlyContain(set: characterSet, description: description)
        case .ContainAtLeast(let count):
            return StringValidationError.ContainAtLeast(set: characterSet, count: count, description: description)
        }
    }

    func validate(string: String) throws -> Bool {
        switch type {
        case .MustContain:
            if string.containsCharacterFromSet(characterSet) == false {
                throw errorType
            }
        case .CannotContain:
            if string.containsCharacterFromSet(characterSet) == true {
                throw errorType
            }
        case .OnlyContain:
            if string.containsCharacterFromSet(characterSet.invertedSet) == true {
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

struct LengthStringValidationRule: StringValidationRule {
    enum Type {
        case Min(length: Int)
        case Max(length: Int)
    }

    let type: Type
    var errorType: StringValidationError {
        switch type {
        case .Min(let length):
            return StringValidationError.MinLengthNotReached(length)

        case .Max(let length):
            return StringValidationError.MaxLengthExceeded(length)
        }
    }

    func validate(string: String) throws -> Bool {
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

//: Now to build a more complex validator, a password requirements validator to be specific.

struct PasswordRequirementStringValidator: StringValidator {
    
    var validationRules: [StringValidationRule] {
        return [
            LengthStringValidationRule(type: .Min(length: 8)),
            ContainsCharacterStringValidationRule(characterSet: NSCharacterSet.uppercaseLetterCharacterSet(),
                description: "upper case letter",
                type: .ContainAtLeast(1)),
            ContainsCharacterStringValidationRule(characterSet: NSCharacterSet.lowercaseLetterCharacterSet(),
                description: "lower case letter",
                type: .ContainAtLeast(1)),
            ContainsCharacterStringValidationRule(characterSet: NSCharacterSet.decimalDigitCharacterSet(),
                description: "number",
                type: .ContainAtLeast(1)),
            ContainsCharacterStringValidationRule(characterSet: NSCharacterSet(charactersInString: "!@#$%^&*()_-+<>?/\\[]}{"), description: "special character", type: .ContainAtLeast(1))
        ]
    }
}

let passwordValidator = PasswordRequirementStringValidator()
passwordValidator.validate("abhc1!Gas").errors


passwordValidator.validate("abc1").errors


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



