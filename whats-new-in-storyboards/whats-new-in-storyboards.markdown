# Chapter 5: What's New in Storyboards

Storyboards were first introduced back with iOS 5. For the first time, they allowed the view controller hierarchy of an app to be mapped out visually, making the flow of larger apps easier to understand and navigate.

Apple have continued to improve storyboards over the years with unwind segues for reverse navigation, universal storyboards for both iPhone and iPad, and live rendering with which let us preview and configure views designed in code.

Xcode 7 brings its own set of great new additions to storyboards. This chapter will give you some experience using each one:

* Refactoring single storyboards into multiple storyboards and linking them together visually with _storyboard references_.
* Adding supplementary views to a view controller using the _scene dock_.
* Adding _multiple buttons_ to a navigation bar, right in a storyboard!

You'll do all of this whilst updating a cool app designed to help you with all those moments in life that need lists: whether it's grocery shopping, packing your luggage for vacation, or a survival checklist for the impending zombie apocalypse. :]  

To get the most out of this chapter, it'll help if you have some basic storyboard and table view knowledge. Check out our Storyboards Tutorial in Swift at <http://bit.ly/1SCaJuN> if you need to brush up.

## Getting started

Open up the starter project for this chapter and run it in the simulator. You'll see a list of checklists. Tap into one to see the items that are on the list, whether it's groceries, medical supplies, or equipment to fend off an undead hoard. You can tick off an item by tapping its checkbox.

![iphone bordered](images/Prepped.png)
[TODO: Update after design process]

Head back to Xcode to familiarize yourself with the code. **ChecklistsViewController.swift** contains the initial list of checklists, and **ChecklistDetailViewController.swift** displays the items within each list.

The user interface is currently all contained in **Main.storyboard**. There are also two scenes in there that aren't used in the starter app. You'll hook those up later in the tutorial so that you can add checklist items.

When you've finished the final app, you will be able to add checklist items to a list, add notes to an item, delete items, and also make diary entries to record your survival efforts.

## Storyboard references

If you've used storyboards on a large project or as part of a team with other developers, you'll know that they can sometimes become a bit unwieldy. Merge conflicts, spaghetti-like segue arrows, and navigating your way around a wall of view controllers is enough to make anybody question whether storyboards are worth the effort.

Whilst you've always been able to use multiple storyboards within an app, you've never been able to add segues between those storyboards in Interface Builder. Up until now, if you wanted to present a view controller from a different storyboard, you'd have to instantiate it and present it in code. But no longer!

Xcode 7 introduces **storyboard references**, which allow you to add references between storyboards right in Interface Builder. Storyboard references can refer to storyboards within the same bundle or even different bundles. They can point to specific view controllers, or just to the initial view controller within another storyboard.

> **Note**: Storyboard references are actually backwards compatible back to iOS 8. However when used on iOS 8, you can't use a storyboard reference with a relationship segue, or to point to storyboards in external bundles.

This makes it much easier to divide up storyboards into smaller storyboards, and alleviates many of the issues mentioned above without having to add any extra code. Having separate storyboards means that each one can be smaller and easier to work with. It also means that other people on your team can be working on their own storyboards independently, making it much easier to work together on a project that uses storyboards.

Enough theory - let's put it into practice!

## Creating your first storyboard reference

Whilst **Prepped** is currently only a small app in the early stages of development, there are already some logical places to divide up its main storyboard. Container view controllers are a good place to consider splitting out functionality into new storyboards. Prepped uses a tab bar controller, and in this case it makes sense to separate each tab's children into their own storyboards.

In the starter project, open **Main.storyboard** and zoom out so that you can see all six scenes. You can hold **Command** and press **+** to zoom in or **-** to zoom out, or right-click on a blank area in the storyboard and choose your zoom level.

Highlight all the scenes in the storyboard except for the tab bar controller on the left hand side by clicking and dragging over them:

![bordered width=90%](images/HighlightStoryboard.png)
[TODO: Update after design process]

Select **Editor\Refactor to Storyboard** and enter **Checklists.storyboard** as the name of the new storyboard. Set the **Group** to **Checklists**. Click **Save**.

As if by magic, Xcode will now:

1. Split out the selected scenes into a new storyboard.
2. Change the target of the tab bar controller's "view controllers" segue to a storyboard reference that points to the relevant scene in the new storyboard.
3. Take you to the new storyboard.

You may have to zoom out and reposition the new storyboard to see all the scenes. The arrangement of the scenes complete with segues is exactly as in the original storyboard. Here's what the new storyboard should look like:

![bordered width=90%](images/Refactored.png)
[TODO: Update after design process]

Lets check out what happened to the original storyboard. Open **Main.storyboard** and take a look.

![bordered width=95%](images/AfterRefactor.png)

The tab bar controller's "view controllers" segue now points to a the storyboard reference for the navigation controller in **Checklists.storyboard**. The storyboard reference uses the navigation controller's storyboard ID to refer to it.

There are two 'dangling' storyboard references to view controllers that had storyboard IDs set: `AddChecklistItemNavigationController` and `AddChecklistItemViewController`. You can select these and delete them, as they're not needed.

> **Note**: If your view controllers don't have a storyboard ID set in the storyboard, then Interface Builder will automatically generate an ID for them when you use the Refactor to Storyboard command. However, these IDs are pretty ugly; for example _UIViewController-gtY-c7-gYu_. Whilst you can change this later, we'd recommend that you explicitly set storyboard IDs yourself for any view controllers you want to use with references, as it makes things much easier to follow.

As well as referencing a specific view controller, storyboard references can also just refer to the initial scene in a storyboard. Let's change this one to do so.

Select the new storyboard reference (it'll be named **ChecklistsNavigationController**). In the **Attributes Inspector** remove the **Referenced ID**.

![bordered height=12%](images/StoryboardReferenceID.png)

&nbsp;

The reference will now point to whatever the initial view controller is in **Checklists.storyboard**.

![bordered height=5%](images/ChecklistsStoryboardRef.png)

> **Note**: The Initial View Controller in a storyboard is the one with the arrow pointing to it from the left.

Head over to **Checklists.storyboard** and select the **Checklists Navigation Controller** scene. In the **Attributes Inspector** check **Is Initial View Controller** to indicate that this is the scene that should be the entry point for the storyboard.

![bordered width=36%](images/NavigationStoryboardID.png)

Build and run. The app should perform just as it did when you started. The only difference is that things are better organized behind the scenes!

## Storyboards within a team

In the past it has been difficult to design and share storyboards amongst the members of a development team. In fact, this has been a big reason that some developers have still been avoiding storyboards: fear of the dreaded merge conflict.

Imagine that you are writing Prepped together with a fellow apocalypse survivor, whose task it is to create the diary entries functionality. She's finished building it using a separate storyboard, and now you need to add it to your own storyboard hierarchy... while you still can!

In the project navigator, select the top level **Prepped** group, just below the project itself. Click **File\Add Files to "Prepped"**. Navigate to the Prepped folder, and select the **Diary** folder. Ensure that **Copy items if needed** is checked in the dialog box, and that **Added folders** is set to **Create groups**. Ensure that **Add to targets** is ticked for **Prepped**. Click **Add** to add the folder and its contents to the project.

In **Main.storyboard** drag a **storyboard reference** from the **Object Library** into the storyboard (drag it to an empty space, not onto a scene).

![bordered height=20%](images/StoryboardReference.png)

**Ctrl-drag** from the existing tab bar controller scene to the **storyboard reference**.

![bordered height=23%](images/ConnectStoryboardRef.png)

In the pop-up that appears, choose **view controllers** from the **Relationship Segue** section.

Select the **storyboard reference** you just added. In the **Attributes Inspector** set the **Storyboard** to **Diary**.

![bordered height=13%](images/DiaryStoryboardRef.png)

Build and run the app and you should now have two tabs: one for Checklists and one for Diary. You can now add Diary entries using the storyboard scenes and code created by your sister-in-arms. Storyboard references make it easier to share the load :].

[TODO: Add screenshot after design process]

> **Note**: Currently both of the tabs in the tab bar controller in the storyboard have the title _Item_. The correct title is loaded during runtime from the Checklists and Diary storyboards. You can change the titles in **Main.storyboard** for your reference, but it won't make any difference at runtime.

## Focus on a storyboard

For the next few sections, you'll be working on checklist items. When working on scenes deep down in the app hierarchy, it can be annoying to tap down into them just to test your new code. Now with storyboard references you can isolate the scenes you're currently working on into their own storyboard and instruct the app to launch straight into it. You'll do that now for the checklist item section.

In **Checklists.storyboard** highlight the **Checklist Detail View Controller**, the **Add Item Navigation Controller** and the **Add Item View Controller** scenes.

![bordered width=90%](images/ItemsRefactored.png)
[TODO: Update after design process]

Select **Editor\Refactor to Storyboard** and name the new storyboard **ChecklistDetail.storyboard**. Ensure that the **Group** is still set to **Checklists**.

Click on the **Prepped project** at the top of the **project navigator**, then click on the **Prepped target** and choose the **General** tab. Change **Main Interface** to **ChecklistDetail.storyboard**.

![bordered height=24%](images/ProjectSettings1.png)

Build and run the app and see that the checklist detail scene is loaded first. Note that the navigation bar and tab bar are missing, because the view controller is no longer embedded in a navigation or tab bar controller. This is only a temporary situation while you work on the items storyboard.

![iPhone bordered](images/Items.png)
[TODO: Update after design process]

> **Note:** If a view controller that you're working on requires properties to be set on it by its presenting view controller before it loads correctly, changing the initial storyboard temporarily may not work for you. In this example though, `ChecklistItemViewController` has been set up to load initial sample data.

## Views in the scene dock

A lesser-known feature of storyboard scenes is the **scene dock**. Most people don't even notice it's there. If you're not familiar with it, it's this view that you find at the top of the currently selected scene in a storyboard:

![bordered width=80%](images/SceneDock.png)

Out of the box, the scene dock contains references to the current view controller, the first responder, and any unwind segues that are available. But did you know you can add your own views to the scene dock? You've always been able to do so, but with Xcode 7 you can now design these attached views right within Interface Builder.

Any views you add in the scene dock aren't added to your view controller's initial subviews array. Instead, you can add IBOutlets to them and then make use of them at runtime.

When you select a checklist item in Prepped, its table row is currently highlighted with a boring gray color. You will now perform the amazing feat of changing the color of a selected row with no code at all – thanks to the scene dock!

In **ChecklistDetail.storyboard**, select **Checklist Detail View Controller** and drag a **view** from the Object Library onto the scene dock.

![bordered height=16%](images/DragViewOntoSceneDock.png)
[TODO: Update after design process]

![bordered height=21%](images/ViewInSceneDock.png)
[TODO: Update after design process]

The new view will appear just above the scene dock. You can add subviews and controls to these docked views, just as you would any other view.

Select the view you added and in the **Attributes Inspector** change the background color of the view to **#FFFAE8**.

[TODO: This section may need updating slightly once design changes are complete.]

The size of the view in the storyboard doesn't really matter as it will be stretched automatically when it is used in the cell. However, if you want to make it smaller so it's taking up less room you can resize it by dragging from its top, left and right edges.

In the document outline, **Control-drag** from **ChecklistItemCell** to the new view. Choose **selectedBackgroundView** from the connections pop-up.

![bordered width=65%](images/ConnectSelectedView.png)
[TODO: Update after design process]

Build and run the app. When you tap a row, it will be colored by your new view. Pretty cool, huh? And no code required!

![bordered iphone](images/SelectedView.png)
[TODO: Update after design process. Suggest using cropped screenshot that primarily shows the selected cell, so it takes up less vertical space.]

> **Note**: This coloring method will only work for table views that don't have multiple selection enabled. Only one instance of the colored view is created, and it's shared between each cell in the table view. As such, it can only be applied to one cell at a time.

## Conditional views using the scene dock

Often in your apps you will have a view that you only need to show under certain conditions. Designing a view like this amongst all the other views in a view controller was always rather difficult in storyboards. One advantage of having a view in the scene dock is that you can create it visually without interfering with the rest of your view controller's subviews. You can then add it to the view hierarchy in code when it's needed.

The checklist items in Prepped's sample data have notes accompanying them. You will now create a view to display an item's note. As you tap the table view row for an item, the row will expand to display the associated note. If you tap the row again or tap a different row, the selected row will contract and the note view will be removed from that row.

Still in **ChecklistDetail.storyboard**, drag a new **view** onto the scene dock, next to the selected background view you created in the last section. Select the view, and in the **Size Inspector** set its width to **320** and its height to **128**.

Drag a **label** from the Object Library onto the new view and in the **Attributes Inspector** change the label text to **"Notes:"**. You may have to resize the label so that the text fits.

![bordered height=26%](images/NotesLabel.png)
[TODO: Update after design process]

Next drag a **text view** from the Object Library onto the new view. Remove its default _Lorem ipsum_ text using the **Attributes Inspector**. Resize and rearrange the label and text views so that they are touching the edges of their container, so that it looks like this:

![bordered width=80%](images/NotesTextView.png)
[TODO: Update after design process]

You'll now connect this notes view to an IBOutlet in the view controller. Even though there are multiple cell instances on the screen at one time, there will be only one notes view instance at a time, so there is no problem connecting this view to an outlet.

With **ChecklistDetail.storyboard** open in the main editor, open **ChecklistDetailViewController.swift** in the **assistant editor**.

&nbsp;

&nbsp;

&nbsp;

You may have to close the **document outline** using the icon beneath the storyboard to get enough space.

![bordered width=80%](images/DocumentOutline.png)

**Ctrl-drag** from the new view to `ChecklistDetailViewController` to create an outlet for the view, just below the existing `checklist` property. Ensure that you are dragging from the view's _background_, not from the text view or label. You can also drag from the view's icon in the scene dock.

Name the outlet `notesView` and click **Connect**. The outlet will appear as a property in `ChecklistDetailViewController`.

![bordered width=80%](images/CreateOutlet.png)
[TODO: Update after design process]

Now **Ctrl-drag** from the text view to `ChecklistDetailViewController` to create another outlet just below the one you just made. Name the outlet `notesTextView` and click **Connect**.

Finally, it's time to write some code! :] You'll use another new feature of iOS 9, stack views, to add and remove the notes view from a cell with an animation.

> **Note:** To learn more about UIStackView, be sure to check out chapters 6 and 7 in this book.

In **ChecklistDetailViewController.swift**, add the following method to the bottom of the main class implementation:

```swift
func addNotesViewToCell(cell: ChecklistItemTableViewCell) {
  notesView.heightAnchor.constraintEqualToConstant(notesViewHeight).active = true
  notesView.clipsToBounds = true

  cell.stackView.addArrangedSubview(notesView)
}
```

This method ensures that the notes view has its height defined by Auto Layout and then adds it to the cell's stack view's `arrangedSubviews` collection. It also sets `clipsToBounds` to `true` to prevent the text view spilling outside of the cell when you perform a swipe-to-delete.

The height needs to be set using Auto Layout because the stack view derives its own height from the heights of its `arrangedSubviews`. If you didn't set this here, the cell wouldn't get any bigger when you add the notes view.

Next, add this method below `addNotesViewToCell(_:)`:

```swift
func removeNotesView() {
  if let stackView = notesView.superview as? UIStackView {
    stackView.removeArrangedSubview(notesView)
    notesView.removeFromSuperview()
  }
}
```

This code removes the notes view from the stack view's `arrangedSubviews` and also from its set of visible subviews.

Next, to put these methods to use. Still in **ChecklistDetailViewController.swift**, find the empty table view delegate extension for `ChecklistDetailViewController` and add `tableView(_:didSelectRowAtIndexPath:)`:

```swift
override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  // 1
  guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChecklistItemTableViewCell else {
    return
  }

  // 2
  tableView.beginUpdates()
  // 3
  if cell.stackView.arrangedSubviews.contains(notesView) {
    removeNotesViewFromCell(cell)
  } else {
    addNotesViewToCell(cell)

    // 4
    notesTextView.text = checklist.items[indexPath.row].notes
  }

  // 5
  tableView.endUpdates()
}
```

This method does the following:

1. Uses a Swift 2.0 `guard` statement to ensure that there is a valid cell of the right type at the selected index path before continuing.
2. Calls `tableView.beginUpdates()` so that the changes to the cell's height are animated.
3. If the cell's stack view already contains the notes view, then it gets removed. Otherwise, it gets added.
4. Updates the notes text view's `text` to contain the notes for the selected checklist item.
5. Finally, calls `tableView.endUpdates()` to commit the changes.

Finally, change the project's main interface back to the main storyboard; click on the **Prepped project** in the **project navigator**, click on the **Prepped target** and then on the **General** tab. Change **Main Interface** to **Main.storyboard**.  [FPE: How much do we need to explain / screenshot this again? The user did it earlier to set the storyboard to ChecklistDetail]

![bordered width=50%](images/ProjectSettings2.png)

Build and run. Tap on a cell again, and you should see the notes view appear. Nice work! By using a stack view, you didn't need to set any frames manually or even add extra constraints to the cell (other than defining the height of the notes view). In previous versions of iOS, this would've been rather more tricky to implement.

![iPhone](images/ExpandedNotes2.png)
[TODO: Update after design process]

>**Note:** Being able to create a view in the scene dock is useful, but primarily if a view is only used within a single view controller. If the supplementary view is reused throughout the app, then you would probably be best off using a XIB file which you instantiate in code.

## Multiple bar buttons

The final feature you'll be adding to your app is the ability to add and delete checklist items. The scene and code for adding a checklist item is already in the starter app, but it's not hooked up to anything yet. That's where you come in.

You will need two new buttons on the checklist detail view controller's navigation bar: one for Add and one for Edit. Apps often achieve this by having an "Edit" button on the left side of the bar and and an "Add" button on the right of the bar. However, in Prepped the left side of the navigation bar is already used for the standard navigation back button.

![bordered height=6%](images/NavigationBar1.png)
[TODO: Update after design process - ensure that images are cropped correctly!]

Previously you would have had to create a view that held multiple buttons and then add that view to the navigation bar. Xcode 7 brings another useful new feature to storyboards which means that this is no longer necessary: the ability to add multiple buttons directly to a navigation bar.

In **ChecklistDetail.storyboard** select **Checklist Detail View Controller** in the document outline. Drag a **bar button item** from the Object Library onto the right hand side of the navigation bar.

The document outline will now show a group for left bar button items and a group for right bar button items.

![bordered height=20%](images/CheckListItems.png)

Drag a second bar button item onto the right side of the navigation bar. In the **Attributes Inspector** change the **System Item** of the left of the two buttons to **Add** and change the other button's **System Item** to **Edit**.

![bordered height=20%](images/CheckListItemButtons.png)
[TODO: Update after design process]

**Ctrl-drag** from the **Add** button to the **Add Item Navigation Controller** scene and choose **present modally** from the pop-up menu. When the user taps the **Add** button the Add Item scene will be presented.

You'll now need to connect a couple of unwind segues to return from the Add Item scene. The unwind methods have already been created for you in ChecklistDetailViewController.swift.

Still in **ChecklistDetail.storyboard**, select the **Add Item View Controller** scene in the Document Outline. **Ctrl-drag** from the **Cancel** button on the left side of the navigation bar to **Exit** on the scene dock. Choose `cancelToChecklistDetailViewController:` from the pop-up menu.

**Ctrl-drag** from the **Save** button on the right side of the navigation bar to **Exit** on the scene dock and choose `saveToChecklistDetailViewController:` from the pop-up menu.

Build and run the app, choose a checklist and try out adding items with notes to the list. These will not be saved permanently, because the sample data is currently only held in arrays which only exist for the duration of the app.

[TODO: Add screenshot after design process. Suggest using cropped screenshot that primarily shows the selected cell, so it takes up less vertical space.]

Now you just need to implement the code for the Edit button. Firstly, in **ChecklistDetailViewController.swift** add the following line to the bottom of `viewDidLoad()`:

```swift
navigationItem.rightBarButtonItem = editButtonItem()
```

The `navigationItem`'s `rightBarButtonItem` is the button that is farthest to the right of the bar. Similarly, the `leftBarButtonItem` is the button that is farthest to the left of the bar. This line of code replaces the Edit button with the view controller's built-in edit button item. It takes care of animating to and from an 'editing' state, and changes the button's text from "Edit" to "Done" and back again as required.

Still in **ChecklistDetailViewController.swift**, find the table view data source extension. Add the following implementation inside the extension, below the existing methods:

```swift
override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
    removeNotesView()

    checklist.items.removeAtIndex(indexPath.row)

    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  }
}
```

This method removes the notes view if it's present, removes the checklist from the view controller's `checklist` array, and then tells the table view to delete the row.

Build and run the app. Choose a check list, tap the **Edit** button and delete an item from the list. Tap the **Done** button to complete editing.

[TODO: Add screenshot after design process]

## Where to go from here?

Congratulations! You've now built an app to help you survive the apocalypse! Hopefully you've seen that with the introduction of new features such as storyboard references and an enhanced scene dock there really are very few reasons not to use storyboards in your own projects.

Storyboards in Xcode 7 also have greater support for custom segues. We've got that covered in chapter 9 of this book: _Custom Segues_.

Prepped is currently for the iPhone only. To make it a universal app, you can read all about adaptive layouts in _iOS 8 by Tutorials_. You can also find out more about supporting multitasking on the iPad in chapter 5 of this book.

There are also two useful sessions to check out from WWDC 2015:
* Session 215, What's New In Storyboards: <http://apple.co/1Do4xn7>
* Session 407, Implementing UI Designs in Interface Builder: <http://apple.co/1g60D7c>
