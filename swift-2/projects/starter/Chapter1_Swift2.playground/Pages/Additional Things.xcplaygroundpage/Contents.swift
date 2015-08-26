//: Go back to [Password Validation](@previous)

import Foundation

//: ## Additional Things
//: The previous sections covered a number of new features in Swift 2.0, but there is even more. For the rest of this chapter you will be experimenting further with some of the previously mentioned features and more new ones. The examples will not be as concrete as the string validation problem, but hopefully still interesting!


//: ### Going further with Extensions
//: Define the `shuffleInPlace()` method below.




//: Test out the `shuffleInPlace()` method.




//: ### Using `defer`
//: Review the following and take notice of the `defer` block at the beginning of `dispenseFunds(amount:account:)`

struct ATM {
  var log = ""
  
  mutating func dispenseFunds(amount: Float, inout account: Account) throws{
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
    log += "Dispensed \(amount) from \(account.name). Remaining balance: \(account.balance)\n"
  }
  
  func ejectCard() {
    // physically eject card
  }
}

//: Test out the ATM to ensure that the defer block is being executed as expected.
var atm = ATM()
//: Attempt to dispense funds from Bill's account.
var billsAccount = Account(name: "Bill's Account", balance: 500.00, locked: true)



//: Below are a few more examples for you to review.
var janesAccount = Account(name: "Jane's Account", balance:1500.00, locked: false)
do {
  try atm.dispenseFunds(360.00, account: &janesAccount)
} catch let error {
  print(error)
}

atm.log

var margretsAccount = Account(name: "Margret's Account", balance: 50.00, locked: false)
do {
  try atm.dispenseFunds(80.00, account: &margretsAccount)
} catch let error {
  print(error)
}

atm.log

//: Notice that no matter when the `dispenseFunds(amount:account)` exits, the customer's card is always returned.

//: ### Pattern Matching

let names = ["Charlie", "Chris", "Mic", "John", "Craig", "Felipe"]

//: Implement a "for ... in" block that creates an array of names that start with "C"




//: Display the result




//: Use the following array for the next example.

let authors = [
  Author(name: "Chris Wagner", status: .Late(daysLate: 5)),
  Author(name: "Charlie Fulton", status: .Late(daysLate: 10)),
  Author(name: "Evan Dekhayser", status: .OnTime)
]

let authorStatuses = authors.map { $0.status }

//: Iterate over `authorStatuses` where the case is .Late(Int) and sum up the total number of days late



//: Use "if case" matching to slap all authors that are running late.




//: ### OptionSetType Example

struct RectangleBorderOptions: OptionSetType {
  let rawValue: Int
  
  init(rawValue: Int) { self.rawValue = rawValue }
  
  static let Top = RectangleBorderOptions(rawValue: 0)
  static let Right = RectangleBorderOptions(rawValue: 1)
  static let Bottom = RectangleBorderOptions(rawValue: 2)
  static let Left = RectangleBorderOptions(rawValue: 3)
  static let All: RectangleBorderOptions = [Top, Right, Bottom, Left]
}

