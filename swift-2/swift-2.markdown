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
