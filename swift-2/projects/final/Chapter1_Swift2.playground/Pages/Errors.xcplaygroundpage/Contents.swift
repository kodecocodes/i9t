//: ## Error Handling

import Foundation

/*:

Your first order of business is to clean up the `parse(json:error:)` method so that it's easier to consume. You can do this by indicating that the method `throws` and has a non-optional return type of `Self`. Right away this should appear much more intuitive as to how to use the method. Save for of course that `throws` keyword... What does that mean?

In Swift 2.0, methods and functions can now declare that they "throw" an error. By declaring this, you are relying on the consumer to handle any potential errors that might come about when the method is called.

*/

protocol JSONParsable {
    static func parse(json: [String: AnyObject]) throws -> Self
}

/*:

Now you might be asking yourself, what is a Swift error? Is it an `NSError`? The answer to that question is, yes and no. A pure Swift error is represented as an `enum` that conforms to the protocol `ErrorType`. As for the "yes" part of the answer... Apple Engineers have graciously made `NSError` conform to the `ErrorType` protocol which makes this pattern interoperate very well between Swift and Objective-C. For more information on interoperability the [Swift and Objective-C Interoperability](https://developer.apple.com/videos/wwdc/2015/?id=401) session should not be missed!

It's time to create your own error type.

*/

enum PersonParsingError: ErrorType {
    case MissingAttribute(message: String)
}

/*:

Pretty easy, right? This error has a single case and includes an associative value of the type `String` as a message. Now when you throw this error type you can include some extra information about what is missing. Being that enums are used when creating `ErrorType`s you can include any kind of associative values that you deem necessary for your use case.

*/

struct Person: JSONParsable {
    let firstName: String
    let lastName: String
    
    static func parse(json: [String : AnyObject]) throws -> Person {
        guard let firstName = json["first_name"] as? String else {
            throw PersonParsingError.MissingAttribute(message: "Expected first_name String") // <-- The interesting bits
        }
        
        guard let lastName = json["last_name"] as? String else {
            throw PersonParsingError.MissingAttribute(message: "Expected last_name String") // <-- The interesting bits
        }
        
        return Person(firstName: firstName, lastName: lastName)
    }
}

/*:

To see the benefit this it is time to put it into action. When calling a method that `throws` it is required by the compiler that you precede the call to that method with **`try`**. And then, in order to capture the thrown errors you will need to wrap your "trying" call in a `do {}` block followed by `catch {}` blocks for the type of errors you are catching.
*/

do {
    let person = try Person.parse(["foo": "bar"])
} catch PersonParsingError.MissingAttribute(let message) {
    print(message)
}

/*: 

In case where you can guarantee that the call will never fail by throwing an error or when catching the error does not provide any benefit (such as a critical situation where the app cannot continue operating); you can bypass the `do/catch` requirement. To do so, you simply type an `!` after `try`. Try (no pun intended) entering the following into the playground. You should notice a runtime error appear.

    try! Person.parse(["foo": "bar"])

*/

/*:

Excellent work, now when an expected attribute is missing an error is thrown with information about which one. With that clear, it's time to get back to the problem at hand, string validation, and [put some of your new tricks to real use](String%20Validation).

*/

