//: # Chapter 1: Swift 2.0

import Foundation

/*: ## The Problem

In this playground you will be solving an age old problem of validating strings. Often times when building applications there are business rules for what users can input. String validation is one aspect of validating user input. You will see how to take advantage of new Swift 2.0 features to solve this problem. You will also be adopting a protocol oriented programming approach which has been heavily pushed by Apple Engineers this year at WWDC. 

*/


//: ## Introducing `guard` and `repeat`
//: Below is a `String` extension to provide convenience methods to use while implementing string validation rules later on.

extension String {
    
    func startsWithCharacterFromSet(set: NSCharacterSet) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        return rangeOfCharacterFromSet(set, options: [], range: startIndex..<startIndex.successor()) != nil
    }
    
    
/*:

Notice the use of **`guard`** to exit early if the string is not empty. Without `guard` you may have written the following:

    if isEmpty {
        return false
    }

While this may not be the best example of the power of `guard` it's important to realize a couple of benefits. 
    
1. The use of `guard` is a clear indicator that you are doing pre-condition checks before continuing with your routine. The use of `if` blocks do not clearly indicate this to a person reading your code.
2. When using an `if` condition you must write the evaluation inversely of what you're checking for, which can become mind bending very quickly and result in human error.

*/

    
    func endsWithCharacterFromSet(set: NSCharacterSet) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        return rangeOfCharacterFromSet(set, options: [], range: endIndex.predecessor()..<endIndex) != nil
    }
    
    func containsCharacterFromSet(set: NSCharacterSet) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        return rangeOfCharacterFromSet(set) != nil
    }
    
/*:

In the method below you will notice **`repeat`**. This new keyword replaces `do` from the `do { ... } while (condition)` construct. This is primarily to reduce confusion for when `do` is used with error handling which will be discussed later on. It is safe and required to replace your `do-while` constructs with `repeat-while` when migrating to Swift 2.0.

*/
    func countOfCharactersFromSet(set: NSCharacterSet) -> Int {
        guard !isEmpty else {
            return 0
        }
        var count = 0
        var range: Range? = startIndex..<endIndex
        
        repeat {
            if let newRange = rangeOfCharacterFromSet(set, options: [], range: range) {
                count += newRange.count
                range = newRange.endIndex..<endIndex
            } else {
                range = nil
            }
        } while range != nil
        
        return count
    }
}

/*:

Before continuing down the path of solving the string validation problem, now is a good time to take a break and look at the true power of `guard` statements. The `guard` statement's most compelling feature is the ability to optionally bind values which then become available to use in the current scope. Consider the following contrived example.

*/

protocol JSONParsable {
    static func parse(json: [String: AnyObject], error: NSErrorPointer) -> Self?
}

/*:

Below you will find a `Person` struct that conforms to the `JSONParsable` protocol defined above. The protocol defines a single static function `parse(json:error:)` with dictionary and `NSErrorPointer` paramters. Then returns an optional `Self`.

When parsing JSON from a server there is no guarantee that what you expect to be returned will actually be returned. To safely access expected values you should use optional binding. By using `guard` you can guarantee that the value you need is successfully unwrapped, much like using `if let`. The main difference with `guard` is that the unwrapped value becomes available in the same scope that `guard` was called. Furthermore, if unwrapping fails you can construct an `else` block to do something and then exit the current scope early if it does not make sense to continue.

*/

struct Person: JSONParsable {
    let firstName: String
    let lastName: String
    
    static func parse(json: [String : AnyObject], error: NSErrorPointer) -> Person? {
        guard let firstName = json["first_name"] as? String else {
            error.memory = NSError(domain: "com.raywenderlich.jsonparsing", code: 1, userInfo: [NSLocalizedFailureReasonErrorKey: "Expected first_name String"])
            return nil
        }
        
        guard let lastName = json["last_name"] as? String else {
            error.memory = NSError(domain: "com.raywenderlich.jsonparsing", code: 2, userInfo: [NSLocalizedFailureReasonErrorKey: "Expected last_name String"])
            return nil
        }
        
        return Person(firstName: firstName, lastName: lastName)
    }
}

//: Putting it to use...

var error: NSError?
if let person = Person.parse(["foo": "bar"], error: &error) {
    print("Hello, \(person.firstName) \(person.lastName)")
} else if let error = error, reason = error.localizedFailureReason {
    print(reason)
}


/*:

Now you may be asking yourself, "What the heck! I thought Swift 2.0 promised a great new error handling system?" Well, you're right. The above implementation is less than optimal in the world of Swift 2.0. Your API might return `nil` and also writes to a provided `NSErrorPointer`, the consumer of your API is on the hook for handling both of those (at least you hope that they do). It's time to clean this up with [Swift 2.0's new error handling](Errors).

*/

