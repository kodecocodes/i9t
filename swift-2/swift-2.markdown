# Chapter 1: Swift 2.0

It was nearing the end of the 2014 WWDC Keynote and Craig Federighi was seemingly wrapping up the show. Then, out of left field he dropped the biggest bomb on Apple platform developers that they'd likely ever seen, Swift. A new programming language that he teed up, in a later criticized way, as "Objective-C without the baggage of C". This new language was presented with promises of terseness and safety, while being extremely expressive.

After everyone picked up their jaws from the floor of Presidio in Moscone West (or their keyboards at home), many set out to explore the ins and outs of this brand new language. Swift made the period between WWDC 2014 and 2015 an extremely exciting time to be an Apple platform developer. Everyone was given a chance to reimagine and redefine the way that software for iOS and OS X is written.

## But Why?

Why Swift? Why would Apple care to introduce a new language when Objective-C has served them so well? The reason primarily is that Swift gives Apple a clean slate. They've taken the best features from many different languages and worked them into one. By doing this they've created a language that is modern, expressive, safe, and simply fun to write. Perhaps most interesting and paramount to its success and adoption is that Swift interoperates seamlessly with existing Cocoa and Cocoa Touch frameworks, along with all of your existing Objective-C code.

## The Real "One more thing"

This year's big announcement is that Apple will be open sourcing Swift by the end of 2015! So, what does this mean?

- Swift source code will be released under an OSI-approved permissive license.
- Contributions from the community will be accepted — and encouraged.
- At launch Apple intends to contribute ports for OS X, iOS, and Linux.
- Source code will include the Swift compiler and standard library.

A natural thought when hearing this news might be along the lines of... "This is amazing news, I can write Android apps using Swift! Write once, debug everywhere!!" Well, back that excitement train up and put it in park for a minute. While this is great news it may not mean exactly what you think. First and foremost is that it is highly unlikely that Apple has any intentions of open sourcing the Cocoa or Cocoa Touch frameworks we love so much. These frameworks are what makes it so "easy" to write Mac and iOS apps; consider writing Objective-C programs without NS*Anything* or UI*Anything*. While Swift offers a lot out of the box, you will not have access to those frameworks on other platforms.

But don't let that get you down! The open source community does amazing things every day. The fact that Swift will be open source will attract an entire new set of extremely smart people to make this language even better by providing Swift-only libraries and frameworks that will be usable across platforms. There are so many theoretical possibilities, consider just these two... Using Swift in embedded environments like with Arduino boards or writing server-side Swift for the web and web services. Pretty exciting.

## What Makes Swift, "2.0"?

Now what you really came to read about. What is it that Apple introduced with Swift 2.0 and what will this chapter cover?

- New control flow using `guard`, `repeat`, `do`, and `defer`
- An entirely new error handling model
- Protocol Extensions
- Pattern Matching enhancements
- API Availability Checking
- Additional minor enhancements

So sit tight, this chapter will be packed to the gills with information, feel free to read it end to end or use it as as a reference while you work with Swift 2.0.

## The Logistics

Unlike most chapters in this book, you will _not_ be writing or extending an app. Instead you will be working in a multipage Xcode Playground so that the Swift language features themselves are the focus. For the first part of the chapter you will be introduced to some new features using contrived examples. You will then move on to solving a specific String validation problem using Swift 2.0 features in a tutorial led playground.

Open the provided **Chapter1_Swift2.playground** file in Xcode 7 and continue reading the chapter before diving into the playground.

Enough premise, time for some code!

## Control Flow

Control flow in any programming language is a fundamental concept, if you're not familiar with the term, just know that `if/else` is a control flow. Any construct or keyword that can cause the execution of your program at runtime to take a different path can be considered "control flow". With Swift 2.0 Apple has added to the control flow features and made some minor changes to existing ones. In this section you will read about two new control flow features, the chapter's Playground has all of the code used for this on the "Control Flow" page.

### `repeat`

The `do/while` control flow feature has been renamed to `repeat/while`. Nothing has changed with how this operates, it is simply a name change to reduce confusion with a new usage of `do` described later. This flow simply means "`repeat` this block of code `while` some condition remains `true`".

```
var jamJarBeer = Beer()

repeat {
  jamJarBeer.sip()
} while (!jamJarBeer.isEmpty) // always finish your beer!
```

The example above repeats the line `jamJarBeer.sip()` until `jamJarBeer.isEmpty` is `true`. This was a common occurrence after hours at RWDevCon 2015 :]

### `guard`

Often times it's necessary to do pre-condition checks in your routines to ensure proper state or that valid arguments were passed in. The new `guard` control flow is the perfect tool for doing these checks. Consider the `Beer().sip()` method from above. What happens when you sip an empty beer? What does that even mean? (It probably means you've had too many _or_ need a refill.) Perhaps it would make sense to verify that there is beer available for sipping!

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

Notice the line commented with "1" in the code above. Here a `guard` is used to verify that the amount of beer left is greater than 0, if it is not, then the code in the trailing `else` block is executed. Which in this case instructs you to order another brew! The method then returns immediately so that you don't end up in some weird state where you have a negative amount of beer. Beer debt is not a good thing.

The `guard` control is defined as `guard (condition) else { // code to execute if condition is false }`. Now you might be thinking, "Why not just use an if statement?". Take a look at how you'd have to write that logic.

```
if beer.isEmpty {
  print("Your beer is empty, order another!")
  return
}
```

Pretty simple... But, you had to flip the logic to check that the beer is empty rather than checking that the beer isn't empty, which is of more interest because you'll look silly sipping empty beers. Six of one, half a dozen of the other... right?

This really comes down to expressiveness which is a goal of the Swift language. There's nothing wrong with checking the positive vs negative condition, but what `guard` clearly states to anyone reading this code is that you're performing a pre-condition check. Using a plain ole `if` statement does not deliberately convey that information.

Now, before you write-off `guard` as _just_ an enhancement in expressiveness, take a look at its true power, which is working with Optionals.

Side story: In the world of bartending it is very important to sell more beers. A bartender sees a beer nearing empty and they locate the owner to offer another. A harsh reality though, is that beer owners may abandon a half-drank beer (known as a wounded soldier), hence the reason the `owner` property is Optional on `Beer`.

So how should a bartender behave?

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

Notice the last line of the method where `owner` is accessed as a non-optional value. Since `guard` was used as `guard let owner = beer.owner` the unwrapped optional value becomes available in the same scope that `guard` was called. If the value of `beer.owner` were `nil` then the `else` block would be executed.

This feature allows you to do your optional binding upfront in a very explicit manner. After writing the `guard` conditions you can continue to define your method as if you were working inside of an `if let` block, but without the extra indention! This makes writing code in books _that_ much easier ;]

## Error handling

When Swift was first introduced you would often find questions on Stack Overflow about error handling. A lot of people were looking for exceptions that are found in many popular languages. Instead Apple opted to stick to the `NSError` approach that Cocoa has had since the beginning. This was an OK solution given that having not shipped Swift until they finalized error handling would arguably had been worse.

The good news is that Swift 2.0 now has a first-class error handling model. It's now possible to define that a method or function `throws` an error. When you declare this, you are letting the caller/consumer know that an error may occur. And what's even better, the compiler enforces that extra code is written to handle the error or explicitly ignore it.

All of the code for this section is included on the "Errors" page of the chapter's Xcode Playground.

Consider the following protocol.

```
protocol JSONParsable {
  static func parse(json: [String: AnyObject]) throws -> Self
}
```

This protocol defines a single static method that takes a JSON dictionary and returns an instance of `Self` (where `Self` is the type that conforms to this protocol). The method also declares that it can throw an error.

Now you might be asking yourself, what is a Swift error? Is it an `NSError`? The answer to that question is, yes and no. A pure Swift error is represented as an `enum` that conforms to the protocol `ErrorType`. As for the "yes" part of the answer... Apple Engineers have graciously made `NSError` conform to the `ErrorType` protocol which makes this pattern interoperate very well between Swift and Objective-C. For more information on interoperability the [Swift and Objective-C Interoperability](https://developer.apple.com/videos/wwdc/2015/?id=401) session should not be missed!

It's time to create your own error type.

```
enum ParseError: ErrorType {
  case MissingAttribute(message: String)
}
```

Pretty easy, right? This error has a single case and includes an associative value of the type `String` as a message. Now when you throw this error type you can include some extra information about what is missing. Being that enums are used when creating `ErrorType`s you can include any kind of associative values that you deem necessary for your use case.

Take a look at this `struct` that implements `JSONParsable` and throws some errors.

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

Pay close attention to the commented lines, 1 and 2. This is where the errors are being thrown. If either `guard` statement fails to validate, an error is thrown and the method returns without proceeding further. Also, notice how the usage of `gaurd` makes it very clear as to what is happening due to the expressiveness that it provides.

When calling a method that `throws` it is required by the compiler that you precede the call to that method with **`try`**. In order to capture the thrown errors you must wrap your "trying" call in a `do {}` block followed by `catch {}` blocks. You can choose to catch specific types of errors and respond accordingly and/or provide a "catch-all" if you're not certain of the types of errors that can be thrown.

> **Note**: At the time of this writing, Apple has not provided a way to infer the exact types of errors that can be thrown from a method or function. There is also no way for an API writer to declare what type of error can be thrown. It is a good practice to include this information in your method's documentation.

```
do {
  let person = try Person.parse(["foo": "bar"])
} catch ParseError.MissingAttribute(let message) {
  print(message)
} catch {
  print("Unexpected ErrorType")
}
```

In a situation where you can guarantee that a throwing call will never fail or when catching a thrown error does not provide any benefit (such as a critical situation where the app cannot continue operating); you can bypass the `do/catch` requirement. To do so, you simply type an `!` after `try`.

Try (no pun intended) entering the following into the playground. You should notice a runtime error appear.

```
let p = try! Person.parse(["foo": "bar"])
```

Notice that the following works fine without producing an error.

```
let p = try! Person.parse(["first_name": "Ray",
  "last_name": "Wenderlich"])
```

Excellent! You now know the basics of using Swift 2.0 errors.

## The Project

Now it is time to focus on a specific problem to solve rather than contrived examples. For this next section of the chapter you will be solving a String validation problem using some of the features discussed above as well as more new Swift 2.0 features. The problem involves String validation and the desired outcome is to be able to write validators that given an input string, validate that the string conforms to any number of rules. You will specifically be creating a password requirement validator that ensures a user has chosen a strong password.

Switch to the next page in the chapter's playground, "String Validation".

### String Validation Error

Now that you're familiar with defining custom `ErrorType`s it is time to make use of aa pretty robust one for possible validation errors.

Take a look at the `ErrorType` defined at the top of the playground's "String Validation" page right below `import UIKit`. This `ErrorType` has a number of cases with varying associative values that are used to help describe the error.

After the definition of the cases you will see a computed variable `description`, this is here to conform to the `CustomStringConvertible` protocol and to allow displaying the error in a human readable format that can then be actioned on.

With the error types defined it is time to start throwing them! First, start with a protocol that defines a rule. You are going to be using protocol oriented programming patterns to make this solution robust and extendable.

Add the following protocol definition to the playground.

```
protocol StringValidationRule {
  func validate(string: String) throws -> Bool
  var errorType: StringValidationError { get }
}
```

This protocol requires a method that returns a `Bool` regarding the validity of a given string. It can also throw an error! It also requires that you provide the type of error that can be thrown

> **Note**: Although it may appear so, the `errorType` property is not a Swift requirement. This property is accessed later to help describe the rule's requirements.

To use multiple rules together, define a `StringValidator` protocol.

```
protocol StringValidator {
  var validationRules: [StringValidationRule] { get }
  func validate(string: String) -> (valid: Bool,
    errors: [StringValidationError])
}
```

This protocol requires an array of `StringValidationRule`s as well as a function that validates a given string and returns a tuple. The first value of the tuple is the `Bool` that designates if the string is valid or not, the second is an array of `StringValidationError`s. In this case you are not using `throws` but rather returning an array of error types being that multiple errors can occur. In the case of string validation it is always a better user experience to let the user know of every rule they've broken so that they can resolve each one in a single pass.

Now take a step back and think of how you might implement a `StringValidator`'s `validate(string:)` method. It will probably be that you iterate over each item in `validationRules`, collect any errors, and determine the status based on whether or not any errors have occurred. This logic will likely be the same for any `StringValidator`.

Surely you don't want to copy/paste that implementation into ALL of your `StringValidator`s, right? Well, good news, Swift 2.0 introduces Protocol Extensions that allow you to define default implementations for all types that specify conformance to the protocol.

Extend the `StringValidator` protocol to define a default implementation for `validate(string:)`

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

This method's process is broken down by commented line number below:

1. Create an extension for `StringValidator`
2. Define the default implementation for `func validate(string: String) -> (valid: Bool,
  errors: [StringValidationError])`
3. Create a mutable array to hold any errors that might occur
4. Iterate over each rule that the validator has
5. Specify a `do` block as you will be catching errors if they are thrown
6. Execute `validate(string:)` for each rule, note that you must precede the call with `try` as this method can throw
7. Catch any errors of the type `StringValidationError`
8. Capture the error in your `errors` array
9. If some error other than `StringValidationError` is thrown, crash with a message including what error occurred. This is optional depending on your API design. In this case it would be a developer error that this occurred and it is best to be aware of it as soon as possible, crashes are a simple way to make that obvious. In production code you may prefer to log the error and move on as long as doing so would not put your application in an unstable state.
10. Return the resultant tuple, if there are no errors then validation passed, include the array of errors even if empty.

Excellent! Now any and every `StringValidator` that you implement will have this method by default so that you do not need to copy/paste it in everywhere. Time to implement your very first `StringValidationRule`, starting with the first error type `.MustStartWith`.

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

Breaking this method down...

1. The rule has two properties, the character set that the rule uses to verify the string starts with a character in the given set
2. A description of the rules requirement, if you used a set of numbers you would define "number" for this
3. Define the type of error that this rule can throw
4. Throw the error if validation fails

Time to take this new rule for a spin!

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

You should see the following output in your playground. You can get the result to display inline with your code by pressing the **Show Result** circle button to the right of the output in the playground's timeline.

<!-- Something is amiss with the image below, the top border is clipped, I believe it has to do with the image starting at the top of the page. !-->

![bordered height=16%](./images/starts_with_rule_result.png)

Great work! You've written your first validation rule, now create one for "Must End With".

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

This logic is very similar. You've two different rules so now you can create your own `StringValidator`.

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

Since you wrote a protocol extension for `StringValidator` that provides a default implementation of `func validate(string: String) -> (valid: Bool, errors: [StringValidationError])` the definition of this implementation is very basic.

1. Provide a property to set the character set for the starts with rule
2. Provide another set for the ends with rule
3. Create an array with both rules for `validationRules` which the `StringValidator` protocol requires

Now give your new validator a try!

```
let numberSet = NSCharacterSet.decimalDigitCharacterSet()

let startsAndEndsWithStringValidator = StartsAndEndsWithStringValidator(
  startsWithSet: letterSet,
  startsWithDescription: "letter",
  endsWithSet: numberSet,
  endsWithDescription: "number")

startsAndEndsWithStringValidator.validate("1foo").errors
startsAndEndsWithStringValidator.validate("foo").errors
startsAndEndsWithStringValidator.validate("foo1").valid
```

You should see the following result.

![bordered height=30%](/images/starts_and_ends_with_validator_result.png)

### Password Requirement Validation

Now it is time to put the StringValidator pattern that you've created to real-world use. Often times when signing up often times when signing up for an account you are required to meet a number of rules to ensure that your password is complex. As the software engineer tasked with creating the sign-up form for your company's app you have been told that passwords must meet the follwing requirements.

- Must be at least 8 characters long
- Must contain at least 1 uppercase letter
- Must contain at least 1 lowercase letter
- Must contain at least 1 number
- Must contain at least 1 of the following "\!\@\#\$\%\^\&\*\(\)\_\-\+\<\>\?\/\\\[\]\{\}"

Before coming up with the protocol oriented solution that you just built, you might have looked at this list of requirements and groaned a little. But, groan no more! You can take the pattern that you've built and quickly create a `StringValidator` that contains the rules for this password requirement.

Start by switching to the "Password Validation" page in the chapter's playground. For brevity purposes this playground page tucks away all of the previous work you did on the String Validation page as a source file for this page. That source file also contains two new rules that you will be using. The first is `LengthStringValidationRule` with the following interface.

#### `LengthStringValidationRule`

A rule that validates a string is a specified length, this rule has two Types:
- `.Min(length: Int)`: must be at least `length` long
- `.Max(length: Int)`: cannot exceed `length`
Both types can be combined in a `StringValidator` to ensure the String is between a specific range in length.

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

The second rule is `ContainsCharacterStringValidationRule`.

#### `ContainsCharacterStringValidationRule`

A rule that validates a string contains a specific character. There are multiple Types available:
- `.MustContain`: the string must contain a character in the provided set
- `.CannotContain`: the string cannot contain a character in the provided set
- `.OnlyContain`: the string can only contain characters in the provided set
- `.ContainAtLeast(count: Int)`: the string must contain at least `count` characters in the provided set

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

With these two new rules in your back pocket you can easily implement the password requirement validator.

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

Now, try it out!

```
let passwordValidator = PasswordRequirementStringValidator()
passwordValidator.validate("abc1").errors
passwordValidator.validate("abc1!Fjk").errors
```

You should see the following result:

![bordered height=25%](/images/password_validator_result.png)

Great work!

## Additional Things

The previous sections covered a number of new features in Swift 2.0, but there are even more. For the rest of this chapter you will be experimenting further with some of the previously mentioned features and more new ones. The examples will not be as concrete as the string validation problem, but hopefully still interesting!

### Going further with Extensions

One other amazing thing that you can do with Extensions is provide functionality with generic type parameters. This means that you can provide a method on Arrays that contain a specific type. You can even do this with protocol extensions.

Say that you wanted to make a method that shuffles an array of names to determine the order in which players in a game will take turns. Seems easy enough, right? Take an array of names, mix it up and return it. But what if you later find that you also want to shuffle an array of cards for the game? Now you've got to either reproduce that shuffle logic for an array of cards, or create some kind of generic method that can shuffle both cards and names. There's got to be a better way, right?

Right! How about creating an extension on the `MutableCollectionType` protocol where conformers of the protocol have an Index (you need to use ordered collections if you want to retain sort order).

Type the following into the "Additional Things" page in the chapter's playground.

```
extension MutableCollectionType where Self.Index == Int {
  mutating func shuffleInPlace() {
    let c = self.count
    for i in 0..<(c - 1) {
      let j = Int(arc4random_uniform(UInt32(c - i))) + i
      swap(&self[i], &self[j])
    }
  }
}
```

Next create an array of people and invoke your new method.

```
var people = ["Chris", "Ray", "Sam", "Jake", "Charlie"]
people.shuffleInPlace()
```

You should see that the `people` array has been shuffled like the following.

![bordered height=20%](/images/shuffle_result.png)

If your results are not shuffled, verify that you typed the algorithm correctly or go buy a lottery ticket because it shuffled them into the same order that was received! You can reshuffle to see different results by pointing to **Editor/Execute Playground**.

> **Note:** Extending functionality to generic type parameters is only available to classes and protocols. You will need to create an intermediate protocol to achieve the same with structs.

### Using `defer`

With the introduction of `guard` and `throws`, exiting scope early is now a "first-class" scenario in Swift 2.0. This means that you have to be careful to execute any necessary routines prior to an early exit from occurring. Thankfully Apple has provided `defer { ... }` to ensure that a block of code will always execute before the current scope is exited.

Type the following into the playground and notice the `defer` block defined at the beginning of the `dispenseFunds(amount:account)` method.

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

In this example there are a multiple places that the method can return without proceeding further. One thing is for certain though, an ATM should always return the card to the user, regardless of what error occurs (okay maybe some types of errors would deem keeping the card). The use of the `defer` block guarantees that no matter when the method returns, the user's card will be returned.

Type the following to try this out.

```
var atm = ATM()

var billsAccount = Account(name: "Bill's Account", balance: 500.00, locked: true)
do {
  try atm.dispenseFunds(200.00, account: &billsAccount)
} catch let error {
  print(error)
}
```

Attempting to dispense funds from a locked account throws an `ATMError.AccountLocked` but notice the events that occurred by checking the `atm.log`.

![bordered height=15%](/images/defer_result.png)


### Pattern Matching

Swift has always had amazing pattern matching capabilities, especially with cases in `switch` statements. Swift 2.0 continues to add to the language's ability in this area. Here are a few brief examples.

"for ... in" filtering provides the ability to iterate as you normally would using a for-in loop, except that you can provide a `where` statement so that only iterations whose `where` statement is true will be executed.

```
let names = ["Charlie", "Chris", "Mic", "John", "Craig", "Felipe"]
var namesThatStartWithC = [String]()

for cName in names where cName.hasPrefix("C") {
  namesThatStartWithC.append(cName)
}
```

You can also iterate over a collection of enums of the same type and filter out for a specific case.

```
let authors = [
  Author(name: "Chris Wagner", status: .Late(daysLate: 5)),
  Author(name: "Charlie Fulton", status: .Late(daysLate: 10)),
  Author(name: "Evan Dekhayser", status: .OnTime)
]

let authorStatuses = authors.map { $0.status }

var totalDaysLate = 0

for case let .Late(daysLate) in authorStatuses {
  totalDaysLate += daysLate
}
```

"if case" matching allows you to write more terse conditions rather than using `switch` statements that require a `default` case.

```
var slapLog = ""
for author in authors {
  if case .Late(let daysLate) = author.status where daysLate > 2 {
    slapLog += "Ray slaps \(author.name) around a bit with a large trout.\n"
  }
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

The code above "guards" on the OS version running the application. If the OS version is less than 9.0 the routine will exit immediately. This allows you to freely write against iOS 9 specific APIs beyond the `guard` statement without constantly checking for API availability using methods like `respondsToSelector(:)`.

### Option Sets

The final feature this chapter will discuss is changes to option sets. Prior to Swift 2.0 in both Swift and Objective-C bitmasks were often used to describe a set of options flags. This should be familiar if you've ever done animations with UIKit.

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

## Where to go from here?

While this chapter covered a lot of ground, you mostly just dipped your toes into each feature. There is a ton of power in the new features to Swift 2.0. And there are even more that were not covered here. It is highly recommended that you continue down the path of learning about Swift 2.0 features so that you can write better code and make better apps even faster. Never hesitate to open a new Xcode Playground and start typing away, prototyping ideas has never been easier. One pro-tip is to keep a playground in your Mac's Dock so that you can jump right in at a moment's notice.

You also should not miss the following WWDC 2015 sessions:
- [What's New In Swift](https://developer.apple.com/videos/wwdc/2015/?id=106)
- [Protocol-Oriented Programming in Swift](https://developer.apple.com/videos/wwdc/2015/?id=408)
- [Building Better Apps with Value Types in Swift](https://developer.apple.com/videos/wwdc/2015/?id=414)
- [Improving Your Existing Apps with Swift](https://developer.apple.com/videos/wwdc/2015/?id=403)
- [Swift and Objective-C Interoperability](https://developer.apple.com/videos/wwdc/2015/?id=401)
- [Swift in Practice](https://developer.apple.com/videos/wwdc/2015/?id=411)

All of these and more can be found at [https://developer.apple.com/videos/wwdc/2015/](https://developer.apple.com/videos/wwdc/2015/).

And of course keep the official [Swift Programming Language Book](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/index.html) handy!
