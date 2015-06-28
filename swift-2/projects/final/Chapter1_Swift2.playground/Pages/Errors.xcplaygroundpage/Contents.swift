//: ## Error Handling

import Foundation

/*:

The first order of business is to clean up the `parse(json:error:)` method so that it's easier to consume. You can do this by saying that the method `throws` and has a non-optional return type of `Self`. Right away this should appear much more intuitive as to how to use the method. Save for of course that `throws` keyword, what does that mean?

In Swift 2.0, methods and functions can now declare that they "throw" an error. By declaring this, you are relying on the consumer to handle any potential errors that might come about when the method is called.

*/

protocol JSONParsable {
    static func parse(json: [String: AnyObject]) throws -> Self
}

/*:

Now you're probably asking yourself, what is an error? Is it an `NSError`? The answer to that question is, yes and no. A pure Swift error is represented as an `enum` that conforms to the protocol `ErrorType`. As for the "yes" part of the answer... Apple Engineers have graciously made `NSError` conform to the `ErrorType` protocol which makes this pattern interoperate very well between Swift and Objective-C. For more information on interoperability the [Swift and Objective-C Interoperability](https://developer.apple.com/videos/wwdc/2015/?id=401) session should not be missed!

Now to create your own error type.

*/

enum PersonParsingError: ErrorType {
    case MissingAttribute(message: String)
}

/*:

Pretty easy, right? This error has a single case and includes an associated value of the type `String` as a message. Now when you throw this error type you can include some extra information about what is missing. Being that enums are used when creating `ErrorType`s you can include any kind of associative values that you deem necessary for your use case.

*/

struct Person: JSONParsable {
    let firstName: String
    let lastName: String
    
    static func parse(json: [String : AnyObject]) throws -> Person {
        guard let firstName = json["first_name"] as? String else {
            throw PersonParsingError.MissingAttribute(message: "Expected first_name String")
        }
        
        guard let lastName = json["last_name"] as? String else {
            throw PersonParsingError.MissingAttribute(message: "Expected last_name String")
        }
        
        return Person(firstName: firstName, lastName: lastName)
    }
}

/*:

Now to see the benefit of all of this it is time to see things in action. When calling a method that `throws` it is required by the compiler that you precede the call to that method with **`try`**. And then, in order to capture the thrown errors you will need to wrap your "trying" call in a `do {}` block followed by `catch {}` blocks for the type of errors you are catching.
*/

do {
    let person = try Person.parse(["foo": "bar"])
} catch PersonParsingError.MissingAttribute(let message) {
    print(message)
}

/*:

Excellent work, now when an expected attribute is missing an error is thrown with information about which one. With that clear, it's time to get back to the problem at hand, string validation, and put some of your new tricks to real use.

*/





//enum StringValidationError: ErrorType, CustomStringConvertible {
//    
//    case MustStartWith(set: NSCharacterSet, description: String)
//    case MustContain(set: NSCharacterSet, description: String)
//    case MustEndWith(set: NSCharacterSet, description: String)
//    
//    case CannotContain(set: NSCharacterSet, description: String)
//    case CanOnlyContain(set: NSCharacterSet, description: String)
//    case ContainAtLeast(set: NSCharacterSet, count: Int, description: String)
//    
//    case MinLengthNotReached(Int)
//    case MaxLengthExceeded(Int)
//    
//    var description: String {
//        let errorString: String
//        switch self {
//        case .MustStartWith(_, let description):
//            errorString = "Must start with \(description)."
//        case .MustEndWith(_, let description):
//            errorString = "Must end with \(description)."
//        case .MustContain(_, let description):
//            errorString = "Must contain \(description)."
//        case .CannotContain(_, let description):
//            errorString = "Cannot contain \(description)."
//        case .CanOnlyContain(set: _, let description):
//            errorString = "Can only contain \(description)."
//        case .ContainAtLeast(_, let count, let description):
//            errorString = "Must contain at least \(count) \(description)."
//        case .MinLengthNotReached(let minChars):
//            errorString = "Must be at least \(minChars) characters."
//        case .MaxLengthExceeded(let maxChars):
//            errorString = "Must be shorter than \(maxChars) characters."
//        }
//        
//        return errorString
//    }
//}
//
//protocol StringValidationRule {
//    func validate(string: String) throws -> Bool
//}
//
//protocol StringValidator {
//    var validationRules: [StringValidationRule] { get }
//    func validate(string: String) -> (valid: Bool, errors: [StringValidationError])
//}
//
//extension StringValidator {
//    func validate(string: String) -> (valid: Bool, errors: [StringValidationError]) {
//        var errors = [StringValidationError]()
//        for rule in validationRules {
//            do {
//                try rule.validate(string)
//            } catch let error as StringValidationError {
//                errors.append(error)
//                print("Validation error: \(error)")
//                continue
//            } catch {
//                fatalError("Unexpected error type")
//            }
//        }
//        
//        return (errors.count == 0, errors)
//    }
//}
//
//struct StartsWithCharacterStringValidationRule: StringValidationRule {
//    let characterSet: NSCharacterSet
//    let description: String
//    
//    func validate(string: String) throws -> Bool {
//        if string.startsWithCharacterFromSet(characterSet) == false {
//            throw StringValidationError.MustStartWith(set: characterSet, description: description)
//        } else {
//            return true
//        }
//    }
//}
//
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
