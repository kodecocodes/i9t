```metadata
author: Chris Wagner
number: 1
title: Swift 2.0
```

# Chapter 1: Swift 2.0

The 2014 WWDC keynote was nearly over, and Craig Federighi appeared to be wrapping things up. But instead he shocked nearly everyone watching by announcing the Swift programming language, which he promised, perhaps optimistically, as "Objective-C without the baggage of C". Swift would have the benefits of terseness and safety, while still being extremely expressive.

Once the implications of a new programming language had sunk in, many developers set out to explore the ins and outs of Swift. The year following WWDC 2014 was an exciting time for developers on the Apple platform; each developer had a chance to reimagine and redefine they way they wrote software for iOS and OS X.

## Whither Swift?

Why would Apple introduce a new language, since Objective-C has served them so well? It's likely because Swift gave Apple a fresh start; Swift takes the best features from many different languages and combines them into one. Apple has created a language that is modern, expressive, safe, and a lot of fun to develop in. Swift also interoperates seamlessly with existing Cocoa and Cocoa Touch frameworks as well as all of your existing Objective-C code. This is likely one of the primary reasons Swift has seen such success and widespread adoption in the developer community.

## The Real "One more thing"

WWDC 2015's big announcement is the open-sourcing of Swift by the end of 2015! But what does this really mean?

- Swift source code will be released under an OSI-approved permissive license.
- Contributions from the community will be accepted — and encouraged.
- At launch, Apple intends to contribute ports of Swift for OS X, iOS, and Linux.
- Source code will include the Swift compiler and the standard library.

You might be thinking "This is amazing! I can write Android apps using Swift! Write once, debug everywhere!!" :] Well, back that excitement train up a bit. While open-sourcing Swift _is_ great news, it's highly unlikely Apple has any intention of open-sourcing the Cocoa or Cocoa Touch frameworks you love so much. These frameworks make it "easy" to write Mac and iOS apps; consider how you'd write an Objective-C program without NS*Anything* or UI*Anything*. While Swift does offer a lot out of the box, you unfortunately won't have access to those frameworks on other platforms.

But don't let that get you down! The open source community does amazing things every day. Open-source Swift will attract smart, creative people who will make the language even better with Swift-only libraries and frameworks that work across platforms. Someday you could find yourself using Swift in embedded environments such as Arduino, or perhaps someday you'll write server-side web services in Swift. It's an exiting time for Swift developers!

## What Makes Swift, "2.0"?

It's great to dream about the future of Swift, but this chapter highlights what Swift 2.0 offers you in the present day:

- New control flow using `guard`, `repeat`, `do`, and `defer`
- An entirely new error handling model
- Protocol extensions
- Pattern matching enhancements
- API availability checking
- Additional minor enhancements

This chapter is packed with information; you can read it end to end or use it as as a reference as you work with Swift 2.0.

## The Logistics

Unlike most chapters in this book, you _won't_ write or extend an app in this chapter. Instead, you'll work in a multipage Xcode Playground with the Swift language features as the focus. The first part of the chapter will introduce you to some new features using somewhat contrived examples; the second half walks you thorough the solution of a specific String validation problem using Swift 2.0 features in a tutorial-led playground.

Open the provided **Chapter1_Swift2.playground** file in Xcode 7 and you'll be ready to dive right into the chapter!

> **Note:** When running Playgrounds in Xcode 7 GM you may often see error messages like the following in the Debug Area. `CGContextSaveGState: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.` According to Apple engineers in the [developer forums (http://apple.co/1FbVE0l)](http://apple.co/1FbVE0l) it is safe to ignore these messages.

## Control Flow

Control flow is a fundamental concept in any programming language. Not sure what "control flow" means? A basic example is `if/else`; any construct or keyword that causes the execution of your program to follow a different path can be considered "control flow". Swift 2.0 adds new control flow features and makes some minor changes to existing ones. The two new control flow featues covered in this section are found on your playground's **Control Flow** page.

### `repeat`

The `do/while` control flow feature has been renamed to `repeat/while`. It operates the same way as before; the name has simply changed to reduce confusion with a new usage of `do` described later on in this chapter. This flow simply means "`repeat` this block of code `while` some condition remains `true`". Consider the following example:

```
var jamJarBeer = Beer()

repeat {
  jamJarBeer.sip()
} while (!jamJarBeer.isEmpty) // always finish your beer!
```

The above snippet repeats the line `jamJarBeer.sip()` until `jamJarBeer.isEmpty` is `true` — a common occurrence after-hours at RWDevCon 2015! :]

### `guard`

Pre-condition checks are frequently required for proper state management, or to ensure that valid arguments were passed. The new `guard` control flow is the perfect tool for doing these checks. Consider the `Beer().sip()` method above. What happens when you sip an empty beer? What does that even mean? (It probably means you've had too many _or_ need a refill. :]) Perhaps it makes sense to verify that there is beer available for sipping, like so:

```
struct Beer {
  var percentRemaining = 100
  var isEmpty: Bool { return percentRemaining <= 0 }
  var owner: Patron?

  mutating func sip() {
    guard percentRemaining > 0 else {             // 1
      print("Your beer is empty, order another!")
      return
    }

    percentRemaining -= 10
    print("Mmmm \(percentRemaining)% left")
  }
}
```

The `//1` comment indicates the `guard` that verifies the amount of beer left is greater than 0 and if not, executes the code in the trailing `else` block, which instructs you to order another brew! You then return immediately so you don't end up in some weird state with a negative amount of beer. Beer debt is not a good thing.

The `guard` control is defined as `guard (condition) else { // code to execute if condition is false }`. You _could_ use an `if` statement instead, but the logic is not quite as straightforward:

```
if beer.isEmpty {
  print("Your beer is empty, order another!")
  return
}
```

The snippet above flips the logic and checks that the beer is empty, instead of checking that the beer _isn't_ empty. But isn't this just personal coding preference?

Not exactly; it comes down to _expressiveness_, which is a primary goal of Swift. Functionally, they're equivalent, but `guard` clearly states to anyone reading your code that you're performing a pre-condition check. Using a plain old `if` statement does not deliberately convey that information.

Now, before you write-off `guard` as _just_ an enhancement in expressiveness, take a look at its true power: working with Optionals.

Consider the world of bartending: success is measured in the number of beers you sell. As a beer nears empty, the bartender tries to locate the owner so they can offer another. A harsh reality though, is that beer owners may abandon a half-drunk beer (known as a wounded soldier), hence the reason the `owner` property is Optional on `Beer`.

Here's a good model for a successful bartender:

```
struct Bartender {
  func offerAnotherToOwnerOfBeer(beer: Beer) {
    guard let owner = beer.owner else {
      print("Egads, another wounded soldier to attend to.")
      return
    }

    print("\(owner.name), would you care for another?") // 1
  }
}
```

Note that you access `owner` as a non-optional value in the last line above. Since you used `guard` in `guard let owner = beer.owner`, the unwrapped optional value becomes available in the same scope that `guard` was called. If the value of `beer.owner` were `nil` then the `else` block would execute.

This feature lets you perform your optional binding upfront in a very explicit manner. After writing the `guard` conditions, you can continue your implementation as you would in an `if let` block, but without the extra indention.

## Error handling

The early days of Swift led to many questions on Stack Overflow about error handling, and in particular, _exceptions_ as found in other popular languages. Apple instead opted to stick to the `NSError` approach Cocoa has always used and release Swift with the promise of advanced error handling in the next version.

Swift 2.0 has a first-class error handling model; you can declare that a method or function `throws` an error. This lets the caller/consumer know an error may occur. The compiler also requires that you either write the code to handle the error, or to explicitly ignore it.

All of the code for this section is included on the **Errors** page of the chapter's Xcode Playground.

Consider the following protocol:

```
protocol JSONParsable {
  static func parse(json: [String: AnyObject]) throws -> Self
}
```

This protocol defines a single static method that takes a JSON dictionary and returns an instance of `Self`, where `Self` is the type that conforms to this protocol. The method also declares that it can throw an error.

So, what exactly _is_ a Swift error? Is it an `NSError`? No...and yes. :] A pure Swift error is represented as an `enum` that conforms to the protocol `ErrorType`. However, Apple Engineers conveniently made `NSError` conform to the `ErrorType` protocol, which means this pattern works quite well between Swift and Objective-C. If you're interested to learn more about interoperability, the Swift and Objective-C Interoperability [(http://apple.co/1He5uhh)](https://developer.apple.com/videos/wwdc/2015/?id=401) session is a must-see!

You can create your own error type as below:

```
enum ParseError: ErrorType {
  case MissingAttribute(message: String)
}
```

Pretty easy, right? This error has a single case and includes an associative value of the type `String` as a message. When you throw this error type you can include extra information describing the issue. Since enums are used when creating `ErrorType`s you can include any kind of associative values that you deem necessary for your use case.

Take a look at the following `struct` that implements `JSONParsable` and throws some errors:

```
struct Person: JSONParsable {
  let firstName: String
  let lastName: String

  static func parse(json: [String : AnyObject]) throws -> Person {
    guard let firstName = json["first_name"] as? String else {
      let message = "Expected first_name String"
      throw ParseError.MissingAttribute(message: message) // 1
    }

    guard let lastName = json["last_name"] as? String else {
      let message = "Expected last_name String"
      throw ParseError.MissingAttribute(message: message) // 2
    }

    return Person(firstName: firstName, lastName: lastName)
  }
}
```

The errors are thrown in the commented lines `//1` and `//2`. If either `guard` statement fails to validate, the method throws an error and returns immediately. The expressiveness of the `guard` statement makes it very clear what you're asserting at each stage.

When calling a method that `throws`, the compiler requires that you preface the call to that method with **`try`**. In order to capture any thrown errors, you must wrap your "trying" call in a `do {}` block followed by `catch {}` blocks. You can choose to catch specific types of errors and respond appropriately to each error type, or simply provide a "catch-all" if you don't know what errors you might receive.

> **Note**: At the time of this writing, Apple hasn't provided a way to infer the exact types of errors that can be thrown from a method or function. There is also no way for an API writer to declare what types of errors will be thrown. Therefore, it's good practice to include this information in your method's documentation.

Here's the do/try/catch block that checks for the error type you added above:

```
do {
  let person = try Person.parse(["foo": "bar"])
} catch ParseError.MissingAttribute(let message) {
  print(message)
} catch {
  print("Unexpected ErrorType")
}
```

When you can guarantee a throwing call will _never_ fail, or that catching a thrown error doesn't provide any benefit, such as a critical failure point where the app can't continue to operate, it is possible to bypass the `do/catch` requirement: simply type an `!` after `try`.

Find and uncomment the following line in the playground:

```
let p1 = try! Person.parse(["foo": "bar"])
```

You'll notice a runtime error appears. Note, however, that the following works just fine without producing an error:

```
let p2 = try! Person.parse(["first_name": "Ray",
  "last_name": "Wenderlich"])
```

Now that you understand the basics of handling Swift 2.0 errors, you can focus on a specific problem to solve, rather than work with contrived examples.

## The Project

In this section, you'll work at solving a String validation problem using some of the features discussed above along with some additional Swift 2.0 features. You're trying to write string validators that validate whether the input string conforms to any number of rules. You'll use this validator to create a password complexity checker.

### String Validation Error

Switch to the next page in the chapter's playground, **String Validation**. Now that you're familiar with defining custom `ErrorType`s, it's time to make use of robust error types for potential validation errors.

Take a look at the `ErrorType` defined at the top of the playground's "String Validation" page, right below `import UIKit`. This `ErrorType` has a number of cases with varying associative values that help describe the error.

After the spot where you define the cases, you'll see a computed variable `description`. This provides conformance to the `CustomStringConvertible` protocol and lets you display the error in a human-readable format.

Now that the error type is defined, it's time to start throwing them around! :] You'll first start with a protocol that defines a rule. You are going to be using protocol oriented programming patterns to make this solution robust and extendable.

Add the following protocol definition to the playground:

```
protocol StringValidationRule {
  func validate(string: String) throws -> Bool
  var errorType: StringValidationError { get }
}
```

This protocol requires two things. The first being a method that returns a `Bool` denoting the validity of a given string and also throws an error. The second is a property which describes the type of error that may be thrown by the `validate(string:)` method.

> **Note:** The `errorType` property is not a Swift requirement. It's here so that you can be clear about the types of error that might be returned.

To use multiple rules together, define a `StringValidator` protocol like so:

```
protocol StringValidator {
  var validationRules: [StringValidationRule] { get }
  func validate(string: String) -> (valid: Bool,
    errors: [StringValidationError])
}
```

This protocol requires an array of `StringValidationRule`s as well as a function that validates a given string and returns a tuple. The first value of the tuple is a `Bool` that designates whether the string is valid; the second is an array of `StringValidationError`s. In this case you're not using `throws`; instead, you're returning an array of error types since each rule can throw its own error. When it comes to string validation, it's best to let the user know of every rule they've broken so that they can resolve all of them in a single pass.

Think how you might implement a `StringValidator`'s `validate(string:)` method. You'd likely iterate over each item in `validationRules`, collect any errors, and determine the status based on whether any errors occurred. This logic will likely be the same for any `StringValidator` you need.

Surely you don't want to copy and paste that implementation into ALL of your `StringValidator`s! The good news is that Swift 2.0 introduces **Protocol Extensions** that let you define default implementations for all types that specify conformance to a protocol.

Next, you'll extend the `StringValidator` protocol to define a default implementation for `validate(string:)`. Add the following code to the playground:

```
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
```

Here's what you do in each commented section above:

1. Create an extension for `StringValidator`.
2. Define the default implementation for `func validate(string: String) -> (valid: Bool, errors: [StringValidationError])`.
3. Create a mutable array to hold any errors that might be thrown.
4. Iterate over each of the the validator's rules.
5. Specify a `do` block since you'll catch any thrown errors.
6. Execute `validate(string:)` for each rule; note that you must precede the call with `try` as this method is throwable.
7. Catch any errors of the type `StringValidationError`.
8. Capture the error in your `errors` array.
9. If any error other than `StringValidationError` is thrown, crash with a message including which error occurred. Just as in a `switch` statement, your error handling must be exhaustive, or you'll get a compiler error.
10. Return the resultant tuple. If there are no errors validation passed, return the array of errors even if it's empty.

Now each and every `StringValidator` you implement will have this method by default so you can avoid "copy and paste" coding. :]

Time to implement your very first `StringValidationRule`, starting with the first error type `.MustStartWith`. Add the following code to your playground:

```
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
```

Breaking this method down, here's what you find:

1. This defines the allowed character set for the start of the string.
2. This is a description of the character set; if you used a set of numbers you might define this as "number".
3. This is the type of error  this rule can throw.
4. Finally, if the validation fails you throw an error.

Time to take this new rule for a spin! Add the following code to the playground:

```
let letterSet = NSCharacterSet.letterCharacterSet()
let startsWithRule = StartsWithCharacterStringValidationRule(
  characterSet: letterSet,
  description: "letter")

do {
  try startsWithRule.validate("foo")
  try startsWithRule.validate("123")
} catch let error {
  print(error)
}
```

You should see the following output in your playground.

![bordered height=16%](./images/starts_with_rule_result.png)

> **Note:** You can display the result inline with your code by pressing the **Show Result** circle button to the right of the output in the playground's timeline.

Great work! You've written your first validation rule; now you can create one for "Must End With". Add the following to the playground:

```
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
```

The above logic is quite similar to the first validator; it simply checks the ending character against your supplied character set.

Now that you have two different rules, you can create your first `StringValidator`. Create a validator that verifies a string both starts and ends with characters belonging to specific character sets by adding the following code:

```
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
```

Since you wrote a protocol extension for `StringValidator` that provides a default implementation of `func validate(string: String) -> (valid: Bool, errors: [StringValidationError])` this implementation becomes quite straightforward:

1. This is the character set for the "starts with" rule.
2. This is the character set for the "ends with" rule.
3. Create an array with both rules for `validationRules` required by the `StringValidator` protocol.

Now give your new validator a try! Add the following to the playground:

```
let numberSet = NSCharacterSet.decimalDigitCharacterSet()

let startsAndEndsWithValidator = StartsAndEndsWithStringValidator(
  startsWithSet: letterSet,
  startsWithDescription: "letter",
  endsWithSet: numberSet,
  endsWithDescription: "number")

startsAndEndsWithValidator.validate("1foo").errors.description
startsAndEndsWithValidator.validate("foo").errors.description
startsAndEndsWithValidator.validate("foo1").valid
```

You should see the following result:

![bordered height=30%](/images/starts_and_ends_with_validator_result.png)

### Password Requirement Validation

It's time to put your StringValidator pattern to work. You're the software engineer tasked with creating the sign-up form for your company's app. The design specifies that passwords must meet the following requirements:

- Must be at least 8 characters long
- Must contain at least 1 uppercase letter
- Must contain at least 1 lowercase letter
- Must contain at least 1 number
- Must contain at least 1 of the following "\!\@\#\$\%\^\&\*\(\)\_\-\+\<\>\?\/\\\[\]\{\}"

If you hadn't worked through the protocol-oriented solution above, you might have looked at this list of requirements and groaned a little. But instead you can take the pattern you've built and quickly create a `StringValidator` that contains the rules for this password requirement.

Start by switching to the **Password Validation** page in the chapter's playground. For brevity, this playground page tucks away all of the previous work as a source file, which also contains two new rules you'll use. Click **Password Validation** > **Sources** > **StringValidation.swift** in the jump bar to view the code in that file.

#### `LengthStringValidationRule`

The first new rule is `LengthStringValidationRule` that has the following features:

- Validates that a string is a specified length, with the following two types:
- `Min(length: Int)`: must be at least `length` long
- `Max(length: Int)`: cannot exceed `length`

Both types can be combined in a `StringValidator` to ensure the String is between a specific range in length. Here's the rule implementation:

```
public struct LengthStringValidationRule : StringValidationRule {
    public enum Type {
        case Min(length: Int)
        case Max(length: Int)
    }
    public let type: Type
    public var errorType: StringValidationError { get }
    public init(type: Type)
    public func validate(string: String) throws -> Bool
}
```

#### `ContainsCharacterStringValidationRule`

The second rule is `ContainsCharacterStringValidationRule`, with the following requirements:

- Validates that a string contains specific character(s) with the following types:
- `MustContain`: the string must contain a character in the provided set.
- `CannotContain`: the string cannot contain a character in the provided set.
- `OnlyContain`: the string can only contain characters in the provided set.
- `ContainAtLeast(count: Int)`: the string must contain at least `count` characters in the provided set.

Here's the implementation:

```
public struct ContainsCharacterStringValidationRule : StringValidationRule {
    public enum Type {
        case MustContain
        case CannotContain
        case OnlyContain
        case ContainAtLeast(Int)
    }
    public let characterSet: NSCharacterSet
    public let description: String
    public let type: Type
    public var errorType: StringValidationError { get }
    public init(characterSet: NSCharacterSet,
      description: String,
      type: Type)
    public func validate(string: String) throws -> Bool
}
```

With these two new rules in your back pocket you can quickly implement the password requirement validator. Add the following to the **Password Validation** page in the playground:

```
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
```

You'll recognize this code as being very similar to the concrete string validator you created. It simply provides an implementation for the `validationRules` computed property, which returns an array of the four rules you need to satisfy your requirements, in a remarkably readable configuration.

Now, try it out! Add the following to the playground:

```
let passwordValidator = PasswordRequirementStringValidator()
passwordValidator.validate("abc1").errors
passwordValidator.validate("abc1!Fjk").errors
```

You should see the following result:

![bordered width=95%](/images/password_validator_result.png)

Great work - you've used protocol oriented programming with Swift 2.0 features to implement a solution to a real-world non-trivial problem.

## Additional Things

The previous sections covered a number of new features in Swift 2.0, but wait - there's more! (Is it just me, or is this starting to sound like an infomercial? :])

The remainder of this chapter has you experimenting with some of the previously mentioned features and introduces you to some new features. The examples won't be as concrete as the string validation problem, but hopefully still interesting nonetheless!

### Going further with Extensions

One other amazing thing about Extensions is that you can provide functionality with generic type parameters; this means that you can provide a method on arrays that contain a specific type. You can even do this with protocol extensions.

For example, say that you wanted to create a method that shuffles an array of names to determine the order of players in a game. Seems easy enough, right? You simply take an array of names, mix it up and return it. Done and done. But what if you later discover a need to shuffle an array of cards for the same game? Now you have to either reproduce that shuffle logic for an array of cards, or create some kind of generic method that can shuffle both cards and names. There's got to be a better way, right?

How about creating an extension on the `MutableCollectionType` protocol? Conformers of the protocol must have an Index since you need to use ordered collections to retain the sort order.

Add the following into the **Additional Things** page in the chapter's playground:

```
extension MutableCollectionType where Index == Int {
  mutating func shuffleInPlace() {
    let c = self.count
    for i in 0..<(c-1) {
      let j = Int(arc4random_uniform(UInt32(c - i))) + i
      guard i != j else { continue }
      swap(&self[i], &self[j])
    }
  }
}
```

Next, you need to create an array of people and invoke your new method. Add the following code:

```
var people = ["Chris", "Ray", "Sam", "Jake", "Charlie"]
people.shuffleInPlace()
```

You should see that the `people` array has been shuffled like so:

![bordered height=20%](/images/shuffle_result.png)

If your results aren't shuffled, verify that you typed the algorithm correctly or go buy a lottery ticket because it shuffled them into the same order that was received! You can reshuffle to see different results by pointing to **Editor/Execute Playground**.

> **Note:** Extending functionality to generic type parameters is only available to classes and protocols. You will need to create an intermediate protocol to achieve the same with structs.

### Using `defer`

With the introduction of `guard` and `throws`, exiting scope early is now a "first-class" scenario in Swift 2.0. This means that you have to be careful to execute any necessary routines prior to an early exit from occurring. Thankfully Apple has provided `defer { ... }` to ensure that a block of code will always execute before the current scope is exited.

Review the following and notice the `defer` block defined at the beginning of the `dispenseFunds(amount:account:)` method.

```
struct ATM {
  var log = ""

  mutating func dispenseFunds(amount: Float,
    inout account: Account) throws {

    defer {
      log += "Card for \(account.name) has been returned to customer.\n"
      ejectCard()
    }

    log += "====================\n"
    log += "Attempted to dispense \(amount) from \(account.name)\n"

    guard account.locked == false else {
      log += "Account Locked\n"
      throw ATMError.AccountLocked
    }

    guard account.balance >= amount else {
      log += "Insufficient Funds\n"
      throw ATMError.InsufficientFunds
    }

    account.balance -= amount
    log += "Dispensed \(amount) from \(account.name)."
    log += " Remaining balance: \(account.balance)\n"
  }

  func ejectCard() {
    // physically eject card
  }
}
```

In this example there are a multiple places that the method can exit early. One thing is for certain though, an ATM should always return the card to the user, regardless of what happens. The use of the `defer` block guarantees that no matter when the method exits, the user's card will be returned.

Find the line where `billsAccount` is declared and after it type the following to try dispensing funds:

```
do {
  try atm.dispenseFunds(200.00, account: &billsAccount)
} catch let error {
  print(error)
}
```

Attempting to dispense funds from a locked account throws an `ATMError.AccountLocked`, but add `atm.log` and read the output:

![bordered height=15%](/images/defer_result.png)

Bill's card was returned even though the method exited early.

### Pattern Matching

Swift has had amazing pattern matching capabilities since the beginning, especially with cases in `switch` statements. Swift 2.0 continues to add to the language's ability in this area. Here are a few brief examples.

"for ... in" filtering combines a for-in loop and a `where` statement so that only iterations whose `where` statement is true will be executed. Use for ... in filtering to create an array of names that start with "C". Find the **Pattern Matching** section of the page and enter the following:

```
var namesThatStartWithC = [String]()

for cName in names where cName.hasPrefix("C") {
  namesThatStartWithC.append(cName)
}
```

You can also iterate over a collection of enums of the same type and filter out for a specific case. Given the array `authorStatuses` in the playground, write a for loop that matches on the `Late(Int)` case and calculates the total number of days that authors are behind.

```
var totalDaysLate = 0

for case let .Late(daysLate) in authorStatuses {
  totalDaysLate += daysLate
}
```

"if case" matching allows you to write more terse conditions rather than using `switch` statements that require a `default` case. The following iterates over the `authors` array and slaps each other who is late!

```
var slapLog = ""
for author in authors {
  if case .Late(let daysLate) = author.status where daysLate > 2 {
    slapLog += "Ray slaps \(author.name) around a bit with a large trout.\n"
  }
}
```

### Option Sets

Prior to Swift 2.0 in both Swift and Objective-C bitmasks were often used to describe a set of options flags. This should be familiar if you've ever done animations with UIKit.

You can now type a set of option flags like you would any other `Set<T>`, which was introduced in Swift 1.2.

```
animationOptions = [.Repeat, .CurveEaseIn]
```

Also, the fact that this is a Swift Set, you get all of the functionality that Sets have to offer. Creating your own option set is as simple as defining a structure that conforms to the `OptionSetType` protocol.

```
struct RectangleBorderOptions: OptionSetType {
  let rawValue: Int

  init(rawValue: Int) { self.rawValue = rawValue }

  static let Top = RectangleBorderOptions(rawValue: 0)
  static let Right = RectangleBorderOptions(rawValue: 1)
  static let Bottom = RectangleBorderOptions(rawValue: 2)
  static let Left = RectangleBorderOptions(rawValue: 3)
  static let All: RectangleBorderOptions = [Top, Right, Bottom, Left]
}
```

This section concludes the use of the chapter's playground, so you can put that aside.

### OS Availability

As Apple continually introduces new versions of iOS (and OS X) they give developers new frameworks and APIs to utilize. The problem with this is that unless you drop support for previous versions of the OS you cannot safely use the new APIs without a lot of messy runtime checks which always leads to missed cases and basic human error, resulting in a crashing app.

In Swift 2.0 you can now let the compiler help you. There is not enough time to cover all of the use cases here but as a quick introduction consider the following example.

```
guard #available(iOS 9.0, *) else { return }
// do some iOS 9 or higher only thing
```

The code above "guards" on the iOS version running the application. If the iOS version is less than 9.0 the routine will exit immediately. This allows you to freely write against iOS 9 specific APIs beyond the `guard` statement without constantly checking for API availability using methods like `respondsToSelector(:)`.

The compiler will also you know if you've used a new API when your deployment target is set to some OS version where the API is not available.

## Where to go from here?

While this chapter covered a lot of ground, you mostly just dipped your toes into each feature. There is a ton of power in the new features of Swift 2.0. And there are even more that were not covered here. It is highly recommended that you continue down the path of learning about Swift 2.0 features so that you can write better code and make better apps even faster. Never hesitate to crack open an  Xcode Playground and start hacking away, prototyping ideas has never been easier. One pro-tip is to keep a playground in your Mac's Dock so that you can jump right in at a moment's notice.

You also should not miss the following WWDC 2015 sessions:
- [What's New In Swift (http://apple.co/1IBTu8q)](https://developer.apple.com/videos/wwdc/2015/?id=106)
- [Protocol-Oriented Programming in Swift (http://apple.co/1B8r2LE)](https://developer.apple.com/videos/wwdc/2015/?id=408)
- [Building Better Apps with Value Types in Swift (http://apple.co/1KMQesY)](https://developer.apple.com/videos/wwdc/2015/?id=414)
- [Improving Your Existing Apps with Swift (http://apple.co/1LiO462)](https://developer.apple.com/videos/wwdc/2015/?id=403)
- [Swift and Objective-C Interoperability (http://apple.co/1He5uhh)](https://developer.apple.com/videos/wwdc/2015/?id=401)
- [Swift in Practice (http://apple.co/1LPx2cq)](https://developer.apple.com/videos/wwdc/2015/?id=411)

All of these and more can be found at [https://developer.apple.com/videos/wwdc/2015/ (http://apple.co/1HXDwT7)](https://developer.apple.com/videos/wwdc/2015/).

And of course keep the official [Swift Programming Language Book (http://apple.co/1n5tB6q)](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/index.html) handy!
