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

>Note: I recommend that you use the simulator instead of a real device for two reasons.

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

2. Import friends from their Contacts.

3. Save friends into their Contacts.

Let's get started!
