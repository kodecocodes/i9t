//
//  Friend.swift
//  RWConnect
//
//  Created by Evan Dekhayser on 6/27/15.
//  Copyright © 2015 Razeware, LLC. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

func ==(lhs: Friend, rhs: Friend) -> Bool{
	return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.workEmail == rhs.workEmail && lhs.profilePicture == rhs.profilePicture
}

struct Friend: Equatable{
	let firstName: String
	let lastName: String
	let workEmail: String
	let profilePicture: UIImage?
	
	init(firstName: String, lastName: String, workEmail: String, profilePicture: UIImage?){
		self.firstName = firstName
		self.lastName = lastName
		self.workEmail = workEmail
		self.profilePicture = profilePicture
	}
	
	static func defaultContacts() -> [Friend] {
		return [Friend(firstName: "Mic", lastName: "Pringle", workEmail: "mic@example.com", profilePicture: UIImage(named: "MicProfilePicture")), Friend(firstName: "Ray", lastName: "Wenderlich", workEmail: "ray@example.com", profilePicture: UIImage(named: "RayProfilePicture")), Friend(firstName: "Sam", lastName: "Davies", workEmail: "sam@example.com", profilePicture: UIImage(named: "SamProfilePicture")), Friend(firstName: "Greg", lastName: "Heo", workEmail: "greg@example.com", profilePicture: UIImage(named: "GregProfilePicture"))]
	}
}
