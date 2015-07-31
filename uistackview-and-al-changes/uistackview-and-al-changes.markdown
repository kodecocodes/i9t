# Chapter 6: UIStackView and Auto Layout Changes

Have you ever needed to add or remove views at runtime and wished that other views could reposition themselves automatically? Did you end up having outlets to constraints in your storyboard so that you could activate or deactivate certain ones? Did you use a third party library? Or maybe you decided that it was just easier to do everything in code.

Perhaps you are one of the lucky ones and your view hierarchy didn't have to change at runtime, but there were new requirements, of course, and you had to figure out how to squeeze this one new view into your storyboard. Did you ever end up just clearing all constraints and re-adding them from scratch because it was easier than performing _constraints-surgery_?

With the introduction of `UIStackView`, the above tasks become trivial. Stack views provide a way to lay out a series of views horizontally or vertically. By configuring a few simple properties such as alignment, distribution, and spacing, you can define how the contained views adjust themselves to the available space.

In this chapter, you'll learn about stack views, and about some of the other new features in Auto Layout introduced this year such as layout anchors, and layout guides.

> **Note**: This chapter assumes basic familiarity with Auto Layout. If you are new to Auto Layout, you can get started with the Auto Layout tutorials on raywenderlich.com, or with the Auto Layout video series. For a more in-depth look, see the Auto Layout chapters in the 3rd edition of iOS 6 by Tutorials.

## Getting Started

In this chapter, you'll start working on an app called **Vacation Spots**, which you'll continue working on in the next chapter as well. It's a simple app that shows you a list of places that you can go on vacation. It has a few issues that you'll fix by using stack views, and in a much simpler way than if you were just using Auto Layout alone. Towards the end of this chapter, you'll also fix another issue with the use of layout guides and layout anchors.

Here is what the completed version of the app will look like:

![height=41%](images/01-full-app_2318x1344.png)

Open **VacationSpots-Starter**, and run it on the **iPhone 6 Simulator**. The first thing you'll notice is that the name and location label in some cells are not centered properly.

![bordered width=30%](images/02-alignment-issue-on-table-view_750x534.png)

Both the name and location label for a vacation spot should be centered vertically (as a group) so that there is an equal amount of space above the name label, and below the location label. This is the issue you'll fix towards the end of the chapter by using a layout guide. For now go to the info view for London by tapping on the first cell.

At first glance, the view may look ok but it has a few issues.

1. Take a look at the row of buttons at the bottom of the view. They are currently positioned with a fixed amount of space between themselves and so do not adapt to the screen width. To better see this issue, temporarily rotate the simulator to landscape orientation by pressing **Command-Left**.

![bordered iphone-landscape](images/03-issues-visible-in-landscape-view_1334x750.png)

2. Tap on the **Hide** button next to the **Weather:** label. While it does hide the text, it doesn't reposition the **What to See** section below it to occupy the newly created empty space.

![bordered width=32%](images/04-hide-weather-issue_750x820.png)

3. The ordering of the sections can be improved. It would be better if the **What to See** section was positioned right after the **Why Visit** section, instead of having the **Weather** section in between them.

4. The bottom row of buttons is a bit too close to the bottom edge of the view in landscape mode. It would be better if you could decrease the spacing between the different sections, but only in landscape mode (i.e. when the vertical size class is compact).

Now that you have an idea of the improvements you'll be making, it's time to dive into the project.

Open **Main.storyboard** and take a look at the **Spot Info View Controller** scene. The first thing you'll notice is that it looks quite colorful!

[TODO: Opportunity for humor? Is there a "look at all the pretty colors" meme?]
TODO:update screenshot
![bordered width=40%](images/05-colorful-scene-in-storyboard_504x636.png)

These labels and buttons have various background colors set on them, which will help you visualize how various properties of a stack view affect the frame of its embedded views. The background colors are set only for the purpose of working with the storyboard and will be cleared at runtime.

You don't need to do this now, but if at any point you'd actually like to see the background colors while running the app, you can temporarily comment out the following lines in the `viewDidLoad()` method of `SpotInfoViewController`.

```swift
// Clear background colors from labels and buttons
for view in backgroundColoredViews {
  view.backgroundColor = UIColor.clearColor()
}
```

Also, any labels that are connected to outlets have placeholder text that is set to the name of the outlet variable they are connected to, within angle brackets. This is just to make it slightly easier to see at a glance which labels will have their text updated at runtime. For example, the label with text **&lt;whyVisitLabel>** is connected to `@IBOutlet weak var whyVisitLabel: UILabel!`.

Another thing to you'll notice is that the scenes in the storyboard are not the default 600 x 600 squares that you get when using size classes. Size classes are still enabled, but the size of the initial Navigation Controller has been set to **iPhone 4-inch** under the **Simulated Metrics** section in the **Attributes inspector**. This is just to make it a bit easier to work with the Storyboard, as well as to more easily fit in the screenshots for this chapter!

![bordered width=99%](images/06-simulated-metrics-iphone-4-inch_640x140.png)

## Your First Stack View

The first thing you'll fix by using a stack view is the spacing between the bottom row of buttons. A stack view can distribute its views along its axis in various ways, and one of the ways is with an equal amount of spacing between each view.

Embedding existing views into a new stack view is pretty easy. First, select all of the buttons at the bottom of the **Spot Info View Controller** scene by **clicking** on one, then **Command-clicking** on the other two:

TODO: screenshot
![bordered width=70%](images/07-drag-select-bottom-row-of-buttons_480x117.png)

If the outline view is not already open, go ahead and open it using the **Show Document Outline** button at the bottom left of the storyboard canvas:

![bordered width=20%](images/08-document-outline-button_120x40.png)

Verify that all buttons are selected by taking a look at them in the outline view:

![bordered width=40%](images/09-verify-button-selection_357x94.png)

In case they are not all selected you can also **Command-click** on each button in the outline view to select them.

Once they are all selected, click on the new **Stack** button in the Auto Layout toolbar at the bottom right of the storyboard canvas:

![bordered width=20%](images/10-stack_button_outlined_148x52.png)

The buttons will become embedded in a new stack view:

![bordered width=96%](images/11-bottom-row-is-now-in-stack-view_640x100.png)

You'll notice that the buttons are now flush with each other which you'll fix shortly. While the stack view will take care of positioning the buttons, you'll still need add Auto Layout constraints to position the stack view itself.

When you embed a view in a stack view, any constraints to other views are removed. Prior to embedding the buttons in a stack view, the top of the **Submit Rating** button had a vertical spacing constraint connecting it to the bottom of the **Rating:** label:

![bordered width=40%](images/12-prior-constraint_354x95.png)

Click on the **Submit Rating** button to see that it no longer not has any constraints attached to it:

![bordered width=50%](images/13-no-more-constraints_366x99.png)

You can also verify that it no longer has any constraints by taking a look at the **Size inspector** (⌥⌘5):

![bordered width=90%](images/14-size-inspector_621x84.png)

In order to add constraints to position the stack view itself, you'll first need to select it. Selecting a stack view in the storyboard can get tricky if its views completely fill the stack view.

One simple way is just to select the stack view in the outline view:

![bordered width=90%](images/15-document-outline-selection_640x72.png)

Another way to select it is to hold **Shift** and **Right-click** on any of the views in the stack view, or **Control-Shift-click** if you are using a trackpad. You'll get a context menu that shows the view hierarchy at the location you clicked, and you can select the stack view by clicking on it in the menu.

Go ahead and select the stack view using the **Shift-Right-click** method:

TODO: screenshot
![bordered width=40%](images/16-view-hierarchy-menu_384x212.png)

Now, to add constraints to it, click on the **Pin** button on the Auto Layout toolbar:

![bordered width=20%](images/17-pin-button_142x57.png)

You will add the following constraints to the top, left, and right edges of the stack view:

- top: 20
- left: 0
- right: 0
- bottom: 0

Make sure the numbers for the top, left, and right and bottom correct and that the I-beams are selected. You will always be constraining to margins so make sure that **Constrain to margins** is checked as well. Then click on **Add 4 Constraints**:

![bordered width=30%](images/18-bottom-stack-view-constraints.png)

Note that the stack view is now the correct size, but it has stretched the first button to fill in any extra space:

![bordered width=50%](images/19-bottom-stack-view-with-distribution-fill2_384x103.png)

The property that determines how the stack view lays out its views along its axis is its `distribution` property. It is currently set to `Fill` which means that the contained views will completely fill the stack view along its axis, and to accomplish this the stack view will only expand one of its views to fill in any extra space. It will expand the view with the lowest horizontal content hugging priority, or if all of the priorities are equal, it will expand the first view.

However, you don't want the buttons to completely fill the stack view. You instead want them to be equally spaced from each other.

Make sure the stack view is still selected and go to the **Attributes inspector**. Change the **Distribution** from **Fill** to **Equal Spacing**:

![bordered width=90%](images/20-equal-spacing_607x148.png)

Now build and run, tap on any cell, and rotate the simulator (⌘→). You'll see that the bottom row of buttons are now spaced equally!

![bordered iphone-landscape](images/21-now-buttons-are-equally-spaced_1334x750.png)

Consider how you'd solve this problem without using a stack view. You would have needed to add dummy spacer views, one between each button pair of buttons. You'd select all of the spacer views and give them equal width constraints. You'd then pin each spacer view to the buttons on either side of it. You'd also need to add constraints for the heights of the spacer views, and also constraints for their vertical position in the superview. Alternatively you could also pin the top and bottom edges to the adjacent buttons.

It would have looked something like the following. The spacer views here been given a light gray background here for visibility:

![bordered width=50%](images/22-alternate-solution-1_346x76.png)

Perhaps you're a seasoned Auto Layout veteran, and adding constraints like these is a piece of cake. And you might not feel like you've gained much by using a stack view. [TODO: Opportunity for humor here? "I am autolayout master" Is there an "Im am the master" meme?]

You'd still have optimized your layout by not having to include unnecessary spacer views, but even if you ignore this benefit, think a bit longer term. What happens when you need to add a new button? Sure it wouldn't be too difficult for you to re-do all the constraints, but would you rather not just drag and drop the additional button into place, and have the stack view take care of the positioning for you?

[TODO: "Still not convinced?" or "Tell me more" meme/humor]

Now what if you needed to conditionally hide and show one of the buttons and reposition all of the remaining ones at runtime? You'd have to manually remove and re-add constraints in code as well as remove and add back the adjacent spacer view. And what if the requirement specified that more than one button could be removed and re-added at any time? At this point, you might as well do everything in code.

In order to hide a view within a stack view all you have to do is set the contained view's `hidden` property to `true` and the stack view handles the rest. This is how you'll fix the spacing under the **Weather:** label when the user has hidden the text below it.

But you'll do this in the next chapter, where you'll continue to learn about stack views in-depth. For now you'll take a quick detour to learn about some of the other new Auto Layout updates in iOS 9.

Stack views are by far the biggest feature introduced in Auto Layout this year, but there are also other features that bring improvements to existing ways of doing things. Two of these new features are layout anchors and layout guides, represented by the the new `NSLayoutAnchor` and `UILayoutGuide` classes. You're going to learn about these next. 

## Layout Anchors

Layout anchors are a great new way to create constraints. Imagine you have two labels, `bottomLabel` and `topLabel`. You'd like to position `bottomLabel` right below `topLabel` with 8 points of spacing between them. Prior to iOS 9, you'd have used the following code to create the constraint:

```swift
let constraint = NSLayoutConstraint(
    item: topLabel,
    attribute: .Bottom,
    relatedBy: .Equal,
    toItem: bottomLabel,
    attribute: .Top,
    multiplier: 1,
    constant: 8
)
```

Create a constraint in which the topLabel's `.Bottom` is `.Equal` to the bottomLabel's `.Top`, plus 8. The previous sentence contained far fewer characters than the code above, so wouldn't it be nice to have more concise code?

Layout anchors allow you to do exactly that: 

```swift
let constraint = topLabel.bottomAnchor.constraintEqualToAnchor(
  bottomLabel.topAnchor, constant: 8)
```

This achieves exactly the same result. How does it work? A view now has a layout anchor object representing the `.Bottom` attribute, and that anchor object can create constraints relating to other layout anchors. 

That's all there is to it! `UIView` now has a `bottomAnchor` property, as well as other anchors that correspond to other `NSLayoutAttributes`. So for `.Bottom` there is `bottomAnchor`, for `.Width` there is `widthAnchor`, for `.CenterX` there is `centerXAnchor` etc.

They are all subclasses of `NSLayoutAnchor`, which has a number of methods for creating constraints relating to other anchors. As well as the method above, which takes a constant, there is a version with no constant:

```swift
let constraint = topLabel.bottomAnchor.constraintEqualToAnchor(
  bottomLabel.topAnchor)
```

Now that's a much more expressive and concise way to create a constraint!

>**Note:** A view doesn't have an anchor property for every possible layout attribute. Any of the attributes relating to the margins, such as `.TopMargin`, are not available directly. `UIView` has a new property called `layoutMarginsGuide`, which is a `UILayoutGuide` (you'll learn about these in the next section). The layout guide has all the same anchor properties as the view, but now they relate to the view's margins, for example `.TopMargin` would be `layoutMarginsGuide.topAnchor`.

The method above creates an `EqualTo` constraint, but what if you wanted to create a `LessThanOrEqualTo` or a `GreaterThanOrEqualTo` constraint?

Using the old method you would just pass in `.GreaterThanOrEqual` or `.LessThanOrEqual` for the `relatedBy:` parameter, which takes an enum of type `NSLayoutRelation`:

```swift
let constraint = NSLayoutConstraint(
    ...
    relatedBy: .LessThanOrEqual, // or .GreaterThanOrEqual
    ...
)
```

`NSLayoutAnchor` contains methods to express those relations as well:

```swift
func constraintLessThanOrEqualToAnchor(_:constant:)
func constraintGreaterThanOrEqualToAnchor(_:constant:)
```

As well as the more concise variants in which you can leave off the `constant:` param when the value is 0:

```swift
func constraintLessThanOrEqualToAnchor(_:)
func constraintGreaterThanOrEqualToAnchor(_:)
```

In the old method, there is also a `multiplier` parameter:

```swift
let constraint = NSLayoutConstraint(
    ...
    multiplier: 1,
    ...
)
```

How would you include a multiplier if you needed to? If you look at the documentation for `NSLayoutAnchor`, you won't find any methods that contain a `multiplier` parameter.

[TODO: "Confused look" humor]

But `NSLayoutAnchor` _does_ have a subclass called `NSLayoutDimension` that has the following methods:

```swift
func constraintEqualToConstant(_:)
func constraintEqualToAnchor(_:multiplier:)
func constraintEqualToAnchor(_:multiplier:constant:)
```

As well as the as the `LessThanOrEqual` and `GreaterThanOrEqual` variants:

```swift
func constraint[Less|Greater]ThanOrEqualToConstant(_:)
func constraint[Less|Greater]ThanOrEqualToAnchor(_:multiplier:)
func constraint[Less|Greater]ThanOrEqualToAnchor(_:multiplier:constant:)
```

So what kind of anchor is `NSLayoutDimension` used for? Think about in what case you would actually use a multiplier other than 1. This would be when you wanted to add a proportional constraint between the width or height of one view to the width or height of another view.

And so the only anchors that are of type `NSLayoutDimension` are `heightAnchor` and `widthAnchor`. This provides you with additional type safety since you can't accidentally use a multiplier when it doesn't make sense. Since the multiplier based methods don't exist anything other than `widthAnchor` and `heightAnchor`, Xcode won't even suggest them to you. 

You get additional type safety benefits from layout anchors as well - as well as `NSLayoutDimension`, the other anchors in a view will be either `NSLayoutXAxisAnchor` or `NSLayoutYAxisAnchor` objects, depending on the anchor. This can prevent you attempting to pin the top of one view to the leading edge of another, for example. 

The `constraint[Equal|LessThanOrEqual|GreaterThanOrEqual]ToAnchor` family of methods are actually generic methods that, when called from an object of type `NSLayoutXAxisAnchor` will only take a parameter of type `NSLayoutXAxisAnchor`, and when called from an object of type `NSLayoutYAxisAnchor` will only take in a parameter of type `NSLayoutYAxisAnchor`.

This type checking hasn't made its way into Swift yet, but it does currently work with Objective-C:

![bordered width=99%](images/26-xAnchor-and-yAnchor-incompatibility_632x60.png)

With Swift, you'll still get a crash at runtime with the message "Invalid pairing of layout attributes" so you'll know pretty soon if you've made a mistake.

In Swift, you'll still get an error if you try to constrain an `NSLayoutDimension` anchor with a different type of anchor, for example, a `widthAnchor` with a `topAnchor`:

![bordered width=99%](images/27-widthAnchor-and-topAnchor-compile-error_585x76.png)

To summarise, layout anchors are a quick way of making constraints between different attributes of a view. There are three different subclasses of `NSLayoutAnchor`, and you can't (either because the compiler won't let you, or it just doesn't make sense) create constraints between the different types. You have:

- `NSLayoutXAxisAnchor` for leading, trailing, left, right or center X anchors
- `NSLayoutYAxisAnchor` for top, bottom and center Y anchors
- `NSLayoutDimension` for width and height

Whew, that was a lot to cover. Don't worry, the next section on layout guides will be much shorter. :] Then you'll dive back into the code and fix that very first alignment bug.

## Layout Guides

A layout guide lets you position views when you'd previously need to use a dummy view. For example, you might use spacer views between buttons to space them equally, or you might use a container view to collectively align two labels. Think of a layout guide as defining a rectangular region or a frame in your view hierarchy, the edges of which you can use for alignment.

Layout guides don't enable any new functionality but do allow you to solve these problems in a much more lightweight manner. Creating and adding a view has a cost, even if it's never drawn. 

You can add constraints to a `UILayoutGuide` in the same way that you can to a `UIView` since a layout guide has all of the same layout anchors that a view has (except for `firstBaselineAnchor` and `lastBaselineAnchor`).

It's time to dive back into the project and fix that alignment bug with a layout guide that you'll constrain by using layout anchors.

### Fixing the Alignment Bug

To recap, there were a few labels were not centered vertically in the cell:

![bordered width=32%](images/28-recap-of-alignment-issue_750x534.png)

This is because the current constraint specifies that the top of the name label should be a fixed distance from the top margin of the cell's contentView:

![bordered width=80%](images/29-the-incorrect-constraint_662x250.png).

This would have worked if the name label was always on a single line, but for some longer names the label spans two lines.

Your task is to properly center both labels. Prior to iOS 9 you'd have accomplished this by adding both labels into a container view, and then you would have added a constraint to center the container view vertically within the cell. The only purpose of this dummy container view would be for the collective alignment of the two labels. But now you know that you can use a layout guide instead.

It's currently only possible to add a layout guide in code. So open **VacationSpotCell.swift** and add the following code to `awakeFromNib()`:

```swift
// 1
let layoutGuide = UILayoutGuide()
contentView.addLayoutGuide(layoutGuide)

// 2
let topConstraint = layoutGuide.topAnchor
  .constraintEqualToAnchor(nameLabel.topAnchor)

// 3
let bottomConstraint = layoutGuide.bottomAnchor
  .constraintEqualToAnchor(locationNameLabel.bottomAnchor)

// 4
let centeringConstraint = layoutGuide.centerYAnchor
  .constraintEqualToAnchor(contentView.centerYAnchor)

// 5
NSLayoutConstraint.activateConstraints(
  [topConstraint, bottomConstraint, centeringConstraint])
```

Here is what is happening in code you just added:

1. You create the `layoutGuide` and use `addLayoutGuide(_:)` to add it to the cell's `contentView`.
2. You pin the top of the layout guide to the top of the `nameLabel`.
3. You pin the bottom of the layout guide to the bottom of the `locationNameLabel`.
4. You add a constraint to center the layout guide vertically within the `contentView`.
5. You activate the constraints.

>**Note**: Using the `activateConstraints(_:)` method on UIView is the recommended way of adding constraints in iOS 8 onwards, instead of using `addConstraints(_:)`.

Build and run, you should see the following:
![bordered iphone](images/30-before-making-constraint-placeholder_750x1334.png)

The labels are centered, but now any labels that were previously spanning two lines are now truncated to a single line. This is because of the constraint that is still in the storyboard. So in order to satisfy that constraint and the newly added centering constraint, the label had to compress its content. You can't remove the constraint completely from the storyboard since you would get a missing constraint error:

![bordered width=96%](images/31-missing-constraint-error_674x174.png)

You will instead set it as a placeholder constraint. This is your way of telling Xcode that you will leave this constraint here for the storyboard, but that you want it removed at runtime since you will take care of this in code.

Open **Main.storyboard**, and in the **Vacation Spots Scene** click on **&lt;nameLabel>** to select it, and then click on the constraint connecting the top of the label to the top margin of the cell. Place a checkmark next to **Remove at build time**:

![bordered width=90%](images/32-remove-at-build-time_640x279.png)

Build and run, and you'll see the labels centered correctly!

![bordered iphone](images/33-table-view-is-now-correct_750x1334.png)


## Where To Go From Here?

In this chapter, you started learning about stack views and also learned about some of the new features in Auto Layout, such as layout anchors and layout guides.

At this point, you'll want to maintain the momentum and proceed to the next chapter where you'll continue to learn about stack views in depth. At the end of the next chapter, there will be some additional resources that you can use to continue learning, but for now, all you have to do is turn to the next page!
