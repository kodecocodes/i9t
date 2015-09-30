```metadata
author: "By Caroline Begbie"
number: "9"
title: "Chapter 9: What's New in Storyboards?"
```

# Chapter 9: What's New in Storyboards?

Storyboards have been around since iOS 5 and have received lots of upgrades and new features since then, including unwind segues for reverse navigation, universal storyboards for both iPhone and iPad, and live rendering of views designed in code.

Xcode 7 brings new features for storyboards that let you do the following:

* Refactor a single storyboard into multiple storyboards and link them visually via _storyboard references_.
* Add supplementary views to a view controller using the _scene dock_.
* Add _multiple buttons_ to a navigation bar, right from the storyboard itself!

You'll learn how to use the above features as you update an app designed to help you with all those listable moments in life, whether it's grocery shopping, packing your luggage for vacation, or a survival checklist for the impending zombie apocalypse! :]  

To get the most out of this chapter you should have some basic storyboard and table view knowledge. Need a quick brush-up? Check out our _Storyboards Tutorial in Swift_ at <http://www.raywenderlich.com/113388>.

## Getting started

Open the starter project for this chapter and run it in the simulator; tap one of the displayed checklists to view the items contained within, then tap any entry to check it off. Done and done!

![iphone bordered](images/01-Prepped.png)

Take a quick look at the code to get your bearings.

**ChecklistsViewController.swift** displays the initial list of checklists, and **ChecklistDetailViewController.swift** displays the items within each list. **Main.storyboard** contains the user interface items.

There are two unused scenes in the storyboard; you'll use those later in the tutorial.

The app is not quite complete; your task in this chapter is to improve it so you can add items to a list, add notes to an item, delete an item and add diary entries to record your zombie survival efforts.

## Storyboard references

If you've used storyboards on a large project or as part of a team with other developers, you'll know they can quickly become unwieldy. Merge conflicts, spaghetti-like segue arrows and navigating your way around a wall of scenes is enough to make anybody question whether storyboards are worth the effort.

Although you've always been able to use multiple storyboards in your apps, you've never been able to segue between them using Interface Builder. To present a view controller from a different storyboard, you'd have to instantiate it first and present it in code. But no longer!

With Xcode 7, you can add references between storyboards right in Interface Builder using **storyboard references**, which can either point to specific view controllers or to the initial view controller within another storyboard. This makes it much easier to divide up storyboards into smaller storyboards, and alleviates many of the issues mentioned above without needing to add any extra code.

Multiple smaller storyboards also make it possible for other team members to work independently on their own storyboards without stepping on each other's toes.

Enough theory — time to put it into practice!

> **Note**: Storyboard references are actually backwards-compatible to iOS 8. However, in iOS 8 you can't use a storyboard reference with a relationship segue, or use it to point to storyboards in external bundles.

## Creating your first storyboard reference

In its current state, **Prepped** is a small app in the early stages of development, but there's enough structure there to discern where to divide up the main storyboard. Container view controllers are a good place to consider splitting out functionality into new storyboards.

Prepped uses a tab bar controller, and in this case it makes sense to separate each tab's children into their own storyboards.

Open **Main.storyboard** and zoom out so you can see all six scenes. Hold **Command** and press **+** to zoom in and **-** to zoom out, or **right-click** on a blank area in the storyboard and choose your zoom level.

Click and drag to highlight all scenes in the storyboard except for the tab bar controller on the left-hand side:

![bordered width=90%](images/02-HighlightStoryboard.png)

Select **Editor\Refactor to Storyboard** and enter **Checklists.storyboard** as the name of the new storyboard. Set the **Group** to **Checklists**, then click **Save**.

As if by magic, Xcode does the following:

1. Splits out the selected scenes into a new storyboard.
2. Changes the target of the tab bar controller's "view controllers" segue to a storyboard reference that points to the relevant scene in the new storyboard.
3. Takes you to the new storyboard.

You may have to zoom out and reposition the new storyboard to see all of its scenes. The arrangement of the scenes and their segues is exactly like it was in the original storyboard. Here's what the new storyboard should look like:

![bordered width=90%](images/03-Refactored.png)

But what happened to the original storyboard? Open **Main.storyboard** and take a look:

![bordered width=95%](images/04-AfterRefactor.png)

The tab bar controller's "view controllers" segue now points to the storyboard reference for the navigation controller in **Checklists.storyboard**. The storyboard reference uses the navigation controller's storyboard ID to determine which scene to segue to in the new storyboard.

There are a few 'dangling' storyboard references to view controllers that had storyboard IDs set; you won't need these any longer. Select `ChecklistDetailViewController`, `AddChecklistItemNavigationController` and `AddChecklistItemViewController` and delete them.

> **Note**: If a scene has an empty storyboard ID, the **Refactor to Storyboard** command automatically generates an ugly one, such as _UIViewController-gtY-c7-gYu_. You can change this later, but it's much easier to keep track of things when you explicitly set the storyboard IDs yourself.

Instead of referencing specific view controllers, storyboard references can simply refer to the initial scene in a storyboard.

Still in **Main.storyboard**, select the new storyboard reference named **ChecklistsNavigationController** and use the **Attributes Inspector** to remove the **Referenced ID**, like so:

![bordered height=12%](images/05-StoryboardReferenceID.png)

The reference now points to the initial view controller in **Checklists.storyboard**, and updates as shown:

![bordered height=5%](images/06-ChecklistsStoryboardRef.png)

Open **Checklists.storyboard** and select the **Checklists Navigation Controller** scene. Use the **Attributes Inspector** to check **Is Initial View Controller**; this indicates this scene should be the entry point for the storyboard.

![bordered width=36%](images/07-NavigationStoryboardID.png)

> **Note**: The initial view controller of a storyboard has an arrow pointing to it from the left-hand side.

Build and run your project; the app performs just as it did when you started. The only difference is that things are a little more organized behind the scenes!

## Storyboards within a team

Distributed development of storyboards has always been a challenge; in fact, many developers still avoid storyboards out of fear of the dreaded merge conflict. But storyboard references can help you avoid the complications of team storyboard development.

Consider the following scenario: you're writing Prepped with a fellow apocalypse survivor, whose task it is to create the functionality to handle the diary entries. She's built it using a separate storyboard, and now you need to add it to your own storyboard hierarchy...before the zombies descend upon your little enclave.

In the project navigator, select the top level **Prepped group**, located just below the project itself. Click **File\Add Files to "Prepped"**. Navigate to the Prepped folder, and select the **Diary** folder. Ensure that **Copy items if needed** is checked in the dialog box, and that **Added folders** is set to **Create groups**. Ensure that **Add to targets** is ticked for **Prepped**. Click **Add** to add the folder and its contents to the project.

In **Main.storyboard**, drag a **storyboard reference** from the **Object Library** into an empty space on the storyboard:

![bordered height=20%](images/08-StoryboardReference.png)

**Ctrl-drag** from the existing tab bar controller scene to the **storyboard reference**:

![bordered height=23%](images/09-ConnectStoryboardRef.png)

In the pop-up that appears, choose **view controllers** from the **Relationship Segue** section.

Select the **storyboard reference** you just added. In the **Attributes Inspector** set the **Storyboard** to **Diary**:

![bordered height=13%](images/10-DiaryStoryboardRef.png)

Build and run your app; you'll see one tab to handle Checklists, and another tab for the Diary entries – the functionality your teammate worked on. You can now add Diary entries using the storyboard scenes and code created by your sister-in-arms:

![iphone bordered](images/11-Diary.png)

> **Note**: Currently both tabs in the tab bar controller in the storyboard display the title _Item_. The proper title will be loaded at runtime from the Checklists and Diary storyboards. You can change the titles in **Main.storyboard** for your own reference, but it won't make any difference at runtime.

## Focusing on a storyboard

Isn't it annoying when you have to tap through a bunch of scenes in your app, when you're just trying to test one single scene buried deep in the stack? With storyboard references you can isolate the scenes you're interested in into their own storyboard and instruct the app to launch straight into that. You'll do that now for the checklist item section.

In **Checklists.storyboard** highlight the **Checklist Detail View Controller**, **Add Item Navigation Controller** and **Add Item View Controller** scenes:

![bordered width=90%](images/12-ItemsRefactored.png)

Select **Editor\Refactor to Storyboard** and name the new storyboard **ChecklistDetail.storyboard**. Ensure that the **Group** is still set to **Checklists**.

Just as you did for the Checklists storyboard, select the **Checklist Detail View Controller** scene in **ChecklistDetail.storyboard**, and use the **Attributes Inspector** to check **Is Initial View Controller**. The Checklist Detail View Controller should now have an arrow on its left to indicate it's the first scene in the storyboard.

Click on the **Prepped project** at the top of the project navigator, then click on **Prepped target** and choose the **General** tab. Change **Main Interface** to **ChecklistDetail.storyboard**:

![bordered height=24%](images/13-ProjectSettings1.png)

Build and run your app; you'll see the checklist detail scene loads first:

![iPhone bordered](images/14-ChecklistDetail.png)

Where are the navigation and tab bar? Since the view controller is no longer embedded in a navigation or tab bar controller, you won't see those two elements while you're working on the items storyboard.

> **Note:** This approach will fail if the initial view controller in the chosen storyboard requires data provided via a segue. In this project,  `ChecklistDetailViewController` has already been set up to load initial sample data.

## Views in the scene dock

A lesser-known feature of storyboard scenes is the **scene dock**. Most people don't even notice it's there - did you? You'll find it at the top of the currently selected scene in a storyboard:

![bordered width=80%](images/15-SceneDock.png)

Out of the box, the scene dock contains references to the current view controller, the first responder, and any available unwind segues. But did you know you can add your own views to the scene dock? You've always been able to do so, but Xcode 7 lets you design these attached views within Interface Builder.

Any views you add in the scene dock won't be added to your view controller's initial subviews array; instead, you can add IBOutlets to them and make use of them at runtime.

Selecting a checklist item in Prepped highlights its table row with a boring gray color. You will now perform the amazing feat of changing the color of the selected row with no code at all — thanks to the scene dock!

In **ChecklistDetail.storyboard**, select **Checklist Detail View Controller** and drag a **view** from the Object Library onto the scene dock:

![bordered height=16%](images/16-DragViewOntoSceneDock.png)

![bordered height=21%](images/17-ViewInSceneDock.png)

The new view will appear just above the scene dock. You can add subviews and controls to these docked views, just as you would any other view.

Select the view you added and use the **Attributes Inspector** to change the background color of the view to **#FFFAE8**.

The size of the view in the storyboard doesn't really matter, since it will be stretched automatically when it's used in the cell. However, if you want it to take up less room you can resize it by dragging its top, left and right edges.

In the document outline, **Ctrl-drag** from **ChecklistItemCell** to the new view. Choose **selectedBackgroundView** from the connections pop-up:

![bordered width=75%](images/18-ConnectSelectedView.png)

Build and run your app; tap any row, and it's highlighted with by your new view. Pretty neat — and without a stitch of code!

![bordered width=35%](images/19-SelectedViewColoring.png)

> **Note**: This coloring method will only work for table views that don't have multiple selection enabled. Only one instance of the colored view is created, and it's shared between each cell in the table view. As such, it can only be applied to one cell at a time.

## Conditional views using the scene dock

Often, you'll have a view that you only want to show under certain conditions. Designing a view like this amongst all the other views in a view controller was always rather difficult in storyboards. The advantage of having a view in the scene dock is that you can create it visually without interfering with the rest of your view controller's subviews. You can then add it to the view hierarchy in code when it's needed.

The checklist items in Prepped's sample data have notes accompanying them; you're now going to create a view to display an item's note. When you tap the table view row for an item, the row will expand to display the associated note. Tapping the row again or tapping a different row collapses the row and removes the note view from that row.

Still in **ChecklistDetail.storyboard**, drag a new **view** onto the scene dock, next to the selected background view you created in the last section. Select the view, and use the **Size Inspector** to set its width to **320** and its height to **128**.

Drag a **label** from the Object Library onto the new view and use the **Attributes Inspector** to change the label text to **"Notes:"**. You may have to resize the label so that the text fits. Change the label's text color to **#BB991E**:

![bordered width=70%](images/20-NotesLabel.png)

Next, drag a **text view** from the Object Library onto the new view. Remove its default _Lorem ipsum_ text using the **Attributes Inspector**. Uncheck **Behavior** **Editable** and **Selectable**. Resize and rearrange the label and text views so they touch the edges of their container so that it looks like this:

![bordered width=80%](images/21-NotesTextView.png)

You'll now connect this notes view to an IBOutlet in the view controller. Even though there are multiple cell instances on the screen at one time, there will be only one notes view instance at any time, so it won't be an issue to connect this view to an outlet.

With **ChecklistDetail.storyboard** open in the main editor, open **ChecklistDetailViewController.swift** in the **assistant editor**. You may have to close the **document outline** using the icon beneath the storyboard to get enough space:

![bordered width=80%](images/22-DocumentOutline.png)

**Ctrl-drag** from the new view to `ChecklistDetailViewController` to create an outlet for the view just below the existing `checklist` property. Ensure that you are dragging from the view's _background_, not from the text view or label. You can also drag from the view's icon in the scene dock.

![bordered width=80%](images/23-CreateOutlet.png)

Name the outlet `notesView` and click **Connect**. The outlet will appear as a property in `ChecklistDetailViewController`.

Now **Ctrl-drag** from the text view to `ChecklistDetailViewController` to create another outlet just below the one you just made. Name the outlet `notesTextView` and click **Connect**.

Finally, it's time to write some code! :] You'll use another new feature of iOS 9, _UIStackView_, to add and remove the notes view from a cell with an animation.

> **Note:** To learn more about UIStackView, be sure to check out chapter 7, "UIStackView and Auto Layout Changes", and chapter 8, "Intermediate UIStackView".

In **ChecklistDetailViewController.swift**, add the following method to the bottom of the main class implementation:

```swift
func addNotesViewToCell(cell: ChecklistItemTableViewCell) {
  notesView.heightAnchor
    .constraintEqualToConstant(notesViewHeight)
    .active = true
  notesView.clipsToBounds = true

  cell.stackView.addArrangedSubview(notesView)
}
```

This method ensures Auto Layout defines the the notes view's height, then adds it to the cell's stack view's `arrangedSubviews` collection. It also sets `clipsToBounds` to `true` to prevent the text view from spilling outside of the cell when you perform a swipe-to-delete.

The height needs to be set using Auto Layout since the stack view derives its own height from the heights of its `arrangedSubviews`. If you don't set the height here, the cell won't grow when you add the notes view.

Next, add the following method below `addNotesViewToCell(_:)`:

```swift
func removeNotesView() {
  if let stackView = notesView.superview as? UIStackView {
    stackView.removeArrangedSubview(notesView)
    notesView.removeFromSuperview()
  }
}
```

This removes the notes view from the stack view's `arrangedSubviews` as well from its set of visible subviews.

Next, you need to put these methods to use. Still in **ChecklistDetailViewController.swift**, find the table view delegate extension for `ChecklistDetailViewController` and add the following code:

```swift
override func tableView(tableView: UITableView,
  didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // 1
    guard let cell = tableView.cellForRowAtIndexPath(indexPath)
      as? ChecklistItemTableViewCell else {
        return
    }

    // 2
    tableView.beginUpdates()
    // 3
    if cell.stackView.arrangedSubviews.contains(notesView) {
      removeNotesView()
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
2. Calls `tableView.beginUpdates()` to animate the changes to the cell's height.
3. Removes the notes view if the cell's stack view already contains it; otherwise, add the notes view.
4. Updates the notes text view to contain the notes for the selected checklist item.
5. Finally, calls `tableView.endUpdates()` to commit the changes.

Finally — don't forget that you changed the project's main interface earlier on. To change the project's main interface back to the main storyboard: click on the **Prepped project** in the **project navigator**, click on the **Prepped target** and then click on the **General** tab. Change **Main Interface** to **Main.storyboard**:

![bordered width=50%](images/24-ProjectSettings2.png)

Build and run your app; tap any cell and you should see the notes view appear. Using a stack view means you didn't need to set any frames manually or add any constraints to the cell other than the one that defines the height of the notes view. In previous versions of iOS, this would've been rather more tricky to implement.

![bordered iPhone](images/25-ExpandedNotes2.png)

>**Note:** Being able to create a view in the scene dock is useful, but only if it is used solely from one view controller. If the supplementary view is reused throughout the app, you'd be better off using a XIB file that you instantiate in code.

## Using multiple bar buttons

The final feature you'll add to your app is the ability to add and delete checklist items. The scene and code for adding a checklist item is already in the starter app, but it's not hooked up to anything yet. That's where you come in.

You need two new buttons on the checklist detail view controller's navigation bar: one for Add and one for Edit. Apps often achieve this by having an "Edit" button on the left side of the bar and and an "Add" button on the right of the bar. However, in Prepped the left side of the navigation bar is already being used for the standard navigation back button:

![bordered height=6%](images/26-NavigationBar1.png)

Prior to Xcode 7, you would've had to create a view with multiple buttons and add that view to the navigation bar. Xcode 7 brings another useful new feature to storyboards which makes this extra step unnecessary: the ability to add multiple buttons directly to a navigation bar.

In **ChecklistDetail.storyboard** select **Checklist Detail View Controller** in the document outline. Drag a **bar button item** from the Object Library onto the right hand side of the navigation bar.

The document outline will now show a group for left bar button items and a group for right bar button items:

![bordered height=20%](images/27-CheckListItems.png)

Drag a second bar button item onto the right side of the navigation bar. Use the **Attributes Inspector** to change the **System Item** of the left of the two buttons to **Edit**. Change the other button's **Image** to **AddButtonIcon**:

![bordered height=20%](images/28-ChecklistItemButtons.png)

**Ctrl-drag** from the **Add** button to the **Add Item Navigation Controller** scene and choose **present modally** from the pop-up menu. When the user taps the **Add** button the Add Item scene will appear.

You'll now need to connect a couple of unwind segues to return from the Add Item scene; these unwind methods have already been created for you in **ChecklistDetailViewController.swift**.

Still in **ChecklistDetail.storyboard**, select the **Add Item View Controller** scene in the Document Outline. **Ctrl-drag** from the **Cancel** button on the left side of the navigation bar to **Exit** on the scene dock. Choose `cancelToChecklistDetailViewController:` from the pop-up menu.

**Ctrl-drag** from the **Save** button on the right side of the navigation bar to **Exit** on the scene dock and choose `saveToChecklistDetailViewController:` from the pop-up menu.

Build and run your app; choose a checklist and try adding items with notes to the list. These won't be saved permanently, because the sample data is currently only held in-memory:

![bordered width=35%](images/29-AddChecklistItem.png)

Now you just need to implement the code for the Edit button. First, add the following line to the bottom of `viewDidLoad()` in **ChecklistDetailViewController.swift**:

```swift
navigationItem.rightBarButtonItems![1] = editButtonItem()
```

This line replaces the Edit button with the view controller's built-in edit button item. It takes care of animating to and from an 'editing' state and changes the button's text from "Edit" to "Done" and back again as required.

Still in **ChecklistDetailViewController.swift**, find the table view data source extension. Add the following implementation inside the extension, below the existing methods:

```swift
override func tableView(tableView: UITableView,
  commitEditingStyle editingStyle: UITableViewCellEditingStyle,
  forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      removeNotesView()

      checklist.items.removeAtIndex(indexPath.row)

      tableView.deleteRowsAtIndexPaths([indexPath],
        withRowAnimation: .Fade)
    }
}
```

This method removes the notes view if it's present, removes the checklist from the view controller's `checklist` array and then tells the table view to delete the row.

Build and run your app; choose a check list, tap the **Edit** button and delete an item from the list. Tap the **Done** button to complete editing.

![bordered iphone](images/30-PreppedEditing.png)

## Where to go from here?

Your app to help you survive the apocalypse is done! All the new features you've covered in this chapter, including storyboard references and an enhanced scene dock should show you there are very few reasons _not_ to use storyboards in your own projects.

Storyboards in Xcode 7 also have greater support for custom segues. We've got that covered in chapter 10 of this book: _Custom Segues_. If you decide to make Prepped a universal app, you can read more about supporting multitasking on the iPad in Chapter 5: _Multitasking_.

There are some useful sessions from WWDC 2015 that will help you as well:
* Session 215, What's New In Storyboards: <http://apple.co/1Do4xn7>
* Session 407, Implementing UI Designs in Interface Builder: <http://apple.co/1g60D7c>
