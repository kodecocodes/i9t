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

## Control Flow

Control flow in any programming language is a fundamental concept, if you're not familiar with the term, just know that `if/else` is a control flow. Any construct or keyword that can cause the execution of your program at runtime to take a different path can be considered "control flow". With Swift 2.0 Apple has added to the control flow features and made some minor changes to existing ones. In this section you will read about two new control flow features, the included Playground has all of the code used for this on the "Control Flow" page.

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

Often times its necessary to do pre-condition checks in your routines to ensure proper state or that valid arguments were passed in. The new `guard` control flow is the perfect tool for doing these checks. Consider the `Beer().sip()` method from above. What happens when you sip an empty beer? What does that even mean? (It probably means you've had too many or need a refill.) Perhaps it would make sense to verify that there is beer available for sipping!

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
