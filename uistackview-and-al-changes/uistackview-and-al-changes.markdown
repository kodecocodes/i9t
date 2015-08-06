# Chapter 6: UIStackView and Auto Layout changes

We've all been there. That awkward moment when you need to add or remove views at runtime and for those other views to reposition themselves automatically.

Perhaps you took the route of adding outlets to constraints in your storyboard so you could activate or deactivate certain ones. Or, you trudged through the process of bringing in a third-party library. 

Or, maybe you gave up on getting help and just decided that it's easier to DIY it with code.

Perhaps you're one of the lucky ones, and your view hierarchy didn't have to change at runtime.  But there were new requirements, and now you had to squeeze this one obnoxious view into your storyboard. 

I bet you've found yourself clearing all constraints and re-adding them from scratch because it was easier than breaking out your virtual scalpel and performing painstaking _constraints-surgery_.

With the introduction of `UIStackView`, the above tasks become trivial. No more will you find yourself lying awake at night wondering how to wrangle your runtime views!

![bordered width=50%](images/more_time_for_sleep.png)

Stack views provide a way to horizontally or vertically position a series of views. By simply configuring alignment, distribution and spacing, and you can make the views gel together. More precisely, you can define _how_ the contained views adjust themselves to the available space.

In this chapter, you'll learn about stack views and about some of the other features introduced in Auto Layout this year, such as layout anchors and layout guides.

> **Note**: This chapter assumes basic familiarity with Auto Layout. If you're in new territory, do a primer on the subject by working through an Auto Layout tutorials or two on raywenderlich.com, or stream the Auto Layout video series. For an in-depth look, see the "Auto Layout" chapters in the 3rd edition of _iOS 6 by Tutorials_.

## Getting started

In this chapter, you'll start working on an app called **Vacation Spots**, which will also be your guinea pig for chapter 7. It's a simple app that shows you a list of places to get away from it all. Hey, I bet you're ready for a vacation after working with constraints, right? 

Don't pack the bags just yet, because there's a few issues you'll need to fix by using stack views, but in a much simpler way than if you were using Auto Layout alone. 

Towards the end of this chapter, you'll also fix another issue with the use of layout guides and layout anchors.

For a teaser, here's the finished version of the app :

![height=41%](images/01-full-app_2318x1344.png)

Open **VacationSpots-Starter**, and run it on the **iPhone 6 Simulator**. The first thing you'll notice is the name and location label are off center.

![bordered width=30%](images/02-alignment-issue-on-table-view_750x534.png)

Both the name and location label for a vacation spot should be centered vertically (as a group) so there is an equal amount of space above the name label, and below the location label -- this is a fix with a layout guide that you'll learn towards the end of the chapter by using a layout guide. For now, go to the info view for London by tapping on the **London** cell.

At first glance, the view may seem okay, but look deeper.

1. Focus on the row of buttons at the bottom of the view. They are currently positioned with a fixed amount of space between themselves, so they don't adapt to the screen width. To see the problem in full glory, temporarily rotate the simulator to landscape orientation by pressing **Command-left**.

![bordered iphone-landscape](images/03-issues-visible-in-landscape-view_1334x750.png)

2. Tap on the **Hide** button next to the **Weather:** label. It successfully hides the text, but it doesn't reposition the **What to See** section below, leaving a block of blank space.

![bordered width=32%](images/04-hide-weather-issue_750x820.png)

3. The ordering of the sections can be improved. It would me more logical if **What to See** was positioned right after **Why Visit**, instead of having the **Weather** section in between them.

4. The bottom row of buttons is a bit too close to the bottom edge of the view in landscape mode. It would be better if you could decrease the spacing between the different sections -- but only in landscape mode i.e when the vertical size class is compact.

Now you know the what's and whys, so it's time to start planning your next vacation even as you enter the wonderful world of UIStackView.

Open **Main.storyboard** and take a look at the **Spot Info View Controller** scene. And boom! Have some color with your stack view.

TODO:update screenshot
![bordered width=40%](images/05-colorful-scene-in-storyboard_504x636.png)

These labels and buttons have various background colors set on them; they're simply visual aids to help show how various properties of a stack view affect the frame of its embedded views. 

Don't get too attached to the pretty colors. They're set only for the purpose of working with the storyboard and will vanish at runtime.

You don't need to do this now, but if at any point you'd actually like to see the background colors while running the app, go ahead and temporarily comment out the following lines in the `viewDidLoad()` inside `SpotInfoViewController`.

```swift
// Clear background colors from labels and buttons
for view in backgroundColoredViews {
  view.backgroundColor = UIColor.clearColor()
}
```

Also, any outlet-connected labels have placeholder text that's set to the name of the outlet variable to which they are connected. This makes it a bit easier to tell which labels will have their text updated at runtime. For example, the label with text **&lt;whyVisitLabel>** is connected to `@IBOutlet weak var whyVisitLabel: UILabel!`. 

Another thing to note is that the scenes in the storyboard are not the default 600 x 600 squares that you get when using size classes. 

Size classes are still enabled, but the size of the initial Navigation Controller has been set to **iPhone 4-inch** under the **Simulated Metrics** section in the **Attributes inspector**. This just makes it a bit easier to work with the storyboard -- and it helps make the screencaps fit in this book.

![bordered width=99%](images/06-simulated-metrics-iphone-4-inch_640x140.png)

## Your first stack view

First thing on your list of fixes is using a stack view to perfect spacing between the buttons on the bottom row. A stack view can distribute its views along its axis in various ways, and one of the go-tos is with an equal amount of spacing between each view.

Fortunately for you, embedding existing views into a new stack view is not rocket science. First, select all of the buttons at the bottom of the **Spot Info View Controller** scene by **clicking** on one, then **Command-click** on the other two:

TODO: screenshot
![bordered width=70%](images/07-drag-select-bottom-row-of-buttons_480x117.png)

If the outline view is not already open, go ahead and open it by using the **Show Document Outline** button at the bottom left of the storyboard canvas:

![bordered width=20%](images/08-document-outline-button_120x40.png)

Verify that all buttons are selected by checking them in the outline view:

![bordered width=40%](images/09-verify-button-selection_357x94.png)

In case they are not all selected, you can also **Command-click** on each button in the outline view to select them.

Once selected, click on the new **Stack** button in the Auto Layout toolbar at the bottom right of the storyboard canvas:

![bordered width=20%](images/10-stack_button_outlined_148x52.png)

The buttons will become embedded in a new stack view:

![bordered width=96%](images/11-bottom-row-is-now-in-stack-view_640x100.png)

The buttons are now flush with each other -- you'll that fix shortly. 

While the stack view takes care of positioning the buttons, you still need to add Auto Layout constraints to position the stack view itself.

When you embed a view in a stack view, any constraints to other views are removed. For example, prior to embedding the buttons in a stack view, the top of the **Submit Rating** button had a vertical spacing constraint connecting it to the bottom of the **Rating:** label:

![bordered width=40%](images/12-prior-constraint_354x95.png)

Click on the **Submit Rating** button to see it no longer has any constraints attached to it:

![bordered width=50%](images/13-no-more-constraints_366x99.png)

Another way to verify the constraints are gone is by looking at the **Size inspector** (⌥⌘5):

![bordered width=90%](images/14-size-inspector_621x84.png)

Select the stack view itself to be able to add constraints to position it. However, selecting a stack view in the storyboard can get tricky if its views completely fill the stack view.

So a good workaround is to select the stack view in the outline view:

![bordered width=90%](images/15-document-outline-selection_640x72.png)

Another trick is to hold **Shift** and **Right-click** on any of the views in the stack view, or **Control-Shift-click** if you're using a trackpad. You'll get a context menu that shows the view hierarchy at the location you clicked, and you simply select the stack view by clicking on it in the menu.

For now, select the stack view using the **Shift-Right-click** method:

[TODO: screenshot]
![bordered width=40%](images/16-view-hierarchy-menu_384x212.png)

Now, click the **Pin** button on the Auto Layout toolbar to add constraints to it:

![bordered width=20%](images/17-pin-button_142x57.png)

Set the following constraints to the edges of your stack view:

- Top: 20
- Left: 0
- Right: 0
- Bottom: 0

Double-check the numbers for the top, left, right and bottom and that the **I-beams** are selected. You'll always set constraints to margins, so make sure that **Constrain to margins** is checked as well. Then click on **Add 4 Constraints**:

![bordered width=30%](images/18-bottom-stack-view-constraints.png)

And now the stack view is now the correct size, but it has stretched the first button to fill in extra space:

![bordered width=50%](images/19-bottom-stack-view-with-distribution-fill2_384x103.png)

The property that determines how a stack view lays out its views along its axis is its `distribution`. Currently, it's set to `Fill`, which means the contained views will completely fill the stack view along its axis. To accomplish this, the stack view will only expand one of its views to fill that extra space; specifically, it expands the view with the lowest horizontal content hugging priority, or if all of the priorities are equal, it expands the first view.

However, you're not looking for the buttons to fill the stack view completely -- you're after equal spacing.

Make sure the stack view is still selected, and go to the **Attributes inspector**. Change the **Distribution** from **Fill** to **Equal Spacing**:

![bordered width=90%](images/20-equal-spacing_607x148.png)

Now build and run, tap on any cell, and rotate the simulator (⌘→). You'll see that the bottom buttons now space themselves equally!

![bordered iphone-landscape](images/21-now-buttons-are-equally-spaced_1334x750.png)
 
### Consider the alternatives

Now that you've had your first taste of the ease of working with stack views, think about how you'd solve this problem without using them:
- You would have added dummy spacer views, one between each button pair of buttons. 
- You'd select all of the spacer views and give them equal width constraints. 
- Then you'd pin each spacer view to the buttons on either side of it. 
- You'd also need to add constraints for the heights and vertical positions of the spacer views in the superview. 
- Alternatively, you could pin the top and bottom edges to the adjacent buttons.

It would have looked something like the following. For visibility, the spacer views have a light gray background:

![bordered width=50%](images/22-alternate-solution-1_346x76.png)

### But I'm an Auto Layout master

Perhaps you're a seasoned Auto Layout veteran, and adding constraints like these is a piece of cake. And you might not feel like you've gained much by using a stack view. 

You'd still have optimized your layout by not having to include unnecessary spacer views, but even if you ignore this benefit, think about the long term. 

What happens when you need to add a new button? Oh, right, you could just add a new button because it's not too difficult for a master like you to re-do all the constraints. But doesn't dragging and dropping the additional button into place, and having the stack view take care of the positioning sound better?

![bordered width=50%](images/stack_views_do_laundry.png)

There's more. What if you needed to conditionally hide and show one of the buttons and reposition all of the remaining ones at runtime? If you stuck to the old ways, you'd have to manually remove and re-add constraints in code as well as remove and add back the adjacent spacer view. 

![bordered width=50%](images/me_and_auto_layout.png)

And what if the requirement specified that more than one button could be removed and re-added at any time? At this point, you might as well do everything in code.

![bordered width=50%](images/code_it_all.png)

### Stack views are just better

In order to hide a view within a stack view, all you have to do is set the contained view's `hidden` property to `true` and the stack view handles the rest. This is how you'll fix the spacing under the **Weather:** label when the user hides the text below it.

![bordered width=50%](images/stack_views_look_good.png)

But that's something for the next chapter, where you'll dive deeper into stack views. For now, you'll take a quick detour to learn about some of the other new Auto Layout updates in iOS 9.

Stack views are by far the biggest feature introduced to Auto Layout with iOS 9, but there are also other features that improve how you do things. Two of the most interesting are **layout anchors** and **layout guides**, represented by the new `NSLayoutAnchor` and `UILayoutGuide` classes. 

## Layout anchors

Layout anchors are a lovely new way to create constraints. 

Imagine you have two labels, `bottomLabel` and `topLabel`. You'd like to position `bottomLabel` right below `topLabel` with 8 points of spacing between them. Prior to iOS 9, you'd use the following code to create the constraint:

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

Create a constraint in which the topLabel's `.Bottom` is `.Equal` to the bottomLabel's `.Top`, plus 8. 

Sheesh! Even the explanation contained far fewer characters than the code itself, so surely there's a more concise way?

Layout anchors do exactly that: 

```swift
let constraint = topLabel.bottomAnchor.constraintEqualToAnchor(
  bottomLabel.topAnchor, constant: 8)
```

This achieves exactly the same result. But how? A view now has a layout anchor object representing the `.Bottom` attribute, and that anchor object can create constraints relating to other layout anchors. 

That's all there is to it! `UIView` now has a `bottomAnchor` property, as well as other anchors that correspond to other `NSLayoutAttributes`. So for `.Bottom` there is `bottomAnchor`, for `.Width` there is `widthAnchor`, for `.CenterX` there is `centerXAnchor` etc.

They're all subclasses of `NSLayoutAnchor`, which has a number of methods for creating constraints relating to other anchors. As well as the method above, which takes a constant, there is a version with no constant:

```swift
let constraint = topLabel.bottomAnchor.constraintEqualToAnchor(
  bottomLabel.topAnchor)
```

Now that's a much more expressive and concise way to create a constraint!

>**Note:** A view doesn't have an anchor property for every possible layout attribute. Any of the attributes relating to the margins, such as `.TopMargin`, are not available directly. `UIView` has a new property called `layoutMarginsGuide`, which is a `UILayoutGuide` (you'll learn about these in the next section). The layout guide has all the same anchor properties as the view, but now they relate to the view's margins, for example `.TopMargin` would be `layoutMarginsGuide.topAnchor`.

### Old vs. new

The method above creates an `EqualTo` constraint, but what if you wanted to create a `LessThanOrEqualTo` or a `GreaterThanOrEqualTo` constraint?

Using the old method, you'd just pass in `.GreaterThanOrEqual` or `.LessThanOrEqual` for the `relatedBy:` parameter, which takes an enum of type `NSLayoutRelation`:

```swift
let constraint = NSLayoutConstraint(
    ...
    relatedBy: .LessThanOrEqual, // or .GreaterThanOrEqual
    ...
)
```

`NSLayoutAnchor` contains methods to express those relations:

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
### Including multipliers
So, how do you include a multiplier if you need to? If you look at the documentation for `NSLayoutAnchor`, you won't find any methods that contain a `multiplier` parameter.

![bordered width=50%](images/some_riddle.png)

But `NSLayoutAnchor` _does_ have a subclass called `NSLayoutDimension` that has the following methods:

```swift
func constraintEqualToConstant(_:)
func constraintEqualToAnchor(_:multiplier:)
func constraintEqualToAnchor(_:multiplier:constant:)
```

It also has the `LessThanOrEqual` and `GreaterThanOrEqual` variants:

```swift
func constraint[Less|Greater]ThanOrEqualToConstant(_:)
func constraint[Less|Greater]ThanOrEqualToAnchor(_:multiplier:)
func constraint[Less|Greater]ThanOrEqualToAnchor(_:multiplier:constant:)
```

### Layout dimensions and type protections

Okay, so now move your mind back to the `NSLayoutDimension` and think about the types of dimensions you'd use it for. 

When would you would actually use a multiplier other than 1? Here's an idea: When you want to add a proportional constraint between the width or height of one view to the width or height of another view.

[Author TODO: This is a bit hard to follow since it's been theory for a while. This seems an important point worth emphasizing. Can you think of a real-world scenario where you'd add a proportional constraint? I suggest adding it like this: "...height of a another view, like _insert scenario here_".]

Effectively, the only anchors that are of type `NSLayoutDimension` are `heightAnchor` and `widthAnchor`. 

Remember, you can't accidentally use a multiplier where it doesn't make sense -- since the multiplier-based methods don't exist with anything other than `widthAnchor` and `heightAnchor`, Xcode won't even suggest them to you. 

It gets better. Because of the additional type safety benefits offered by layout anchors, as well as `NSLayoutDimension`, the other anchors in a view will be either `NSLayoutXAxisAnchor` or `NSLayoutYAxisAnchor` objects, depending on the anchor. 

This intelligent design prevents you from mistakes such as pinning the top of one view to the leading edge of another. 

The `constraint[Equal|LessThanOrEqual|GreaterThanOrEqual]ToAnchor` family of methods are actually generic methods that, when called from an object of type, `NSLayoutXAxisAnchor`, will only take a parameter of type `NSLayoutXAxisAnchor`. When called from an object of type, `NSLayoutYAxisAnchor` will only take in a parameter of type `NSLayoutYAxisAnchor`.

Though this type checking hasn't yet made its way into Swift, it currently works with Objective-C:

![bordered width=99%](images/26-xAnchor-and-yAnchor-incompatibility_632x60.png)

At the time of writing, Swift crashes at runtime with the message "Invalid pairing of layout attributes", so you'll know pretty quickly if you've made a mistake.

You'll also still get an error in Swift if you try to constrain an `NSLayoutDimension` anchor with a different type of anchor, for example, a `widthAnchor` with a `topAnchor`:

![bordered width=99%](images/27-widthAnchor-and-topAnchor-compile-error_585x76.png)

To summarize:

- Layout anchors are a quick way of making constraints between different attributes of a view. 
- There are three different subclasses of `NSLayoutAnchor`
- You can't create constraints between the different types, either because the compiler won't let you, or it just doesn't make sense. 

You have these options to work with: [FPE TODO: feel free to replace "options" with a more precise term, e.g. functions/properties/etc.]

- `NSLayoutXAxisAnchor` for leading, trailing, left, right or center X anchors
- `NSLayoutYAxisAnchor` for top, bottom and center Y anchors
- `NSLayoutDimension` for width and height

Whew, that was a lot to cover. You're probably wondering if you'll ever fix that alignment bug. Of course you will!  But first, read through the next section on layout guides -- I promise it's much shorter. :] 

After that, you'll be fully prepared to dive back into the code and fix that bothersome alignment bug.

## Layout guides

A layout guide is the new way of positioning views. The old way was to use a dummy view. For example, you might have used spacer views between buttons to space them equally, or a container view to collectively align two labels. But creating and adding a view has a cost, even if it's never drawn. 

Think of a layout guide as defining a rectangular region or a frame in your view hierarchy, the edges of which you can use for alignment.

Layout guides don't enable any new functionality, but they do allow you to address these problems with a lightweight solution. 

You add constraints to a `UILayoutGuide` in the same way that you add them to a `UIView`, because a layout guide has _all of the same_ layout anchors that a view has -- except for `firstBaselineAnchor` and `lastBaselineAnchor`.

Okay, now it's time to dive back into the project and fix that alignment bug.

## Fixing the alignment bug

You'll remember that the whole reason for the dive into layout guides and anchors was so that you could vertically center some labels in the cell by using the new tools available in iOS 9:

![bordered width=32%](images/28-recap-of-alignment-issue_750x534.png)

They're out of line because the current constraint specifies that the top of the name label should be a fixed distance from the top margin of the cell's `contentView`:

![bordered width=80%](images/29-the-incorrect-constraint_662x250.png)

 If the name label was always on a single line, the current config would have been fine. But this app has labels that span two lines.

Prior to iOS 9, you'd have centered everything by putting both labels into a container view, and then you would have added a constraint to center the container view vertically within the cell. The only purpose of creating this dummy container view was for the collective alignment of the two labels. 

But now you know that you can save yourself some hassle by using a layout guide instead.

Currently, it's only possible to add a layout guide in code. So open **VacationSpotCell.swift** and add the following code to `awakeFromNib()`:

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

Here's the breakdown of the code you just added:

1. You create the `layoutGuide` and use `addLayoutGuide(_:)` to add it to the cell's `contentView`.
2. You pin the top of the layout guide to the top of the `nameLabel`.
3. You pin the bottom of the layout guide to the bottom of the `locationNameLabel`.
4. You add a constraint to center the layout guide vertically within the `contentView`.
5. You activate the constraints.

>**Note**: Using the `activateConstraints(_:)` method on UIView is the recommended way of adding constraints in iOS 8 onwards, as opposed to the old `addConstraints(_:)`.

Build and run, you should see the following:
![bordered iphone](images/30-before-making-constraint-placeholder_750x1334.png)

### Handling the truncation

The labels are centered, but now those labels that previously spanned two lines are truncated to a single line, and that's because of the constraint that's still in the storyboard. 

So, in order to satisfy that constraint as well as the newly added centering constraint, the label had to compress its content. Don't even try removing the constraint from the storyboard because you'll just get a missing constraint error:

![bordered width=96%](images/31-missing-constraint-error_674x174.png)

Instead, simply set it as a placeholder constraint. This is a trick to tell Xcode that you'll leave this constraint here for the storyboard, but you want it removed at runtime since you've got it covered in code.

Open **Main.storyboard**, and in the **Vacation Spots scene** click on **&lt;nameLabel>** to select it, and then click on the constraint connecting the top of the label to the top margin of the cell. Place a checkmark next to **Remove at build time**:

![bordered width=90%](images/32-remove-at-build-time_640x279.png)

Build and run, and you'll see the labels centered correctly!

![bordered iphone](images/33-table-view-is-now-correct_750x1334.png)


## Where to go from here?

In this chapter, you started learning about stack views and also learned about some of the new features in Auto Layout, such as layout anchors and layout guides.

At this point, you've just scratched the surface. Keep up the momentum and proceed to the next chapter, where you'll continue to learn about stack views in depth. 

At the end of the next chapter, there will be some additional resources you can use to further your learning, but for now, all you have to do is turn to the next page!
