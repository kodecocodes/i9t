import UIKit

//: # Chapter 1: Swift 2.0
//: ## Control Flow
//: **Note**: Be sure to turn on the Debug Area to see output by typing **CMD+SHIFT+Y** or pointing to **View/Debug Area/Show Debug Area**

//: Patron is defined for usage below.
struct Patron {
  let name: String
}

//: The Beer struct provides a very basic structure for tracking the amount of beer remaining in a container and also the Patron to whom the beer belongs.
struct Beer {
  var percentRemaining = 100
  var isEmpty: Bool { return percentRemaining <= 0 }
  var owner: Patron?
  
  //: `guard` is demonstrated below to show how it can be used for pre-condition checks
  mutating func sip() {
    guard percentRemaining > 0 else { // 1
      print("Your beer is empty, order another!")
      return
    }
    
    percentRemaining -= 10
    print("Mmmm \(percentRemaining)% left")
  }
}

//: Create a new beer value
var jamJarBeer = Beer()

//: `repeat` is used to demonstrate how it has been renamed from `do`
repeat {
  jamJarBeer.sip()
} while (!jamJarBeer.isEmpty) // always finish your beer!

//: A Bartender has a simple method to offer another beer to its owner, `guard` is used within the method to unwrap the owner if one exists.
struct Bartender {
  func offerAnotherToOwnerOfBeer(beer: Beer) {
    guard let owner = beer.owner else {
      print("Egads, another wounded soldier to attend to.")
      return
    }
    
    print("\(owner.name), would you care for another?") // 1
  }
}

let bartender = Bartender()
bartender.offerAnotherToOwnerOfBeer(jamJarBeer)


//: Move on to [Errors](@next)
