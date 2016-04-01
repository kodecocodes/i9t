/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation

// MARK: Indexing
extension EmployeeService {
  public func indexAllEmployees() {
    // TODO: Implement this
  }
  
  public func destroyEmployeeIndexing() {
    // TODO: Implement this
  }
}

public struct EmployeeService {
  
  public init() { }
  
  /** Look up an employee by its `objectId`
  - Parameter objectId: The `objectId` of the employee to look up
  - Returns: The employee or `nil` if one does not exist
  */
  public func employeeWithObjectId(objectId: String) -> Employee? {
    let employees = fetchEmployees()
    let filteredEmployees = employees.filter { $0.objectId == objectId }
    
    return filteredEmployees.first
  }
  
  /// Return an array of all employees in the database
  public func fetchEmployees() -> [Employee] {
    let jsonData = loadEmployeesJSONData()
    
    do {
      let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
      
      if let employeeDicts = jsonObject["employees"] as? [[NSObject: AnyObject]] {
        var employees = [Employee]()
        for dict in employeeDicts {
          do {
            let employee = try Employee(json: dict)
            employees.append(employee)
          } catch JSONDecodingError.MissingAttribute(let missingAttribute) {
            print("Unable to load employee, missing attribute: \(missingAttribute)")
          } catch {
            fatalError("Something's gone terribly wrong: \(error)")
          }
        }
        
        return employees
      } else {
        fatalError("Unable to load JSON data for employees")
      }
    } catch {
      fatalError("Error deserializing JSON data: \(error)")
    }
  }
  
  private func loadEmployeesJSONData() -> NSData {
    let jsonPath = FileHelper.employeesJsonFilePath
    return NSData(contentsOfFile: jsonPath)!
  }
}