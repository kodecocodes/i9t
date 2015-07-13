# Chapter 11: Contacts

A long time ago in an operating system far far away, developers used a C API to access the user’s contacts. They dealt with the pain of ancient structs and Core Foundation types in an object-oriented world.

This nightmare wasn’t so long ago – even iOS 8 uses this dreaded Address Book framework!

In iOS 9, Apple deprecated the Address Book framework (hoorah!). In its stead, they introduced two new frameworks, `Contacts` and `ContactsUI`, with all the modern object-oriented goodness you'd expect.

The new frameworks are very powerful, and open up many possibilities for developers. In this tutorial, you will learn how to do all of the following:

1. Utilize the `ContactsUI` framework to display and select contacts.
2. Add contacts to the user's contact store.
3. Search the user’s contacts and filter using `NSPredicate`.

Along the way, you will also learn the best practices for dealing with the user’s contacts and how best to take advantage of the Contacts framework.

## Getting Started

In this chapter, you will create **RWConnect**, a social network for iOS developers. The app has a friends list so you can keep in touch with all the great developers you know via email.

>**Note**: I recommend that you use the simulator instead of a real device for this chapter. You will want to be able to reset the device in order to test the permissions, and I don't think you want to reset your personal iPhone, do you?

Open the starter project, named **RWConnect-Starter** and run it on the iPhone 6 Simulator.

![iphone](/images/1-StarterProjectScreenshot.png)

When the app runs, there is a table view with four friends listed. Each friend has a name, a picture, and an email.

By the time you are done with RWConnect, you will add a lot of new features so that this friends list becomes a lot more friendly. :]

Now that you've seen the app in action, it's time to look at the code behind it.

Open **Friend.swift**. In it is a struct named `Friend`, which will represent each friend in the app. Notice the `defaultContacts()` method in `Friend`: it returns the same contacts you see in the table.

Now, open **FriendsViewController.swift**. The `friendsList` property calls the `defaultContacts()` method of Friend to get the sample friends when the app launches.

The `UITableViewDataSource` methods in the view controller are relatively simple. The table has one section with a cell for each friend. Each cell shows a picture of a friend as well as all the friend's information.

Let's get started making this app better using the Contacts and ContactsUI frameworks. By the time you're done, the user will have a much more familiar experience using their contacts in your app.

## Displaying a Contact

Open **Main.storyboard** and select the table view cell in the **FriendsViewController**.

In the **Attributes Inspector**, open the dropdown menu next to **Accessory** and select **Disclosure Indicator**.

![bordered width=45%](/images/2-AccessoryChoice.png)

The table view cell now has an arrow on the right, showing the user that selecting the cell shows more information.

![bordered width=50%](/images/3-DisclosureIndicator.png)

### Convert Friends to CNContacts

Before you can display the friend to the user, you need to convert the `Friend` instance into a `CNContact`.

In the Contacts framework, a contact is represented by a `CNContact`. `CNContact` has many properties that defines who the contact is, such as `givenName`, `familyName`, `emailAddresses`, and `imageData`.

Open **Friend.swift** and extend it with the following computed property:

```swift
extension Friend {
  var contactValue: CNMutableContact {
    // 1
    let contact = CNMutableContact()
    // 2
    contact.givenName = firstName
    contact.familyName = lastName
    // 3
    contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: workEmail)]
    // 4
    if let profilePicture = profilePicture{
      let imageData = UIImageJPEGRepresentation(profilePicture, 1)
      contact.imageData = imageData
    }
    return contact
  }
}
```

Let's explain this code line by line:

1. A `CNMutableContact` object is created. The initializer takes no arguments.
2. The contact's properties are updated from the equivalent properties of the `Friend`.
3. `emailAddresses` is an array of `CNLabeledValue` objects. This means that each email address also has a label to go with it. There are many labels that can be found in the Contacts documentation, here you're using `CNLabelWork`.
4. Finally, if the `Friend` has a profile picture, you set the contact's image data to the profile picture's JPEG representation.

> **Note**: `CNMutableContact` is the mutable counterpart of `CNContact`. While the properties of a `CNContact` are read-only, the properties of a `CNMutableContact` can be changed. For this reason, you will be using `CNMutableContact` more often in this tutorial. It's important to note that `CNContact` is thread-safe (like most immutable objects), and `CNMutableContact` is not.

Now that you implemented this method, you can convert any `Friend` to a `CNMutableContact`.

[Editor: should a "Mission Accomplished" meme go here?]

### Showing the Contact Info

Switch over to **FriendsViewController.swift** and add the following extension to the bottom of the file:

```swift
//MARK: UITableViewDelegate
extension FriendsViewController{
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    // 1
    let friend = friendsList[indexPath.row]
    let contact = friend.contactValue
    // 2
    let contactViewController = CNContactViewController(forUnknownContact: contact)
    // 3
    contactViewController.allowsEditing = false
    contactViewController.allowsActions = false
    // 4
    navigationController?.pushViewController(contactViewController, animated: true)
  }
}
```

Some of this code should look new to you, so let's break it down to make it easier to understand:

1. Use the index path of the accessory button's cell to get the friend that was selected, and convert it to a `CNMutableContact`.
2. Create a `CNContactViewController`. This view controller is from the `ContactsUI` framework and is used for displaying a contact to the user. You instantiate the view controller using its `forUnknownContact` initializer because the contact you are showing is not part of the user's contact store.
3. You set `allowsEditing` and `allowsActions` to `false` so that the user can only view the contact information.
4. You push this view controller onto the navigation stack.

Build and run the app, and tap on one of the table view cells. The ContactsUI framework will display the friend's information as shown below:

![width=32%](/images/4-ContactViewController.png)

## Picking your Friends

What good is a friends list if you can't add more friends? Lucky for you, the `ContactsUI` framework has a class named `CNContactPickerViewController` that lets the user select contacts to use in the app!

Open **Main.storyboard** and go to **FriendsViewController**. In the **Object library**, drag a **Bar Button Item** to the right side of the navigation bar, as shown below:

![bordered width=50%](/images/5-BarButtonDrag.png)

In the **Attributes inspector**, select the dropdown menu next to **System Item** and select **Add**.

![bordered width=40%](/images/6-ButtonAdd.png)

Now, open **FriendsViewController.swift**, and create a new extension of `FriendsViewController` with the following code:

```swift
extension FriendsViewController: CNContactPickerDelegate {

}
```

In this extension, `FriendsViewController` conforms to `CNContactPickerDelegate`. This protocol lets you customize the behavior of a `CNContactPickerViewController`, which gives the user a simple means of choosing contacts to use in the app.

### Setting Up the User Interface

Show the **Assistant Editor** and change it to show **Automatic**, as shown below:

![bordered width=50%](/images/7-AssistantAutomatic.png)

In the storyboard, select the bar button item you just dragged in. **Control-Drag** into the **FriendsViewController** extension in the **Assistant editor** and create a new action named **addFriends** that takes a **UIBarButtonItem** as a parameter, as shown below:

![bordered width=40%](/images/8-addAction.png)

When the user presses the Add button, you want to present a **CNContactPickerViewController** so that the user can import their friends.

In `addFriends(_:)`, add the following lines of code:

```swift
let contactPicker = CNContactPickerViewController()
presentViewController(contactPicker, animated: true, completion: nil)
```

Build and run, and press the **Add** button in the navigation bar. The app now presents the **CNContactPickerViewController**.

![iphone](/images/9-PickerFirstView.png)

### Conforming to CNContactPickerDelegate

Currently, the user cannot import contacts. When the user selects a contact, the **CNContactPickerViewController** only shows more information about the contact.

In order to fix this problem, you need to take advantage of `CNContactPickerDelegate` methods.

The `CNContactPickerDelegate` protocol has five optional methods, but the one that you are most interested in is `contactPicker(_:didSelectContacts:)`. By implementing this method, the `CNContactPickerViewController` knows that you want to support multiple selection.

Add this delegate method to the `CNContactPickerDelegate` extension in **FriendsViewController.swift**:

```swift
func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {

}
```

Here are your two goals in this delegate method:

1. Create new `Friend` instances from `CNContact`s

2. Add these new `Friend` instances to your friends list

### Create a Friend from a CNContact

To easily create a `Friend` from a `CNContact`, create a new initializer for `Friend` that takes a `CNContact` as a parameter. Open **Friend.swift**, and add the following initializer in the extension:

```swift
init(contact: CNContact){
  firstName = contact.givenName
  lastName = contact.familyName
  workEmail = contact.emailAddresses.first!.value as! String
  if let imageData = contact.imageData{
    profilePicture = UIImage(data: imageData)
  } else {
    profilePicture = nil
  }
}
```

Notice how when you set `email`, you force unwrap the first email address found. Because you want RWConnect to keep in touch with your friends via email, your friends all need to have an email address. If doing this makes you twitchy, congratulations, but don't worry. You'll be fixing it later! :]

### Adding New Friends to the Friends List

Go back to **FriendsViewController.swift** and add the following lines to `contactPicker(_:didSelectContacts:)`:

```swift
let newFriends = contacts.map { Friend(contact: $0) }
for friend in newFriends {
  if !friendsList.contains(friend){
    friendsList.append(friend)
  }
}
tableView.reloadData()
```

This code transforms each contact that the picker returns into a Friend, and adds these Friends to the friends list. To show these changes, you tell the table view to reload.

Go back to `addFriends(_:)`. Before the call to `presentViewController(_:animated:completion:)`, add the following line:

```swift
contactPicker.delegate = self
```

Run the project again, and you are now able to select multiple contacts.

![iphone](/images/10-PickerMultiSelect.png)

When you press the **Done** button, you will have a few more friends than you did before!

![width=32%](/images/11-ContactsAddedFromPicker.png)

There is a chance that when you select certain contacts, the app will crash. This occurs when any of the contacts you selected do not have email addresses.

![width=30%](/images/What'sTheProblem.png)

In the `init(contact:)` initializer of `Friend`, you force-unwrap the first email from the contact's email addresses. When there is no email address, the app will crash.

Is there a way to make sure that the user can only select contacts with emails? You betcha!

Add the following line before `presentViewController(_:animated:completion:)`:

    contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0", argumentArray: nil)

The contact picker's `predicateForEnablingContacts` let you decide which contacts can be selected. In this case, you want the user to only select contacts with email addresses.

Run the app again. When you press the Add button, some of the contacts will be grayed out – this makes sure that the user only picks contacts with email addresses!

![iphone](/images/12-GrayedOutContacts.png)

## Save Friends to the User's Contacts

Now that the user can create friends from their contacts, it is only natural for them to want to create contacts from their friends.

When the user slides left on a table view cell, there will be a "Create Contact" action that will add the contact to the user's contact store. Let's get started!

### Adding a Row Action

Inside the table view delegate extension you added to **FriendsViewController.swift**, add the following code:

```swift
override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
  let createContact = UITableViewRowAction(style: .Normal, title: "Create Contact") { rowAction, indexPath in
    tableView.setEditing(false, animated: true)
    // TODO: Add the contact
  }
  createContact.backgroundColor = rwGreen
  return [createContact]
}
```

This code creates a single row action for the table view cells named "Create Contact" with a green background color.

Run the app, and slide left on a table view cell. The row action will appear as shown below:

![width=32%](/images/13-RowAction.png)

### Asking for Permission

Whenever you want to access or modify the user's contacts, it is important to make sure that you have the user's permission so you don't violate their privacy.

Not only is this part of being a good citizen in the iOS app development community, it is built into the Contacts framework. You cannot access the user's contacts without their permission.

> **Note**: When you used the `CNContactPickerViewController`, you did not have to ask the user for permission. `CNContactPickerViewController` is **out-of-process**, meaning that your app does not have access to the contacts shown in the picker. The benefit of this is that the user does not have to grant permission when this is shown. If the user selects contacts and presses **Done**, they implicitly give you permission to use the contacts.

To ask the user for permission, replace the `TODO` comment with the following code:

```swift
let contactStore = CNContactStore()
contactStore.requestAccessForEntityType(CNEntityType.Contacts) { userGrantedAccess, _ in

}
```

In this code, you create a `CNContactStore` instance. `CNContactStore` represents the user's address book, containing all of the user's contacts.

After you initialize the contact store, you call the instance method `requestAccessForEntityType(:completion:)`.

The completion handler takes a boolean value representing whether or not the user granted the app permission to access their contacts.

The first time you call this method, the system presents an alert asking the user for permission. Each subsequent time, the completion is called with the user's preference. The only way to change this is for the user to go into the Settings app to change their privacy setting.

First, let's handle the case when the user does **not** give you permission to access their contacts. The best practice is to let the user easily go to the app's setting.

Add the following method to the **FriendsViewController** extension:

```swift
func presentPermissionErrorAlert(){
  dispatch_async(dispatch_get_main_queue()){
    let alert = UIAlertController(title: "Could Not Save Contact", message: "How am I supposed to add the contact if you didn't give me permission?", preferredStyle: .Alert)

    let openSettingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { alert in
      UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    })
    let dismissAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(openSettingsAction)
    alert.addAction(dismissAction)
    self.presentViewController(alert, animated: true, completion: nil)
  }
}
```

This method presents an alert to the user saying that the app cannot save the contact. The first UIAlertAction opens the Settings app using the `UIApplicationOpenSettingsURLString` key.

> **Note**: This method is wrapped in a `dispatch_async` block to make sure that the code is executed on the main thread. UIKit is not thread safe, and to make sure the alert behaves properly, you have to make sure to present the alert on the main thread.

Go back into the `requestAccessForEntityType(:completion:)` completion handler and add the following code:

```swift
guard userGrantedAccess else {
  self.presentPermissionErrorAlert()
  return
}
```

This `guard` statement ensures that the user granted the app access to their contacts. If they did not, you show the user an alert using the code you just added.

Run the app in the simulator, and select the "Create Contact" row action for a contact.

![width=32%](/images/14-PermissionAlert.png)

The app presents an alert asking you to access your contacts. For this test run, select **Don't Allow**. When you press the alert action, the app presents your custom alert.

![width=32%](/images/15-YouRejectedMe.png)

Press **Settings** on your alert to see the Settings app open to your app's settings.

![width=32%](/images/16-AppSettingsPage.png)

### Saving Friends to Contacts

After the `guard` statement you added, you can be sure that you have permission to access and modify the user's contacts. The next thing to do is actually save the Friend to the user's contact store.

Add the following method to the **FriendsViewController** extension:

```swift
func saveFriendToContacts(friend: Friend){
  // 1
  let contact = friend.contactValue
  // 2
  let saveRequest = CNSaveRequest()
  // 3
  saveRequest.addContact(contact, toContainerWithIdentifier: nil)
  do{
    // 4
    let contactStore = CNContactStore()
    try contactStore.executeSaveRequest(saveRequest)
    // Show Success Alert
  } catch {
    // Show Failure Alert
  }
}
```

There's a lot of new stuff in this code, so let's break it apart:

1. Convert the Friend parameter into a `CNMutableContact`, so you can use it with the Contacts framework.
2. Create a new `CNSaveRequest`: this object lets you tell a `CNContactStore` the changes you want to make to the user's contacts, such as contacts to add, update, or delete.
3. Tell the `CNSaveRequest` that you want to add the friend to the user's contacts.
4. Try to execute a save request on a `CNContactStore`. This method either succeeds and execution continues, or an error is thrown. If no error is thrown, you assume that the save request succeeded.

> **Note**: The `catch` block does not create a custom alert for each possible error that could be thrown; instead, you use a generic error message. If you need to handle an individual error case, you must catch a CNErrorCode. These are not documented, but you can find their declaration in **CNError.h**.

Add the following code to show the alert at `// Show Success Alert`:

```swift
let successAlert = UIAlertController(title: "Contacts Saved", message: nil, preferredStyle: .Alert)
successAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))

dispatch_async(dispatch_get_main_queue()){
  self.presentViewController(successAlert, animated: true, completion: nil)
}
```

Also, add the following code at `// Show Failure Alert`:

```swift
let failureAlert = UIAlertController(title: "Could Not Save Contact", message: "An unknown error occurred.", preferredStyle: .Alert)
let dismissAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
failureAlert.addAction(dismissAction)
dispatch_async(dispatch_get_main_queue()){
  self.presentViewController(failureAlert, animated: true, completion: nil)
}
```

Go back to `tableView(_:editActionsForRowAtIndexPath:)` and add the following code under the `guard` block:

```swift
let friend = self.friendsList[indexPath.row]
self.saveFriendToContacts(friend)
```

Here, you pass the friend that the user wants to add into the method you created to save a friend.

Before you run the app, go into the simulator and select **iOS Simulator/Reset Content and Settings...**.

![bordered width=35%](/images/17-ResetTheSimulator.png)

Because you reset the simulator, the app will ask you for permission to access your contacts again. This is helpful to test all possible situations in your app.

Run the app, slide left on any contact, and choose **OK** to give the app permission to your contacts. When you do so, the app will show a confirmation that the contact was added:

![width=32%](/images/18-ContactSaved.png)

Still in the simulator, press **Command-Shift-H** and open the Contacts app (it might be hidden in a folder). Your friend is now added to your contacts!

![iphone](/images/19-RayIsInMyContacts.png)

### Check if Contact Exists

In your current implementation, you are able to add the same contact multiple times.

Before, you added the following two lines within `tableView(_:editActionsForRowAtIndexPath:)`:

```swift
let friend = self.friendsList[indexPath.row]
self.saveFriendToContacts(friend)
```

Replace these lines with the following code:

```swift
let friend = self.friendsList[indexPath.row]
let contactFormatter = CNContactFormatter()
let contactName = contactFormatter.stringFromContact(friend.contactValue)!
let predicateForMatchingName = CNContact.predicateForContactsMatchingName(contactName)
let matchingContacts = try! contactStore.unifiedContactsMatchingPredicate(predicateForMatchingName, keysToFetch: [])
if matchingContacts.isEmpty{
  self.saveFriendToContacts(friend)
} else {
  let alert = UIAlertController(title: "Contact Already Exists", message: nil, preferredStyle: .Alert)
  alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
  dispatch_async(dispatch_get_main_queue()){
    self.presentViewController(alert, animated: true, completion: nil)
  }
}
```

`CNContactFormatter` creates a name based on the information in a given contact. This name is generated using the contact's given and family name as well as any titles and suffixes (e.g. Jr.) associated with the contact.

`CNContactStore` allows you to query the user's contacts for those matching a predicate. In this case, you used `CNContact`'s `predicateForContactsMatchingName(_:)` method to create an `NSPredicate` that finds contacts with a name similar to the provided string. You only save the contact if there are no contacts matching the name, in order to prevent duplicates.

> **Note**: `unifiedContactsMatchingPredicate(_:keysToFetch:)` has a `keysToFetch` parameter that you ultimately ignore by passing in an empty array. However, if you were to try to access or modify the contacts that were fetched, it would throw an error because the keys were not fetched. If you wanted to access the fetched contacts' first names, for example, you would have to add `CNContactGivenNameKey` to `keysToFetch`.

Run the app, and try to add the same contact multiple times. Once the contact has been added, the app will not add the contact a second time.

Congratulations – You have now dramatically improved RWConnect and learned a ton about the new Contacts framework while doing so!

## Where to Go From Here

By this point, you now know just about everything you need to use the Contacts and ContactsUI frameworks in your own apps. However, there is still more to learn about the frameworks if you want to dig even deeper.

To learn more, be sure to visit the Contact framework guide (https://developer.apple.com/library/prerelease/ios/documentation/Contacts/Reference/Contacts_Framework/index.html#//apple_ref/doc/uid/TP40015328).

Also, check out WWDC 2015 Session 223: Introducing the Contacts Framework for iOS and OS X (https://developer.apple.com/videos/wwdc/2015/?id=223).
