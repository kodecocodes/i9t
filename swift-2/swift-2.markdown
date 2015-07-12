# Chapter 1: Swift 2.0

It was nearing the end of the 2014 WWDC Keynote and Craig Federighi came back up on stage. Without much hesitation or fanfare he dropped the biggest bomb on Apple platform developers that they'd ever seen, Swift. A new language introduced, in a later criticized way, as "Objective-C without the C". This new language was filled with promises of terseness and safety, while being extremely expressive. After everyone picked their jaws up from the floor, many set out to explore the ins and outs of this brand new language. Swift made the period between WWDC 2014 and 2015 an extremely exciting time to be an Apple platform developer. Everyone was given a chance to reimagine and redefine the way that software for iOS and OS X is written.

## But Why?

Why Swift? Why would Apple care to introduce a new language when Objective-C has served them so well? The reason primarily is that Swift gives Apple a clean slate. They've taken the best features from many different languages and worked them into one. By doing this they've created a language that is modern, expressive, safe, and simply fun to write. Perhaps most interesting and paramount to its success and adoption is that Swift interoperates seamlessly with existing Cocoa and Cocoa Touch frameworks, along with all of your existing Objective-C code.

## The Real "One more thing"

This year's big announcement is that Apple will be open sourcing Swift by the end of 2015! So, what does this mean?

- Swift source code will be released under an OSI-approved permissive license.
- Contributions from the community will be accepted — and encouraged.
- At launch we intend to contribute ports for OS X, iOS, and Linux.
- Source code will include the Swift compiler and standard library.

A natural thought when hearing this news might be along the lines of... "This is amazing news, I can write Android apps using Swift! Write once, debug everywhere!!" Well, back that excitement train up and put it in park for a minute. While this is great news it may not mean exactly what you think. First and foremost is that it is highly unlikely that Apple has any intentions of open sourcing Cocoa or Cocoa Touch frameworks. These frameworks are what makes it so "easy" to write Mac and iOS apps, consider writing Objective-C programs without NS*Anything* or UI*Anything*. While Swift offers a lot out of the box, you still will not have access to those frameworks on other platforms.

But don't let that get you down! The open source community does amazing things every day. The fact that Swift will be open source will attract an entire new set of extremely smart people to make this language even better by providing Swift-only libraries and frameworks that will usable across platforms. There are so many theoretical possibilities, consider just these two... Using Swift in embedded environments like Arduino boards or writing server-side Swift. Pretty exciting.

## What Makes Swift, "2.0"?

Now what you really came to read about. What is it that Apple introduced with Swift 2.0 and what will this chapter cover?

- New control flow using `guard`, `repeat`, `do`, and `defer`
- New error handling model
- Protocol Extensions
- Pattern Matching enhancements
- Availability Checking
- Additional minor enhancements

So sit tight, this will be chapter packed to the gills with information, feel free to read it end to end or use it as as a reference while you work with Swift 2.0.

## The Logistics

Unlike most chapters in this book, you will _not_ be writing or extending an app in this one. Instead you will be working in a multipage Xcode Playground so that the Swift language features themselves are the focus. For the first part of the chapter you will be introduced to some new features using contrived examples. You will then move on to solving a specific String validation problem using Swift 2.0 features in a tutorial style playground.

Open the provided **Chapter1_Swift2.playground** file in Xcode 7 and continue reading the chapter before diving into the playground.

Enough premise, time for some code!

## Control Flow

Control flow in any programming language is a fundamental concept, if you're not familiar with the term, just know that `if/else` is a control flow. Any construct or keyword that can cause the execution of your program at runtime to take a different path can be considered "control flow". With Swift 2.0 Apple has added to the control flow features and made some minor changes to existing ones. In this section you will read about two new control flow features, the chapter's Playground has all of the code used for this on the "Control Flow" page.

### `repeat`

The `do/while` control flow feature has been renamed to `repeat/while`. Nothing has changed with how this operates, it is simply a name change to reduce confusion with the new usage of `do`. This flow simply means "`repeat` this block of code `while` some condition remains `true`".

```
var jamJarBeer = Beer()

repeat {
  jamJarBeer.sip()
} while (!jamJarBeer.isEmpty) // always finish your beer!
```

The example above repeats the line `jamJarBeer.sip()` until `jamJarBeer.isEmpty` is `true`. This was a common occurrence after hours at RWDevCon 2015 :]

### `guard`

Often times it's necessary to do pre-condition checks in your routines to ensure proper state or that valid arguments were passed in. The new `guard` control flow is the perfect tool for doing these checks. Consider the `Beer().sip()` method from above. What happens when you sip an empty beer? What does that even mean? (It probably means you've had too many or need a refill.) Perhaps it would make sense to verify that there is beer available for sipping!

```
struct Beer {
  var percentRemaining = 100
  var isEmpty: Bool { return percentRemaining <= 0 }
  var owner: Patron?

  mutating func sip() {
    guard percentRemaining > 0 else { // 1
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
  func offerOwnerOfBeerAnother(beer: Beer) {
    guard let owner = beer.owner else {
      print("Egads, another wounded soldier to attend to.")
      return
    }

    print("\(owner.name), would you care for another?") // 1
  }
}
```

Notice the last line of the method where `owner` is accessed as a non-optional value. Since `guard` was used as `guard let owner = beer.owner` the unwrapped optional value becomes available in the same scope that `guard` was called. If the value of `beer.owner` were `nil` then the defined `else` block will be executed and the method immediately returns.

This feature allows you to do your optional binding upfront in a very explicit manner. After writing the `guard` conditions you can continue to define your method as if you were working inside of an `if let` block, but without the extra indention! This makes writing code in books _that_ much easier ;]

## Error handling

When Swift was first introduced you would often find questions on Stack Overflow about error handling. A lot of people were looking for exceptions that are found in many popular languages. Instead Apple opted to stick to the `NSError` approach that Cocoa has had since the beginning. This was an OK solution given that having not shipped Swift until they finalized error handling would arguably been worse.

The good news is that Swift 2.0 now has a first-class error handling model. It's now possible to define that a method or function `throws` an error. When you declare this, you are letting the caller/consumer know that an error may occur. And what's even better, the compiler enforces that they write extra code to handle the error.

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

Pay close attention to the commented lines, 1 and 2. This is where the errors are being thrown. If either `guard` statement fails to validate, an error is thrown and the method returns without proceeding further. Also, notice the usage of `gaurd`. It becomes very clear as to what is happening with the added expressiveness that `gaurd` provides.

When calling a method that `throws` it is required by the compiler that you precede the call to that method with **`try`**. In order to capture the thrown errors you must wrap your "trying" call in a `do {}` block followed by `catch {}` blocks. You can choose to catch specific types of errors and respond accordingly and/or provide a "catch-all" if you're not certain of the types of errors that can be thrown.

> **Note**: At the time of this writing, Apple has not provided a way to infer the exact type of errors that can be thrown from a method or function. There is also no way to declare what type of error can be thrown. As an API writer it is a good practice to include this information in your method's documentation.

```
do {
  let person = try Person.parse(["foo": "bar"])
} catch ParseError.MissingAttribute(let message) {
  print(message)
} catch {
  print("Unexpected ErrorType")
}
```

In case where you can guarantee that the call will never fail by throwing an error or when catching the error does not provide any benefit (such as a critical situation where the app cannot continue operating); you can bypass the `do/catch` requirement. To do so, you simply type an `!` after `try`. Try (no pun intended) entering the following into the playground. You should notice a runtime error appear.

```
let p = try! Person.parse(["foo": "bar"])
```

Notice that the following works fine without producing an error.

```
let p = try! Person.parse(["first_name": "Ray",
  "last_name": "Wenderlich"])
```

Excellent! You now have the basics down for using Swift 2.0 errors!
