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

//: Now take a step back and think of how you might implement a `StringValidator`'s `validate(string:)` method. It will probably be that you iterate over each item in `validationRules`, collect an errors, and determine the status based on whether or not any errors are returned. This logic will likely be the same for any `StringValidator`. Surely you don't want to copy/paste that implementation into ALL of your `StringValidator`s, right? Well, good news, Swift 2.0 introduces Protocol Extensions.

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

//: This rule defines two properties of its own, `characterSet` and `description`, then calls through to the `String` extension method defined earlier, `startsWithCharacterFromSet(set:)

//struct EndsWithCharacterStringValidationRule: StringValidationRule {
//    let characterSet: NSCharacterSet
//    let description: String
//
//    func validate(string: String) throws -> Bool {
//        if string.endsWithCharacterFromSet(characterSet) == false {
//            throw StringValidationError.MustEndWith(set: characterSet, description: description)
//        } else {
//            return true
//        }
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
//struct ProductOptionValueValidator: StringValidator {
//    private let letterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
//    private let numberSet = NSCharacterSet.decimalDigitCharacterSet()
//    private var letterAndNumberSet: NSCharacterSet {
//        let set = NSMutableCharacterSet()
//        set.formUnionWithCharacterSet(letterSet)
//        set.formUnionWithCharacterSet(numberSet)
//        return set
//    }
//
//    let startWithNumber: Bool
//    let startWithLetter: Bool
//
//    let canContainSpaces: Bool
//    let canContainLetter: Bool
//    let canContainNumber: Bool
//
//    let endWithLetter: Bool
//    let endWithNumber: Bool
//
//    let maxLength: Int
//    let minLength: Int
//
//    var validationRules: [StringValidationRule] {
//        var rules = [StringValidationRule]()
//
//        var containCharacterSet: NSMutableCharacterSet? = nil
//        var containDescription = ""
//
//        var startWithCharacterSet: NSCharacterSet? = nil
//        var startWithDescription = ""
//
//        var endWithCharacterSet: NSCharacterSet? = nil
//        var endWithDescription = ""
//
//        func setContainsLettersAndNumbers() {
//            containCharacterSet = letterAndNumberSet.mutableCopy() as? NSMutableCharacterSet
//            containDescription = NSLocalizedString("letters and numbers", comment: "")
//        }
//
//        func setStartsWithLetters() {
//            startWithCharacterSet = letterSet
//            startWithDescription = NSLocalizedString("a letter", comment: "")
//        }
//
//        func setEndsWithLetters() {
//            endWithCharacterSet = letterSet
//            endWithDescription = NSLocalizedString("a letter", comment: "")
//        }
//
//        func setStartsWithNumbers() {
//            startWithCharacterSet = numberSet
//            startWithDescription = NSLocalizedString("a number", comment: "")
//        }
//
//        func setEndsWithNumbers() {
//            endWithCharacterSet = numberSet
//            endWithDescription = NSLocalizedString("a number", comment: "")
//        }
//
//        switch (cL: canContainLetter, cN: canContainNumber, sL: startWithLetter, sN: startWithNumber, eL: endWithLetter, eN: endWithNumber) {
//        case(cL: true, cN: false, _, _, _, _):
//            // starts/ends with doesn't matter, this can only have LETTERS (spaces to be determined later)
//            containCharacterSet = letterSet.mutableCopy() as? NSMutableCharacterSet
//            containDescription = NSLocalizedString("letters", comment: "")
//
//        case (cL: false, cN: true, _, _, _, _):
//            // starts/ends with doesn't matter, this can only have NUMBERS (spaces to be determined later)
//            containCharacterSet = numberSet.mutableCopy() as? NSMutableCharacterSet
//            containDescription = NSLocalizedString("numbers", comment: "")
//
//        case (cL: true, cN: true, sL: true, sN: false, eL: true, eN: false):
//            // can contain both, but has to start and end with LETTERS
//            setContainsLettersAndNumbers()
//            setStartsWithLetters()
//            setEndsWithLetters()
//
//        case (cL: true, cN: true, sL: false, sN: true, eL: false, eN: true):
//            // can contain both, but has to start and end with NUMBERS
//            setContainsLettersAndNumbers()
//            setStartsWithNumbers()
//            setEndsWithNumbers()
//
//        case (cL: true, cN: true, sL: true, sN: false, eL: false, eN: true):
//            // can contain both, but has to start with LETTERS and end with NUMBERS
//            setContainsLettersAndNumbers()
//            setStartsWithLetters()
//            setEndsWithNumbers()
//
//        case (cL: true, cN: true, sL: false, sN: true, eL: true, eN: false):
//            // can contain both, but has to start with NUMBERS and end with LETTERS
//            setContainsLettersAndNumbers()
//            setStartsWithNumbers()
//            setEndsWithLetters()
//
//        case (cL: true, cN: true, sL: _, sN: _, eL: true, eN: false):
//            // can contain both, but has to end with LETTERS
//            setContainsLettersAndNumbers()
//            setEndsWithLetters()
//
//        case (cL: true, cN: true, sL: _, sN: _, eL: false, eN: true):
//            // can contain both, but has to end with NUMBERS
//            setContainsLettersAndNumbers()
//            setEndsWithNumbers()
//
//        default:
//            // some crazy rule config, just allow letters and numbers
//            print("Unexpected rule configuration, allowing numbers and characters anywhere.")
//            setContainsLettersAndNumbers()
//        }
//
//        if canContainSpaces == true {
//            containCharacterSet?.addCharactersInString(" ")
//        } else {
//            let rule = ContainsCharacterStringValidationRule(characterSet: NSCharacterSet(charactersInString: " "), description: "spaces", type: .CannotContain)
//            rules.append(rule)
//        }
//
//        if let containCharacterSet = containCharacterSet {
//            let rule = ContainsCharacterStringValidationRule(characterSet: containCharacterSet, description: containDescription, type: .OnlyContain)
//            rules.append(rule)
//        }
//
//        if let startWithCharacterSet = startWithCharacterSet {
//            let rule = StartsWithCharacterStringValidationRule(characterSet: startWithCharacterSet, description: startWithDescription)
//            rules.append(rule)
//        }
//
//        if let endWithCharacterSet = endWithCharacterSet {
//            let rule = EndsWithCharacterStringValidationRule(characterSet: endWithCharacterSet, description: endWithDescription)
//            rules.append(rule)
//        }
//
//        if minLength > 0 {
//            let rule = LengthStringValidationRule(type: .Min, length: minLength)
//            rules.append(rule)
//        }
//
//        if maxLength > 0 {
//            let rule = LengthStringValidationRule(type: .Max, length: maxLength)
//            rules.append(rule)
//        }
//
//
//        return rules
//    }
//
//}
//
//let optionValidator = ProductOptionValueValidator(
//    startWithNumber: true,
//    startWithLetter: false,
//    canContainSpaces: false,
//    canContainLetter: true,
//    canContainNumber: true,
//    endWithLetter: true,
//    endWithNumber: false,
//    maxLength: 6,
//    minLength: 3)
//
//optionValidator.validate("abc1234").errors
//
//optionValidator.validate("ab").errors
//
//optionValidator.validate("g 34 bed").errors
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

