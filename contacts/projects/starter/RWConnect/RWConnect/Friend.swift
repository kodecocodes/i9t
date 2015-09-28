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

import UIKit

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
