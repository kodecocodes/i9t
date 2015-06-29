//: [Previous](@previous)

import Foundation

//: ## Additional Things
//: The previous sections covered a number of new features in Swift 2.0, but there is even more. For the rest of this chapter you will be experimenting further with some of the previously mentioned features and more new ones. The examples will not be as concrete as the string validation problem, but hopefully still interesting!

//: ### Going further with Extensions
//: One other amazing thing that you can do with Extensions is provide functionality with generic type parameters. This means that you can provide a method on Arrays that contain a specific type. You can even do this with protocol extensions.


extension MutableCollectionType where Self.Index == Int {
    mutating func shuffleInPlace() {
        let c = self.count
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            swap(&self[i], &self[j])
        }
    }
}

var people = ["Chris", "Ray", "Sam", "Jake", "Charlie"]
people.shuffleInPlace()
var rules = people.reduce("We will take turns in the following order: ") { $0 + $1 + ", "}
rules.replaceRange(advance(rules.endIndex, -2)..<rules.endIndex, with: ".")

//: As of Beta 2 extending functionality to generic type parameters is only available to classes and protocols. You will need to create an intermediate protocol to achieve the same with structs.

//: ### Using `defer`
//: With the introduction of `guard` and `throws`, exiting scope early is now a "first-class" scenario in Swift 2.0. This means that you have to be careful to execute any necessary routines prior to an early exit from occurring. Thankfully Apple has provided `defer { ... }` to ensure that a block of code will always execute before the current scope is exited.

struct Account {
    var name: String
    var balance: Float
    var locked: Bool = false
}

enum ATMError: ErrorType {
    case InsufficientFunds
    case AccountLocked
}


//: Notice the `defer` block defined at the beginning of the `dispenseFunds(amount:account)` method
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

var atm = ATM()

//: Attempting to dispense funds from a locked account throws an `ATMError.AccountLocked`
var billsAccount = Account(name: "Bill's Account", balance: 500.00, locked: true)
do {
    try atm.dispenseFunds(200.00, account: &billsAccount)
} catch let error {
    print(error)
}


//: Good news, the defer block still ran even though the scope was exited early.
atm.log

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
//: Swift has always had amazing pattern matching capabilities, especially with cases in `switch` statements. Swift 2.0 continues to add to the languages abilities in this area. Here are a few brief examples.

//: "for ... in" Filtering provides the ability to iterate as you normally would using a for-in loop, except that you can provide a `where` statement so that only iterations whose `where` statement is true will be executed.

let names = ["Charlie", "Chris", "Mic", "John", "Craig", "Felipe"]


var namesThatStartWithC = [String]()

for cName in names where cName.hasPrefix("C") {
    namesThatStartWithC.append(cName)
}

namesThatStartWithC

//: You can also iterate over a collection of enums of the same type and filter out for a specific case.

enum AuthorStatus {
    case OnTime
    case Late(daysLate: Int)
}

struct Author {
    let name: String
    let status: AuthorStatus
}

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

totalDaysLate

//: "if case" matching allows you to write more terse conditions rather than using `switch` statements that require a `default` case.


let authorChris = Author(name: "Chris Wagner", status: .Late(daysLate: 5))

for author in authors {
    if case .Late(let daysLate) = author.status where daysLate > 2 {
        print("Ray slaps \(author.name) around a bit with a large trout.")
    }
}



//: [Next](@next)





