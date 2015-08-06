# Chapter 2: Introducing App Search

One frustration for many iOS developers is that Apple gets to have all of the fun. They're the ones who get deep integrations with iOS that every developer yearns for. The good news is that after Apple has vetted out a feature for themselves they often bring it to the masses; like with App Extensions in iOS 8.

Currently, when a user wants to get to content in your app they have to go through a series of steps. They flip through pages on their home screen to find your app, open it, and search what they're looking for. A savvy user may launch your app by using Siri or searching for it in Spotlight, but still they are left searching for their content once the app is launched. Meanwhile, Apple gets to make things like contacts, notes, messages, email, apps and other things directly searchable within Spotlight. The user simply taps on the search result and are taken straight to the content—no fair!

New with iOS 9 Apple brings the ability for third party developers to make *their* content searchable through Spotlight! This also means that users can search within your app using Siri! Not only do you get to make your content searchable with Siri, you also get to make Siri more aware of your content. By saying "Remind me about *this* when I get home." a user can create a reminder that links to the record they are viewing in *your* app! When the reminder pops up, they can go directly back to what they were doing. Now you don't need to leave 20 tabs open in Safari in hopes that you get back to them later. Create a reminder, close the tab, and get on with your life! [TODO: Fact check this with GM on a device]

## Trifecta of App Search

Before diving into a sample project and code you first need to be aware that there are three aspects of App Search. Each are broken into separate APIs that achieve distinct results, but also work in concert with each other.

### NSUserActivity

The first aspect is `NSUserActivity`. Apple has taken a clever yet brilliant approach to App Search by tying it into `NSUserActivity` that used to enable Handoff in iOS 8.

If you are not aware, Handoff allows a user to continue an activity on another device. As an example, consider that you're reading an email on your phone when you sit down at your Mac. A special Mail icon on your Mac's Dock appears that allows you to launch Mail and resume reading the message. This is powered by `NSUserActivity` who provides the OS with information necessary to resume the task on another device. The communication between devices occurs over a combination of iCloud, Bluetooth and WiFi.

The `NSUserActivity` class was given a few new properties to enable App Search that you will learn about in this chapter. Apple has determined through usage metrics that users want to get back to content they've previously viewed. If a task can be represented as an `NSUserActivity` to be handed off, it might make sense for that task to be searchable and continued on the *same* device. This chapter will not cover Handoff specifically, but you will learn how to make content searchable once it has been viewed.

### CoreSpotlight

The second aspect is Core Spotlight, while it is nice to allow users to search for content they've previously accessed, it may make sense for your app to make *all* content searchable. CoreSpotlight is what the stock iOS apps like Mail and Notes use to index their content. Through this API you are given fine grained control of what, when and how content is indexed. You can also update and remove items from the search index. CoreSpotlight is the best way to provide full search capabilities of your app's content, including content that is private to the user. In this chapter you will be learning how to use the new CoreSpotlight APIs to index all of the content of an app.

### Web Markup

The third aspect is Web Markup which is tailored towards apps that mirror their public content from a web site. A good example of this would be Amazon where you can search of any of the products that they sell, or even RayWenderlich.com. This chapter will not touch on Web Markup, but will find that information in Chapter 3, "Your App On The Web".

## Sample Project

For this chapter you will be working with a sample app that simulates what a company address book might look like. Rather than every employee being added to your phones address book, the app provides a directory of your colleagues. To keep things simple, the app runs off of set of data that resides in the app bundle as a folder of avatar images and a JSON file containing all of the employee information. In the real-world you would prefer to have a networking component that downloads a bundle of data like this or one that accesses a true web-service.

### New Employee Orientation

Start by opening the Starter Project, but before diving into any code, build and run.

![iphone](/images/app-screen-1.png)

You will immediately see a list of all employees in the company, it's a small company of around 25 individuals. Select **Brent Reid** from the list.

![iphone](/images/app-screen-2.png)

This view shows all of the employee's details and also a related list of employees who are in the same department. That is the extent of the app, very simple. What might make this app infinitely better is searching, as it stands you can't even search while you're in the app. You won't be adding search in the app, but you will be adding the ability to search from Spotlight!

#### Code Walk

Take a moment to familiarize yourself with the codebase of the project. There are two targets, Colleagues which is the app itself, and EmployeeKit which is a framework to help you in interacting with the employee database. Open **Employee.swift**, this is the model for an employee, it has all of the properties you might expect having just viewed Brent Reid's record. Employee instances are initialized using a JSON model.

Moving on, open **EmployeeService.swift**. At the top of the file you will notice an extension declaration. You will be filling out the implementation of those two methods marked with "TODO" comments later. More importantly for now, this service provides two public APIs, `employeeWithObjectId(` and `fetchEmployees()`. Both methods are commented, the first provides an Employee given its `objectId` and the second results all employee records from the database.

The rest of the code in the EmployeeKit target is unimportant to the chapter's topic so there's no need to be familiar with them to continue. Jump to the Colleagues folder which contains the code for the app itself.

Open **AppDelegate.swift**, notice that there is only one method in here `application(_:didFinishLaunchingWithOptions:launchOptions)`. The implementation switches on `Setting.searchIndexingPreference` which is in place to allow the user to change the behavior of search indexing. Notice that depending on the setting's value, a different service method is called. If you recall, these are the service methods that had "TODO" comments for you to implement later. No need to worry about that just yet, but you should be aware of this setting. The setting can be changed in the Settings iOS App under "Colleagues".

That wraps up what you should be aware of for now, the rest of the code is view controller logic which you will be modifying, but it's unnecessary to fully comprehend what is going on there in order to achieve the goal of enabling App Search.

###
