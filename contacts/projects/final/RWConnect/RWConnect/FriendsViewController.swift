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
import Contacts
import ContactsUI

class FriendsViewController: UITableViewController {
	
	var friendsList = Friend.defaultContacts()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.titleView = UIImageView(image: UIImage(named: "RWConnectTitle")!)
	}

    @IBAction func addFriends(sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    func presentPermissionErrorAlert() {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Could Not Save Contact", message: "How am I supposed to add the contact if you didn't give me permission?", preferredStyle: .Alert)
            let openSettingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { _ in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            })
            let dismissAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(openSettingsAction)
            alert.addAction(dismissAction)
            
        }
    }
    
    func saveFriendToContacts(friend: Friend) {
        //1
        let contactFormatter = CNContactFormatter()
        //2
        let contactName = contactFormatter.stringFromContact(friend.contactValue)!
        //3
        let predicateForMatchingName = CNContact.predicateForContactsMatchingName(contactName)
        //4
        let matchingContacts = try! CNContactStore().unifiedContactsMatchingPredicate(predicateForMatchingName, keysToFetch: [])
        guard matchingContacts.isEmpty else {
            dispatch_async(dispatch_get_main_queue()){
                let alert = UIAlertController(title:"Contact Already Exists", message:nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            return
        }
        
        //1
        let contact = friend.contactValue.mutableCopy() as! CNMutableContact
        //2
        let saveRequest = CNSaveRequest()
        //3
        saveRequest.addContact(contact, toContainerWithIdentifier: nil)
        do {
            //4
            let contactStore = CNContactStore()
            try contactStore.executeSaveRequest(saveRequest)
            // Show success alert
            dispatch_async(dispatch_get_main_queue()){
                let successAlert = UIAlertController(title: "Contacts Saved", message: nil, preferredStyle: .Alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(successAlert, animated: true, completion: nil)
            }
        } catch {
            // Show failure alert
            dispatch_async(dispatch_get_main_queue()){
                let failureAlert = UIAlertController(title: "Could Not Save Contact", message: "An unknown error occurred", preferredStyle: .Alert)
                failureAlert.addAction(UIAlertAction(title:"OK", style: .Cancel, handler: nil))
                self.presentViewController(failureAlert, animated: true, completion: nil)
            }
        }
        
    }
}

//MARK: UITableViewDataSource
extension FriendsViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath:indexPath)
        
        let friend = friendsList[indexPath.row]
        cell.textLabel?.text = friend.firstName + " " + friend.lastName
        cell.detailTextLabel?.text = friend.workEmail
        cell.imageView?.image = friend.profilePicture
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
}

//MARK: UITableViewDelegate
extension FriendsViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //1
        let friend = friendsList[indexPath.row]
        let contact = friend.contactValue
        //2
        let contactViewController = CNContactViewController(forUnknownContact: contact)
		contactViewController.navigationItem.title = "Profile"
		contactViewController.hidesBottomBarWhenPushed = true
        //3
        contactViewController.allowsEditing = false
        contactViewController.allowsActions = false
        //4
        navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let createContact = UITableViewRowAction(style: .Normal, title: "Create Contact") { rowAction, indexPath in
            tableView.setEditing(false, animated: true)
            let contactStore = CNContactStore()
            contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { userGrantedAccess, _ in
                guard userGrantedAccess else {
                    self.presentPermissionErrorAlert()
                    return
                }
                let friend = self.friendsList[indexPath.row]
                self.saveFriendToContacts(friend)
            })
        }
        createContact.backgroundColor = BlueColor
        return [createContact]
    }
}

extension FriendsViewController : CNContactPickerDelegate {
    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {
        let newFriends = contacts.map { Friend(contact:$0) }
        for friend in newFriends {
            if !friendsList.contains(friend) {
                friendsList.append(friend)
            }
        }
        tableView.reloadData()
    }
}

