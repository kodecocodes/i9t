import Foundation

public struct Account {
  public var name: String
  public var balance: Float
  public var locked: Bool = false
  
  public init(name: String, balance: Float, locked: Bool) {
    self.name = name
    self.balance = balance
    self.locked = locked
  }
}

public enum ATMError: ErrorType {
  case InsufficientFunds
  case AccountLocked
}

public enum AuthorStatus {
  case OnTime
  case Late(daysLate: Int)
}

public struct Author {
  public let name: String
  public let status: AuthorStatus
  
  public init(name: String, status: AuthorStatus) {
    self.name = name
    self.status = status
  }
}