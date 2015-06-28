//
//  FriendsViewController.swift
//  RWConnect
//
//  Created by Evan Dekhayser on 6/27/15.
//  Copyright © 2015 Razeware, LLC. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class FriendsViewController: UITableViewController {
	
	var friendsList = Friend.defaultContacts()
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return friendsList.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell")!
		
		let friend = friendsList[indexPath.row]
		cell.textLabel?.text = friend.firstName + " " + friend.lastName
		cell.detailTextLabel?.text = friend.workEmail
		cell.imageView?.image = friend.profilePicture
		
		return cell
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
	
}
