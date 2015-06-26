A long time ago in an operating system far far away, developers used C APIs to access the user’s contacts. They dealt with the pain of ancient structs and Core Foundation types in an object-oriented world.

This nightmare wasn’t that long ago – even iOS 8 uses this dreaded Address Book framework!

In iOS 9, Apple deprecated the Address Book (hoorah!). In its stead, they introduced a new Contacts framework. Contacts is designed to be object-oriented and thread-safe, unlike its predecessor.

The new Contacts framework is very powerful, and opens up many possibilities for developers. In this tutorial, you will learn how to do all of the following:

1. Add, update and delete contacts
2. Search the user’s contacts using NSPredicate
3. Utilize the ContactsUI framework to display and select contacts.

Along the way, you will also learn the best practices for dealing with the user’s contacts and how best to take advantage of the Contacts framework.

#Getting Started#

In this chapter, you will work on RWConnect, a social network for iOS developers. The app has a friends list so you can keep in touch with all the great developers you know via email.

Open the starter project, named `RWConnect-Starter` and run it on the iPhone 6 Simulator.

>**Note**: I recommend that you use the simulator instead of a real device for two reasons.

>1. You will want to be able to reset the device in order to test the permissions, and I don't think you want to reset your personal iPhone, do you?

>2. Later on, you will want to drag a Vcard into the simulator to test one of the features you implement.

[TODO: image]

When the app runs, there is a table view with four friends listed. Each friend has a name, a picture, and an email.

By the time you are done with RWConnect, you will add a lot of new features so that this friends list becomes a lot more friendly. :]

Now that you've seen the app in action, it's time to look at the code behind it.

Open **Friend.swift**. In it is a struct named **Friend**, which will represent each friend in the app. Notice the `defaultContacts()` method in **Friend**: it returns the same contacts you see in the table.

Now, open **FriendsViewController.swift**. The `friendsList` property calls the `defaultContacts()` method of Friend to get the sample friends when the app launches.

The UITableViewDataSource methods in the table are relatively simple. The table has one section with a cell for each friend. Each cell shows a picture of a friend as well as all the friend's information.

How are you going to make this friends list better? You are going to allow the user to:

1. View their friends' information in a more familiar interface.

2. Import contacts into their friends list.

3. Save friends into their Contacts.

Let's get started!

#Displaying a Contact#

Open **Main.storyboard** and select the table view cell in the FriendsViewController. In the **Attributes Inspector**, open the dropdown menu next to **Accessory** and select **Disclosure Indicator**.

[TODO: image]

The table view cell now has an arror on the right, showing the user that selecting the cell shows more information.

[TODO: image]

Open **FriendsViewController.swift**. At the end of the file, extend FriendsViewController and override  `tableView(accessoryButtonTappedForRowWithIndexPath:)`:

```swift
extension FriendsViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    //Handle Cell Selection
  }
}
```

When the user taps on the table view cell, you want to display the selected friend's contact information. Before you can display the friend to the user, you need to convert the Friend instance into a CNContact.

In the Contacts framework, a contact is represented by a CNContact. CNContacts have many properties that defines who the contact is, such as `givenName`, `familyName`, `emailAddresses`, and `imageData`.

Go into **Friends.swift** and extend it with the following computed property:

```swift
extension Friend{
	var contactValue: CNMutableContact {
    //1
  	let contact = CNMutableContact()
    //2
  	contact.givenName = firstName
  	contact.familyName = lastName
    //3
  	contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: email)]
    //4
  	if let profilePicture = profilePicture{
  		let imageData = UIImageJPEGRepresentation(profilePicture, 1)
  		contact.imageData = imageData
  	}
  	return contact
	}
}
```

Let's explain this code line by line:

1. CNMutableContacts can be easily created by calling its designated initializer, which has no arguments.
2. The contact's properties can be assigned simply by setting it equal to a new value – in this case, with the Friend's members.
3. `emailAddresses` is an array of CNLabeledValues. This means that each email address also has a label to go with it. There are many labels that can be found in the Contacts documentation.
4. Finally, if the Friend has a profile picture, you set the contact's image data to the profile picture's JPEG representation.

> **Note**: CNMutableContact is the mutable counterpart to CNContact. While the properties of a CNContact are read-only, the properties of a CNMutableContact can be changed. For this reason, you will be using CNMutableContacts more often in this tutorial.

Now that you implemented this method, you can now convert any Friend to a CNMutableContact.

[TODO: image]

Switch over to **FriendsViewController.swift** and go to the empty implementation of `tableView(_: cellForRowAtIndexPath:)`. Replace the implementation with the following:

```swift
override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
  //1
	let friend = friendsList[indexPath.row]
	let contact = friend.contactValue()
  //2
	let contactViewController = CNContactViewController(forUnknownContact: contact)
  //3
	contactViewController.allowsEditing = false
	contactViewController.allowsActions = false
  //4
	contactViewController.edgesForExtendedLayout = .None
	navigationController?.pushViewController(contactViewController, animated: true)
}
```

Some of this code should look new to you, so let's break it into bite-sized pieces to make it easier to understand:

1. Use the index path of the accessory button's cell to get the friend that was selected, and convert it to a CNMutableContact.
2. Create a CNContactViewController. This view controller shows the contact's information to the user. You instantiate the view controller using its `forUnknownContact` initializer because the contact you are showing is not part of the user's contact store.
3. You set `allowsEditing` and `allowsActions` to `false` so that the user cannot do anything but view the contact information.
4. First, you set `edgesForExtendedLayout` to `false` so that the CNContactViewController shows below the navigation bar. Then, you push this view controller onto the navigation stack.

Build and run the app, and tap on one of the table view cells. The ContactsUI framework will display the friend's information as shown below:

[TODO: image]
