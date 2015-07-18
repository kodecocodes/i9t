//
//  EmployeeService.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation

public struct EmployeeService {
    
    public init() { }
    
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