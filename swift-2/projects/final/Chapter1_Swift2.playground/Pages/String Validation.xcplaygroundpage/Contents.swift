//: [Previous](@previous)
import Foundation
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

//: While pretty big, this ErrorType is not too bad, at the top you can skim through the different types, each type has a different set of associative values that are pertinent to the type of error. The rest is a `description` computed properpty to satisfy the `CustomStringConvertible` conformance specified. This will allow you to print out human readable error messages for the thrown error type.

//: With the error types defined it is time to start throwing them! First, start with a protocol that defines a rule. You are going to be using protocol oriented programming patterns to make this solution robust and extendable.

protocol StringValidationRule {
    func validate(string: String) throws -> Bool
}

//: This protocol simply requires a method that returns a `Bool` regarding the validity of a given string. It can also throw an error!

//: To use multiple rules together, define a `StringValidator` protocol.

protocol StringValidator {
    var validationRules: [StringValidationRule] { get }
    func validate(string: String) -> (valid: Bool, errors: [StringValidationError])
}

//: This protocol requires an array of `StringValidationRule`s as well as a function that validates a given string and returns a tuple. The first value of the tuple is the `Bool` that designates if the string is valid or not, the second is an array of `StringValidationError`s. In this case you are not using `throws` but rather returning an array of error types being that multiple errors can occurr. In the case of string validation it is always a better user experience to let the user know of every rule they've broken so that they can resolve each one in a single attempt.

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

    func validate(string: String) throws -> Bool {
        if string.startsWithCharacterFromSet(characterSet) == false {
            throw StringValidationError.MustStartWith(set: characterSet, description: description)
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

    func validate(string: String) throws -> Bool {
        if string.endsWithCharacterFromSet(characterSet) == false {
            throw StringValidationError.MustEndWith(set: characterSet, description: description)
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

//struct CustomStringValidator: StringValidator {
//    var validationRules: [StringValidationRule]
//    init(rules: [StringValidationRule]) {
//        validationRules = rules
//    }
//}



//
//struct ContainsCharacterStringValidationRule: StringValidationRule {
//    enum Type {
//        case MustContain, CannotContain, OnlyContain, ContainAtLeast(Int)
//    }
//
//    let characterSet: NSCharacterSet
//    let description: String
//    let type: Type
//
//    func validate(string: String) throws -> Bool {
//        switch type {
//        case .MustContain:
//            if string.containsCharacterFromSet(characterSet) == false {
//                throw StringValidationError.MustContain(set: characterSet, description: description)
//            }
//        case .CannotContain:
//            if string.containsCharacterFromSet(characterSet) == true {
//                throw StringValidationError.CannotContain(set: characterSet, description: description)
//            }
//        case .OnlyContain:
//            if string.containsCharacterFromSet(characterSet.invertedSet) == true {
//                throw StringValidationError.CanOnlyContain(set: characterSet, description: description)
//            }
//        case .ContainAtLeast(let count):
//            if string.countOfCharactersFromSet(characterSet) < count {
//                throw StringValidationError.ContainAtLeast(set: characterSet, count: count, description: description)
//            }
//        }
//
//        return true
//    }
//}
//
//struct LengthStringValidationRule: StringValidationRule {
//    enum Type {
//        case Min, Max
//    }
//
//    let type: Type
//    let length: Int
//
//    func validate(string: String) throws -> Bool {
//        switch type {
//        case .Min:
//            if string.characters.count < length {
//                throw StringValidationError.MinLengthNotReached(length)
//            }
//        case .Max:
//            if string.characters.count > length {
//                throw StringValidationError.MaxLengthExceeded(length)
//            }
//        }
//
//        return true
//    }
//}
//
//struct CustomStringValidator: StringValidator {
//    var validationRules: [StringValidationRule]
//    init(rules: [StringValidationRule]) {
//        validationRules = rules
//    }
//}
//
//
////let set = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
////"ABCDEFGHIJKLMNOPQRSTUVWXYZ".countOfCharactersFromSet(set)
////
////"ABCDEFGHIJKLMNOPQRSTUVWXYZ".startsWithCharacterFromSet(NSCharacterSet.uppercaseLetterCharacterSet()) // false
////"ABCDEFGHIJKLMNOPQRSTUVWXYZ".startsWithCharacterFromSet(NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")) // true
//
//let rules: [StringValidationRule] = [
//    ContainsCharacterStringValidationRule(characterSet: NSCharacterSet.uppercaseLetterCharacterSet(), description: "upper case letters", type: .ContainAtLeast(3)),
//    ContainsCharacterStringValidationRule(characterSet: NSCharacterSet.lowercaseLetterCharacterSet(), description: "lower case letters", type: .ContainAtLeast(3))
//]
//let customValidator = CustomStringValidator(rules: rules)
//customValidator.validate("AaaDa").errors
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////

