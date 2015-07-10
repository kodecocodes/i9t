# Chapter 5: What's New in Storyboards

Storyboards were first introduced back in iOS 5. For the first time view controller hierarchy was presented visually, making the flow of larger apps easier to navigate. 

Apple have continued to improve storyboards - iOS 6 brought in Unwind Segues for reverse navigation. When iOS 8 introduced the universal storyboard for both iPhone and iPad, we could design once and use anywhere. Live rendering in the storyboard let us preview and even fine-tune views designed in code.

However, the problem of huge monolithic storyboards continued until iOS 9. Now Storyboard References remove one of the main reasons not to use storyboards.

In this chapter you'll learn about the new features in storyboards:

* Storyboard References
* Views in the Scene Dock
* Multiple buttons on a Navigation Bar

and also update a cool app to help you with all those moments in life that need lists.  

To get the most out of this chapter, you will need basic storyboard and table view knowledge. Everything you need to know is in the Ray Wenderlich Storyboards Tutorial in Swift at [http://www.raywenderlich.com/81879/storyboards-tutorial-swift-part-1](http://www.raywenderlich.com/81879/storyboards-tutorial-swift-part-1)

*replace with page break*

*replace with page break*

*replace with page break (screen)*

*replace with page break (screen)*


## Getting Started

Whether you're going on a camping trip, moving house or surviving a zombie apocalypse, you'll need to be Prepped. Prepped is the app that will help you survive.

![iPhone](images/Prepped.png)


Download the starter app and take some time going through it to see how it works.

The starter app consists of lists of to-do items. The first scene is a list of check lists. You can add a check list by tapping the **+** at the top right of the screen. When you tap a check list, you get the to-do items in that list that you can check as done or not done.

Sample data is in SampleData.swift. The data isn't saved between app sessions.

When you've finished the final app, you will be able to add to-do items to a list along with notes, and also make diary entries. Along the way you'll discover What's New in Storyboards.

*replace with page break (screen)*

*replace with page break (screen)*

*replace with page break (screen)*

*replace with page break (screen)*

### Overview of Storyboards, Scenes and Segues

Storyboards are a visual representation of the flow of view controllers in your app. Take a look at **Main.storyboard** in the starter app:

![bordered width=90%](images/InitialStoryboard.png)

The flow is immediately obvious, even if you don't know exactly what each view controller does. Each one of those view controllers are called **scenes**. Transitions from one scene to the next are indicated in the storyboard by arrows. These transitions are called **segues**.

## Storyboard References

If you've used storyboards at all, you will know how easy it is to design your scenes. But I've heard rumors that some people don't use them. Perhaps because they share development within a team, or because storyboards can become spaghetti-like in a large app. With storyboard references those reasons not to use them is gone.

References allow you to divide up storyboards into sub-storyboards. The main storyboard contains references to these sub-storyboards. Storyboard references can refer to storyboards within the same bundle or even different bundles. 

Separating into multiple storyboards means that your storyboards can be smaller and easier to work with. It also means that other people on your team can be working on their own storyboards which can be integrated into the app later.

**Prepped** is an app in its early stages. But looking at **Main.storyboard**, you can see that even this storyboard can be separated out into logical chunks.

Zoom out on the storyboard, so that you can see all the eight scenes. You can use the new shortcut keys listed here:

![height=20%](images/ShortcutKeys.png)

or right click on a blank area in the storyboard and choose your zoom level.

Highlight all the scenes except for the Tab Bar Controller on the left hand side by clicking and dragging over them.

![bordered height=35%](images/HighlightStoryboard.png)

Click **Editor -> Refactor to Storyboard** and enter the name of the new storyboard **CheckLists.storyboard**. Click **Save**. 

*replace with page break (screen)*

*replace with page break (screen)*

Xcode will now:

* Split out the selected scenes to the new storyboard
* Assign a default storyboard name to the initial scene (unless you have given it one)
* Create a storyboard reference in the original storyboard for both that initial scene and all scenes that have a Storyboard ID
* Keep segues to the initial scene in the new storyboard as segues to the storyboard reference
* Open the new storyboard

You may have to zoom out and back in again to reposition the new storyboard in the center. This is what the new storyboard will look like:

![bordered height=40%](images/Refactored.png)

The arrangement of the scenes complete with segues is exactly as in the original storyboard.

*replace with page break (screen)*

*replace with page break (screen)*

*replace with page break (screen)*

*replace with page break (screen)*

Open **Main.storyboard**.

![bordered width=95%](images/AfterRefactor.png)

Here you will find the Tab Bar Controller with a segue to the storyboard reference which points to the navigation controller in **CheckLists.storyboard** and also two storyboard references of scenes that had been given Storyboard IDs.

Delete the references to **ItemNavigationController** and **ItemDetailViewController** as they will not be needed.

You'll now change the remaining reference so that it loads the initial scene in the CheckLists storyboard instead of a named scene.

Select the storyboard reference with a name something like **UIViewController-gtY-c7-gYu**. In the **Attributes Inspector** remove the **Referenced ID**. The reference now points to whatever the Inital View Controller is in CheckLists.storyboard. 

![bordered width=40%](images/StoryboardReferenceID.png)

> **Note**: The Initial View Controller in a storyboard is the one with the arrow pointing to it from the left. You can also access storyboards in other bundles here.

In **CheckLists.storyboard**, select the **CheckListsNavigationController** scene and in the **Identity Inspector** remove the Storyboard ID.

![bordered width=40%](images/NavigationStoryboardID.png)

In the **Attributes Inspector** check **Is Initial View Controller** to indicate that this is the scene that should first be loaded when the storyboard loads.

![bordered width=40%](images/InitialViewController.png)

Build and run the app. Even though you have done this refactoring, nothing should have changed when you run the app.


### Storyboards within a team

In the past it has been difficult to design and share storyboards among team members. In fact this is probably the major reason people have not been using storyboards. 

Imagine that you are writing your new app Prepped together with a friend, whose task it is to create the Diary Entries tab. He's finished it now, so you need to add it to your storyboard hierarchy.

Click on **File Menu -> Add File to Prepped**. Navigate to the Prepped folder, and you will see a folder called **Diary**. Click on the folder, and ensure that **Copy items if needed** is checked, and that **Added folders** is set to **Create groups**. Ensure that **Add to targets** is ticked for Prepped. Click **Add** to add the folder and its contents to the project.

In **Main.storyboard** drag a Storyboard Reference onto the storyboard (onto empty space, not onto a scene).

![bordered height=25%](images/StoryboardReference.png)

Ctrl-drag from the Tab Bar Controller scene to the Storyboard Reference 

![bordered height=30%](images/ConnectStoryboardRef.png)

and choose **view controllers** in the Relationship Segue section.

![bordered height=20%](images/SegueMenuStoryboardRef.png)

Select the Storyboard Reference. In the **Attributes Inspector** change **Storyboard** to **Diary**.

![bordered height=15%](images/DiaryStoryboardRef.png)

Run the app, and you should now have two tabs - one for Check Lists and one for Diary. 

Your tabs may be in the wrong sequence. If so, in **Main.storyboard** rearrange the tabs. Currently both the tabs in the Tab Bar Controller are called **Item**. The correct title is loaded during runtime from the CheckLists and Diary storyboards. You can change the titles in Main.storyboard for your reference, but it won't make any difference at runtime.

![bordered height=30%](images/TabBarControllerItems.png)

### Focus on a Storyboard

For the next few sections, you'll be working on the Check Lists Items. So that you don't have to keep tapping through extra scenes, you can isolate the Item scenes into their own storyboard and change the initial storyboard just for the period where you are working on the Items. 

In **CheckLists.storyboard** highlight the **Item View Controller**, the **Item Detail Navigation Controller** and the **Item Detail View Controller** scenes. 

![bordered height=34%](images/ItemsRefactored.png)

Chose **Editor menu -> Refactor to Storyboard** and call the new storyboard **Items.storyboard**. 

Just as you did for the CheckLists storyboard, in **Items.storyboard** select the **Item View Controller** scene and in the **Attributes Inspector** check **Is Initial View Controller**. The Item View Controller should now have an arrow on its left indicating that it is the first scene in the storyboard.

Run the application again to ensure that it still works as expected and nothing has changed yet.

Click on the project name **Prepped** at the top of the **Project Navigator**, then click on the Prepped target and choose the **General** tab.

Change **Main Interface** to **Items.storyboard**. 

![bordered height=20%](images/ProjectSettings1.png)

Run the app and see that the Items scene is loaded first. Note that the Navigation Bar and Tab Bar are missing, but this is only a temporary situation while you work on the sub-storyboard.

![iPhone bordered](images/Items.png)

> **Note:** Depending on what initial properties are necessary for the scene to run correctly, changing the initial storyboard temporarily may not work for you in all cases, but here the Item view controller has been set up to load initial sample data. 

*replace with page break (screen)*

*replace with page break (screen)*

## Views in the Scene Dock

You have always been able to add views to the scene dock, but in Xcode 7 you can now design these attached views within the storyboard.

You will now change the color of a selected cell with no code at all.

In **Items.storyboard**, drag a UIView onto the **Item View Controller** scene's Scene Dock. This will create a new view just above the Scene Dock, which you can format just as you would any other view.

![bordered height=15%](images/DragViewOntoSceneDock.png)

![bordered height=20%](images/ViewInSceneDock.png)

Select the view and in the **Attributes Inspector** change the background color of the view to **RGB(239,249,240)**.

You can resize the view from the top, left and right edges to be quite small, as the view will be stretched when it is used in the cell.

Select **ItemTableViewCell** in the Document Outline, and in the **Connections Inspector**, drag from **selectedBackgroundView** to the new green view.

![bordered height=25%](images/ConnectSelectedView.png)

Run the application, and when you tap a row, that row will be colored.

![bordered iPhone](images/SelectedView.png)

Easy!

> **Note**: This coloring will only work when you don't enable multi-selection. The green view is a single view for the entire table view that is applied to one cell at a time.

*replace with page break (screen)*

## View that shows conditionally

Often in your apps you will have a view in the view hierarchy that only shows conditionally. The solution to this used to be to make the view hidden while not in use, but formatting that view among all the other views was always rather difficult. One advantage of having a view in the scene dock is being able to format the view visually with no interference from other views and add it to the view heirarchy in code when the view is needed. 

In your app the check list items have notes accompanying them in the sample data. You will now create a view to display the note, and as you tap the row, the row will expand to display the note. If you tap the row again or tap a different row, the selected row will contract and the note view will be removed from that row.

Drag a new View onto the Scene Dock next to the green selection view.

Drag a Label onto the new view and in the **Attributes Inspector** change the label to say **Notes:**. You may have to resize the Label so that the text fits.

![bordered height=30%](images/NotesLabel.png)

Drag a Text View onto the new view and resize and rearrange the views to fit. Remove the default Lorem ipsum text from the text view.

![bordered width=80%](images/NotesTextView.png)

Generally when you are referring to a cell in a table view, unless it is a static table view, there are multiple cell instances at a time, so you cannot connect them to an outlet in the table view controller. However, because there will only be one Notes view instance on the screen at any one time, this view can be connected to an outlet.  

In the **Assistant Editor**, line up **Items.storyboard** and **ItemViewController.swift**. You may have to close the Document Outline using the icon beneath the storyboard to get enough space.

![bordered height=6%](images/DocumentOutline.png)

Control-drag from the new view to **ItemViewController.swift** to create an outlet for the view. Ensure that you are dragging from the view background, not from the text view or label:

![bordered width=80%](images/CreateOutlet.png)

Name the outlet **notesView** and click **Connect**. The outlet will appear as a property in ItemViewController.swift.

Control-drag from the text view to **ItemViewController.swift** to create an outlet. Name the outlet **notesTextView** and click **Connect**. 

*replace with page break (screen)*

*replace with page break (screen)*

You will now write the code for the cell to expand when it is touched.

This is what you will need to do:

1. Create a property to hold the selected indexPath of the cell.
2. Add `tableView(_:didSelectRowAtIndexPath:)` to update the selected indexPath property when the user taps the row.
3. Add `tableView(_:heightForRowAtIndexPath:)` to change the height of the selected cell.

In **ItemViewController.swift** add the property to hold the selected indexPath of the cell:

    var selectedIndexPath:NSIndexPath?

In the currently empty Table View delegate extension for CheckListItemViewController, add `tableView(_:didSelectRowAtIndexPath:)`:

```swift
override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  tableView.beginUpdates()
  if selectedIndexPath == indexPath {
    selectedIndexPath = nil
    //remove notes view from cell
  } else {
    selectedIndexPath = indexPath
    //add notes view to cell
  }
  tableView.endUpdates()
}
```

This method sets `selectedIndexPath` to the tapped cell's `NSIndexPath`. If the user taps an already selected cell, `selectedIndexPath` is set to nil.

`tableView.beginUpdates()` and `tableView.endUpdates()` ensures that the animation of the cells changing size is smooth.

In the same delegate extension, add `tableView(_:heightForRowAtIndexPath:)`:

```swift
override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
  if selectedIndexPath == indexPath {
    return cellHeight + cellPadding + notesView.bounds.height
  } else {
    return cellHeight
  }
}
```

When the table is loaded or refreshed, the height of the cell being displayed is determined by whether its indexPath is equal to the currently selected index path. If the cell is selected, the height will expand to include the notes view's height.

Build and run the application and tap each cell to see it expand. Tap it again to see it contract back to its usual size.

![iPhone](images/ExpandedNotes1.png)

>**Note:** Even though you have not yet added the notes view to the table view hierarchy, the height of the notes view is what you defined in your storyboard. This is because the notes view instance is created at the same time as the storyboard scene is loaded and is strongly retained by the scene. 

Now you will need to add the notes view to the cell view hierarchy when it is selected and remove it when it is deselected.

In `tableView(_:didSelectRowAtIndexPath:)` change the commented 

    //remove notes view from cell 
to 

    notesView.removeFromSuperview()

and change:

    //add notes view to cell

to

```swift
notesTextView.text = itemArray[indexPath.row].notes
if let cell = tableView.cellForRowAtIndexPath(indexPath) {
  notesView.frame.origin.x = cellPadding
  notesView.frame.origin.y = cellHeight
  cell.contentView.addSubview(notesView)
}
```


In Project Settings, change **Main Interface** back to **Main.storyboard**. 

![bordered height=20%](images/ProjectSettings2.png)

Build and run the application. You will see the notes for each item appear when you tap the cell.

![iPhone](images/ExpandedNotes2.png)

>**Note:** being able to create a view in the Scene Dock is useful, but if the view is one that is reused throughout the app, then you would probably use a XIB and instantiate it in code.

## Buttons on the right

The next feature you will add to your app is the ability to add and delete check list items. 

You will need two new buttons on the Navigation Bar, one for Add and one for Edit. Apps often achieve this by having an Edit button on the left of the bar and and an Add button on the right of the bar. However, even though it doesn't show up in Storyboard view, at run time the left button on the Check List Items bar is needed for the Back to Lists button.

![bordered height=6%](images/NavigationBar1.png)

A useful new feature in storyboards is the ability to add multiple buttons directly to a navigation bar. Previously you had to create a view that held multiple buttons and add that view to the bar.

In **Items.storyboard**, drag a Bar Button Item onto the right hand side of the navigation bar.

The Document Outline will now show a group for Left Bar Button Items and a group for Right Bar Button Items.

![bordered height=20%](images/CheckListItems.png)

Drag a second Bar Button Item onto the right side of the Navigation Bar. In the **Attributes Inspector** change the first button's **System Item** to **Add** and leave the second button's **System Item** set to **Custom**. Change the second button's Title property to **Edit**. (You will later be changing the title of this button in code, so it can't be a System Item.)

![bordered height=20%](images/CheckListItemButtons.png)

Now you will connect the buttons to the currently unconnected Item Detail Navigation Controller in the storyboard.

Ctrl-drag from the Add button to the Item Detail Navigation Controller scene and choose **present modally** from the popup menu. When the user taps the Add button the Item Detail scene will be presented.

Create the unwind segues back from the Item Detail View Controller scene. Select **Item Detail View Controller** in the Document Outline. Ctrl-drag from the **Cancel** button to **Exit** on the Scene Dock and choose **cancelToItemViewController:** from the popup menu. Ctrl-drag from the Save button to Exit on the Scene Dock and choose **saveToItemViewController:** from the popup menu. (These unwind methods have been created for you in ItemViewController.swift.)

Build and run the application, choose a List and try out adding items with notes to the List. These will not be saved permanently - the sample data is currently held in arrays which exist only for the duration of the app.

Now you will implement the code for the Edit button. This involves:

1. Adding the @IBAction button to be called from the Edit button.
2. Adding the data source method `tableView(_:canEditRowAtIndexPath:)` to allow editing on the cell.
3. Adding the data source method ` tableView(_:commitEditingStyle:)`. This is where you will define what happens when the cell is deleted.

Firstly, create the button's method in **ItemViewController**:

```swift
@IBAction func btnEdit(button:UIBarButtonItem) {
  if self.editing {
    button.title = "Edit"
    super.setEditing(false, animated: true)
  } else {
    button.title = "Done"
    super.setEditing(true, animated: true)
  }
}
```

Here you change the title of the button when you are in editing mode, and call the table view controller's super class methods for editing.

In **Items.storyboard**, connect the Edit button to the function. In the Document Outline, ctrl-drag from Edit Button to Item View Controller and choose **btnEdit:** from the popup menu.

![bordered height=30%](images/EditButtonAction.png)


Back in **ItemViewController.swift** in the extension for Table View Data Source methods, create the data source method to enable editing on cells:

```swift
override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  return true
}
```

Create the data source method which specifies what happens when you delete a cell.

```swift
override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
    selectedIndexPath = nil
    notesView.removeFromSuperview()
    itemArray.removeAtIndex(indexPath.row)
    checkListItemData[checkListIndex].removeAtIndex(indexPath.row)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  }
}
```

When the cell is deleted, the selected index path is set to nil, the notesView is removed from its superview (if the notesView currently doesn't have a superview, nothing will happen), remove the item from both the local view controller's copy of array and from the app-wide array. Finally delete the row from the table view.


Build and run the application, choose a Check List, tap the Edit button and delete an item from the check list. Tap the Done button to complete Editing.

Congratulations! You are now prepared to survive the apocalypse, and as an added bonus, you also know what's new in storyboarding.


## Where to go to from here


