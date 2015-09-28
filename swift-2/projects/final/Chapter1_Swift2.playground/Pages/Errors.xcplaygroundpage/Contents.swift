//: Go back to [Control Flow](@previous)
//: ## Error Handling

import Foundation

//: In Swift 2.0, methods and functions can now declare that they "throw" an error. By declaring this, you are relying on the consumer to handle any potential errors that might come about when the method is called.
protocol JSONParsable {
  static func parse(json: [String: AnyObject]) throws -> Self
}

//: Create your own error type.
enum ParseError: ErrorType {
  case MissingAttribute(message: String)
}

/*:
Pretty easy, right? This error has a single case and includes an associative value of the type `String` as a message. Now when you throw this error type you can include some extra information about what is missing. Being that enums are used when creating `ErrorType`s you can include any kind of associative values that you deem necessary for your use case.

Define a `struct` that implements `JSONParsable` and throws some errors.

*/
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

//: When calling a method that `throws` it is required by the compiler that you precede the call to that method with **`try`**. And then, in order to capture the thrown errors you will need to wrap your "trying" call in a `do {}` block followed by `catch {}` blocks for the type of errors you are catching.
do {
  let person = try Person.parse(["foo": "bar"])
} catch ParseError.MissingAttribute(let message) {
  print(message)
} catch {
  print("Unexpected ErrorType")
}

//: In a case where you can guarantee that a call will never throw an error or when catching the error does not provide any benefit (such as a critical situation where the app cannot continue operating); you can bypass the `do/catch` requirement. To do so, you simply type an `!` after `try`. Try (no pun intended) entering the following into the playground. You should notice a runtime error appear. Uncomment the following line to see the error.

//  let p1 = try! Person.parse(["foo": "bar"])

//: Notice that this line does not fail because it meets the requirements of the `parse()` implementation.
let p2 = try! Person.parse(["first_name": "Ray",
  "last_name": "Wenderlich"])

//: Move on to [String Validation](@next)
