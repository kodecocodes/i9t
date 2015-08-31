# Chapter 6: UIStackView and Auto Layout changes

We've all been there. That annoying moment when you needed to add or remove a view at runtime and wished that other views knew how to reposition themselves automatically.

Perhaps you took the route of adding outlets to constraints in your storyboard so you could activate or deactivate certain ones. Maybe you used a third party library, or maybe you decided it's easiest to DIY it with code.

Perhaps you're one of the lucky ones, and your view hierarchy didn't have to change at runtime. But there were new requirements, and now you had to squeeze this one obnoxious view into your storyboard.

I bet you've found yourself clearing all constraints and re-adding them from scratch because it was easier than breaking out your virtual scalpel and performing painstaking _constraints-surgery_.

With the introduction of `UIStackView`, the above tasks become trivial. No more will you find yourself lying awake at night wondering how to wrangle your views!
![bordered width=35%](images/01-more_time_for_sleep_367x310.png)

Stack views provide a way to horizontally or vertically position a series of views. By configuring a few simple properties such as alignment, distribution, and spacing, you can define how the contained views adjust themselves to the available space.

In this chapter, you'll learn about stack views and about some of the other Auto Layout upgrades introduced this year, such as layout anchors and layout guides.

> **Note**: This chapter assumes basic familiarity with Auto Layout. If you're in new territory, you can do a primer on the subject by working through an Auto Layout tutorial or two on [raywenderlich.com](http://www.raywenderlich.com/83129/beginning-auto-layout-tutorial-swift-part-1). For an in-depth look, see the "Auto Layout" chapters in the 3rd edition of _iOS 6 by Tutorials_.

## Getting started

In this chapter, you'll start working on an app called **Vacation Spots**, which will also be your guinea pig for chapter 7. It's a simple app that shows you a list of places to get away from it all. Hey, I bet you're ready for a vacation after working with constraints, right?

Don't pack the bags just yet, because there are a few issues you'll fix by using stack views, and in a much simpler way than if you were using Auto Layout alone.

Towards the end of this chapter, you'll also fix another issue with the use of layout guides and layout anchors.

Open **VacationSpots-Starter**, and run it on the **iPhone 6 Simulator**. The first thing you'll notice is the name and location label in a few cells are off center.

![bordered iphone](images/02-alignment-issue-on-table-view_750x1334.png)

Both labels should be centered vertically (as a group) so there is an equal amount of space above the name label, and below the location label – you'll fix this towards the end of the chapter with a layout guide. For now, go to the info view for London by tapping on the **London** cell.

At first glance, the view may seem okay, but first impressions can be misleading.

1. Focus on the row of buttons at the bottom of the view. They are currently positioned with a fixed amount of space between themselves, so they don't adapt to the screen width. To see the problem in full glory, temporarily rotate the simulator to landscape orientation by pressing **Command-left**.

![bordered iphone-landscape](images/03-issues-visible-in-landscape-view_1334x750.png)

2. Tap on the **Hide** button next to **WEATHER**. It successfully hides the text, but it doesn't reposition the section below it, leaving a block of blank space.

![bordered width=31%](images/04-hide-weather-issue_750x1334.png)

3. The ordering of the sections can be improved. It would be more logical if the **WHAT TO SEE** section was positioned right after **WHY VISIT**, instead of having **WEATHER** in between them.

4. The bottom row of buttons is a bit too close to the bottom edge of the view in landscape mode. It would be better if you could decrease the spacing between the different sections – but only in landscape mode, i.e. when the vertical size class is compact.

You now know the what the problems are, and why they exist, so it's time to start planning your next vacation, as you enter the wonderful world of `UIStackView`.

Open **Main.storyboard** and take a look at the **Spot Info View Controller** scene. And boom! Have some color with your stack view.
![bordered width=40%](images/05-colorful-scene-in-storyboard_504x636.png)

These labels and buttons have various background colors set on them; they're simply visual aids to help show how changing various properties of a stack view will affect the frames of its embedded views.

Don't get too attached to the pretty colors. They're set only for the purpose of working with the storyboard and will vanish at runtime.

You don't need to do this now, but if at any point you'd actually like to see the background colors while running the app, you can temporarily comment out the following lines in `viewDidLoad()` inside `SpotInfoViewController`.

```swift
// Clear background colors from labels and buttons
for view in backgroundColoredViews {
  view.backgroundColor = UIColor.clearColor()
}
```

Also, any outlet-connected labels have placeholder text that's set to the name of the outlet variable to which they are connected. This makes it a bit easier to tell which labels will have their text updated at runtime. For example, the label with text **&lt;whyVisitLabel>** is connected to:

```swift
@IBOutlet weak var whyVisitLabel: UILabel!
```

Another thing to note is that the scenes in the storyboard are not the default 600 x 600 squares that you get when using size classes.

Size classes are still enabled, but the size of the initial Navigation Controller has been set to **iPhone 4-inch** under the **Simulated Metrics** section in the **Attributes inspector**. This just makes it a bit easier to work with the storyboard; the simulated metrics property has no effect at runtime — the canvas will resize for different devices.
![bordered width=96%](images/06-simulated-metrics-iphone-4-inch_639x173.png)

## Your first stack view

First on your list of fixes is using a stack view to maintain equal spacing between the buttons on the bottom row. A stack view can distribute its views along its axis in various ways, one of which is with an equal amount of spacing between each view.

Fortunately, embedding existing views into a new stack view is not rocket science. First, select all of the buttons at the bottom of the **Spot Info View Controller** scene by **clicking** on one, then **Command-click** on the other two:
![bordered width=63%](images/07-select-bottom-row-of-buttons_420x80.png)

If the outline view isn't already open, go ahead and open it by using the **Show Document Outline** button at the bottom left of the storyboard canvas:
![bordered width=20%](images/08-document-outline-button_120x40.png)

Verify that all 3 buttons are selected by checking them in the outline view:
![bordered width=54%](images/09-verify-button-selection_360x90.png)

In case they aren't all selected, you can also **Command-click** on each button in the outline view to select them.

Once selected, click on the new **Stack** button in the Auto Layout toolbar at the bottom right of the storyboard canvas:
![bordered width=20%](images/10-stack_button_outlined_148x52.png)

The buttons will become embedded in a new stack view:
![bordered width=96%](images/11-bottom-row-is-now-in-stack-view_640x100.png)

The buttons are now flush with each other – you'll that fix shortly.

While the stack view takes care of positioning the buttons, you still need to add Auto Layout constraints to position the stack view itself.

When you embed a view in a stack view, any constraints to other views are removed. For example, prior to embedding the buttons in a stack view, the top of the **Submit Rating** button had a vertical spacing constraint connecting it to the bottom of the **Rating:** label:
![bordered width=63%](images/12-prior-constraint_420x90.png)

Click on the **Submit Rating** button to see that it no longer has any constraints attached to it:
![bordered width=60%](images/13-no-more-constraints_400x80.png)

Another way to verify that the constraints are gone is by looking at the **Size inspector** (⌥⌘5):
![bordered width=96%](images/14-check-size-inspector_640x80.png)

In order to add constraints to position the stack view itself, you'll first need to select it. Selecting a stack view in the storyboard can get tricky if its views completely fill the stack view.

One simple way is to select the stack view in the outline view:
![bordered width=99%](images/15-stack-view-document-outline-selection_660x80.png)

Another trick is to hold **Shift** and **Right-click** on any of the views in the stack view, or **Control-Shift-click** if you're using a trackpad. You'll get a context menu that shows the view hierarchy at the location you clicked, and you simply select the stack view by clicking on it in the menu.

For now, select the stack view using the **Shift-Right-click** method:
![bordered width=40%](images/16-select-stack-view-in-view-hierarchy-menu_400x280.png)

Now, click the **Pin** button on the Auto Layout toolbar to add constraints to it:
![bordered width=20%](images/17-pin-button_142x57.png)

First add a check to **Constrain to margins**. Then add the following constraints to the edges of your stack view:

```bash
Top: 20, Leading: 0, Trailing: 0, Bottom: 0
```

Double-check the numbers for the top, leading, trailing, and bottom constraints and make sure that the **I-beams** are selected. Then click on **Add 4 Constraints**:
![bordered width=30%](images/18-bottom-stack-view-constraints_264x364.png)

Now the stack view is the correct size, but it has stretched the first button to fill in any extra space:
![bordered width=60%](images/19-first-button-is-stretched_400x80.png)

The property that determines how a stack view lays out its views along its axis is its `distribution` property. Currently, it's set to `Fill`, which means the contained views will completely fill the stack view along its axis. To accomplish this, the stack view will only expand one of its views to fill that extra space; specifically, it expands the view with the lowest horizontal content hugging priority, or if all of the priorities are equal, it expands the first view.

However, you're not looking for the buttons to fill the stack view completely – you want them to be equally spaced.

Make sure the stack view is still selected, and go to the **Attributes inspector**. Change the **Distribution** from **Fill** to **Equal Spacing**:
![bordered width=96%](images/20-change-distribution-to-equal-spacing_640x148.png)

Now build and run, tap on any cell, and rotate the simulator (⌘→). You'll see that the bottom buttons now space themselves equally!
![bordered iphone-landscape](images/21-now-buttons-are-equally-spaced_1334x750.png)

### Consider the alternatives

Now that you've had your first taste of the ease of working with stack views, think about how you'd solve this problem without using them:
- You would have added dummy spacer views, one between each button pair of buttons.
- You'd select all of the spacer views and give them equal width constraints.
- Then you'd pin each spacer view to the buttons on either side of it.
- You'd also need to add constraints for the heights and vertical positions of the spacer views in the superview, or alternatively, you could pin the top and bottom edges to the adjacent buttons.

It would have looked something like the following. For visibility in the screenshot, the spacer views have been given a light gray background:
![bordered width=50%](images/22-alternate-solution-1_346x76.png)

### But I'm an Auto Layout master

Perhaps you're a seasoned Auto Layout veteran, and adding constraints like these is a piece of cake. And you might not feel like you've gained much by using a stack view.

You'd still have optimized your layout by not having to include unnecessary spacer views, but even if you ignore this benefit, think about the long term.

What happens when you need to add a new button? Oh, right, you could just add a new button because it's not too difficult for an expert like you to re-do all the constraints. But doesn't dragging and dropping the additional button into place, and having the stack view take care of the positioning sound better?
![bordered width=35%](images/23-stack_views_do_laundry_353x278.png)

There's more. What if you needed to conditionally hide and show one of the buttons and reposition all of the remaining ones at runtime? If you stuck to the old ways, you'd have to manually remove and re-add constraints in code as well as remove and add back the adjacent spacer view.
![bordered width=35%](images/24-me_and_auto_layout_334x310.png)

And what if the requirement specified that more than one button could be removed and re-added at any time? At this point, you might as well do everything in code.
![bordered width=35%](images/25-code_it_all_281x278.png)

### Stack views are just better

In order to hide a view within a stack view, all you have to do is set the contained view's `hidden` property to `true` and the stack view handles the rest. This is how you'll fix the spacing under the **WEATHER** label when the user hides the text below it.
![bordered width=35%](images/26-stack_views_look_good_298x293.png)

But that's something for the next chapter, where you'll dive deeper into stack views. For now, you'll take a quick detour to learn about some of the other new Auto Layout updates in iOS 9.

Stack views are by far the biggest feature introduced to Auto Layout with iOS 9, but there are also other features that improve how you do things. Two of the most interesting are **layout anchors** and **layout guides**, represented by the new `NSLayoutAnchor` and `UILayoutGuide` classes.

## Layout anchors

Layout anchors provide a simplified way to create constraints.

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

This creates a constraint in which the topLabel's `.Bottom` is `.Equal` to the bottomLabel's `.Top`, plus 8.

Even the explanation contained far fewer characters than the code itself, and you're not even using Objective-C! Surely there's a more concise way to express this?

Layout anchors allow you to do exactly that:

```swift
let constraint = topLabel.bottomAnchor.constraintEqualToAnchor(
                 bottomLabel.topAnchor, constant: 8)
```

This achieves the same result. The view now has a layout anchor object representing the `.Bottom` attribute, and that anchor object can create constraints relating to other layout anchors.

That's all there is to it! `UIView` now has a `bottomAnchor` property, as well as other anchors that correspond to other `NSLayoutAttributes`. For example, for `.Width` it has `widthAnchor`, for `.CenterX` it has `centerXAnchor` etc.

They're all subclasses of `NSLayoutAnchor`, which has a number of methods for creating constraints relating to other anchors. In addition to the above method, there is also a convenience version for when the constant is 0:

```swift
let constraint = topLabel.bottomAnchor.constraintEqualToAnchor(
                 bottomLabel.topAnchor)
```

That's a much more expressive and concise way to create a constraint!

>**Note:** A view doesn't have an anchor property for every possible layout attribute. Any of the attributes relating to the margins, such as `.TopMargin`, or `.LeadingMargin` aren't available directly. `UIView` has a new property called `layoutMarginsGuide`, which is a `UILayoutGuide` (you'll learn about these in the next section). The layout guide has all the same anchor properties as the view, but now they relate to the view's margins, for example `.TopMargin` would be represented by `layoutMarginsGuide.topAnchor`.

### Non-equal constraints

The method above creates an `EqualTo` constraint, but what if you wanted to create a `LessThanOrEqualTo` or a `GreaterThanOrEqualTo` constraint?

Using the old method, you'd just pass in `.GreaterThanOrEqual` or `.LessThanOrEqual` for the `relatedBy:` parameter, which takes an enum of type `NSLayoutRelation`:

```swift
let constraint = NSLayoutConstraint(
  ...
  relatedBy: .LessThanOrEqual, // or .GreaterThanOrEqual
  ...
)
```

`NSLayoutAnchor` also contains methods to express those relations:

```swift
func constraintLessThanOrEqualToAnchor(_:constant:)
func constraintGreaterThanOrEqualToAnchor(_:constant:)
```

As well as the more concise variants in which you can leave off the `constant:` param when the value is 0:

```swift
func constraintLessThanOrEqualToAnchor(_:)
func constraintGreaterThanOrEqualToAnchor(_:)
```

### Including a multiplier

In the old method, there is also a `multiplier` parameter:

```swift
let constraint = NSLayoutConstraint(
  ...
  multiplier: 1,
  ...
)
```

So, how do you include a multiplier if you need to? If you look at the documentation for `NSLayoutAnchor`, you won't find any methods that contain a `multiplier` parameter.
![bordered width=35%](images/27-some_riddle_309x287.png)

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

When would you actually use a multiplier other than 1? Here's an idea: When you want to add a proportional constraint between the width or height of one view to the width or height of another view, like if you wanted the width of user's profile photo to be one-quarter that of its superview.

Effectively, the only anchors that are of type `NSLayoutDimension` are `heightAnchor` and `widthAnchor`.

This means that you can't accidentally use a multiplier where it doesn't make sense, and since the multiplier-based methods don't exist with anything other than `widthAnchor` and `heightAnchor`, Xcode won't even suggest them to you.

It gets better. `NSLayoutAnchor` has two additional subclasses — `NSLayoutXAxisAnchor` and `NSLayoutYAxisAnchor` — which represent anchors in the horizontal and vertical directions. For example, `bottomAnchor` is of type `NSLayoutYAxisAnchor` and `leadingAnchor` is of type `NSLayoutXAxisAnchor`. So all anchors are actually one of these three specific subclasses of `NSLayoutAnchor`.

The `constraint[Equal|LessThanOrEqual|GreaterThanOrEqual]ToAnchor` family of methods are actually generic methods that, when called from an object of type, `NSLayoutXAxisAnchor`, will only take a parameter of type `NSLayoutXAxisAnchor` and when called from an object of type, `NSLayoutYAxisAnchor` will only take in a parameter of type `NSLayoutYAxisAnchor`. This can prevent you attempting to pin the top of one view to the leading edge of another, for example.

TODO: Check this next bit with the GM. Fixing the interpretation of objC generics in Swift is just the kind of Swift change that they would slip into a tiny release without anybody noticing.

Though this type checking hasn't yet made its way into Swift, it currently works with Objective-C:
![bordered width=99%](images/28-xAnchor-and-yAnchor-incompatibility_632x60.png)

At the time of writing, Swift will still crash at runtime with the message "Invalid pairing of layout attributes", so you'll know pretty quickly if you've made a mistake.

You'll also still get an error in Swift if you try to constrain an `NSLayoutDimension` anchor with a different type of anchor, for example, a `widthAnchor` with a `topAnchor`:
![bordered width=99%](images/29-widthAnchor-and-topAnchor-compile-error_585x76.png)

To summarize:

- Layout anchors are a quick way of making constraints between different attributes of a view
- There are three different subclasses of `NSLayoutAnchor`
- The compiler will prevent you from creating constraints between the different subclasses of `NSLayoutAnchor`

The specific subclasses of `NSLayoutAnchor` are:

- `NSLayoutXAxisAnchor` for leading, trailing, left, right or center X anchors
- `NSLayoutYAxisAnchor` for top, bottom and center Y anchors
- `NSLayoutDimension` for width and height

Whew, that was a lot to cover. You're probably wondering if you'll ever fix that alignment bug. Of course you will! But first, read through the next section on layout guides — I promise it's much shorter. :]

After that, you'll be fully prepared to dive back into the code and fix that bothersome alignment bug.

## Layout guides

A layout guide gives you a new way to position views when you'd previously need to use a dummy view. For example, you might have used spacer views between buttons to space them equally, or a container view to collectively align two labels. But creating and adding a view has a cost, even if it's never drawn.

Think of a layout guide as defining a rectangular region or a frame in your view hierarchy, the edges of which you can use for alignment.

Layout guides don't enable any new functionality, but they do allow you to address these problems with a lightweight solution.

You add constraints to a `UILayoutGuide` in the same way that you add them to a `UIView`, because a layout guide has almost the same layout anchors as a view  — dropping just the inapplicable `firstBaselineAnchor` and `lastBaselineAnchor`.

Okay, now it's time to dive back into the project and fix that alignment bug.

## Fixing the alignment bug

You'll remember that the whole reason for the dive into layout guides and anchors was so that you could vertically center some of these misaligned labels in the cell by using the new tools available in iOS 9:
![bordered width=32%](images/30-misaligned-labels-reminder_750x1334.png)

They're misaligned because the current constraint specifies that the top of the name label should be a fixed distance from the top margin of the cell's `contentView`:
![bordered width=80%](images/31-the-incorrect-constraint_683x269.png)

If the name label was always on a single line, the current constraint would have been fine. But this app has labels that span two lines.

Prior to iOS 9, you'd have centered everything by putting both labels into a container view, and then you would have added a constraint to center the container view vertically within the cell. The only purpose of creating this dummy container view was for the collective alignment of the two labels.

But now you know that you can use a layout guide instead.

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

1. Create the `layoutGuide` and use `addLayoutGuide(_:)` to add it to the cell's `contentView`.
2. Pin the top of the layout guide to the top of the `nameLabel`.
3. Pin the bottom of the layout guide to the bottom of the `locationNameLabel`.
4. Add a constraint to center the layout guide vertically within the `contentView`.
5. Activate the constraints.

>**Note**: Using the `activateConstraints(_:)` method on UIView is the recommended way of adding constraints in iOS 8 onwards, as opposed to the old way of using `addConstraints(_:)`.

Build and run, you should see the following:
![bordered iphone](images/32-before-making-constraint-placeholder_750x1334.png)

### Handling the truncation

The labels are centered, but when the upper name label has content that causes it to overflow onto two lines, the bottom label has become compressed to the point of almost disappearing. This is because of the constraint that's still in the storyboard.

In order to satisfy that constraint as well as the newly added centering constraint, the bottom label had to compress itself. You can't remove the constraint from the storyboard since you would get the following missing constraint error:
![bordered width=70%](images/33-missing-constraint-error_660x188.png)

Instead, simply set it as a placeholder constraint. This is a trick to tell Xcode that you'll leave this constraint here for the storyboard, but you want it removed at runtime since you've got it covered in code.

Open **Main.storyboard**, and in the **Vacation Spots scene** click on **&lt;nameLabel>** to select it, and then click on the constraint connecting the top of the label to the top margin of the cell. Place a checkmark next to **Remove at build time**:
![bordered width=70%](images/34-remove-at-build-time_660x278.png)

Build and run, and you'll see the labels centered correctly!
![bordered width=30%](images/35-table-view-is-now-correct_750x1334.png)


## Where to go from here?

In this chapter, you started learning about stack views and also learned about some of the new features in Auto Layout, such as layout anchors and layout guides.

At this point, you've only scratched the surface. Keep up the momentum and proceed to the next chapter, where you'll continue to learn about stack views in depth. At the end of the next chapter, there will be some additional resources you can use to further your learning, but for now, all you have to do is turn the page!

## Chapter 7: Intermediate UIStackView

Welcome back! In the previous chapter, you spent some quality time with stack views and masterfully spaced a row of buttons with a horizontal stack view. Moreover, you also learned about layout guides and layout anchors, and discovered how to use them to vertically center two labels in a table view cell, without the use of dummy container views.

In this chapter, you'll make further improvements to the Vacation Spots app by using — you guessed it — stack views.

## Getting started

Open your project from the previous chapter to continue from where you left off, or open the starter project for this chapter.

### A recap of your to-do's

Here's a quick recap of the four tasks needed to improve `SpotInfoViewController`; these were laid out for you in the previous chapter.

1. Equally space the bottom row of buttons. **Done!**

2. After pressing the Hide button, the section below it should reposition to occupy the empty space. **Not Done.**

3. Swap the positions of the **what to see** and **weather** sections. **Not Done.**

4. Increase the spacing between sections in landscape mode so that the bottom row of buttons is a comfortable distance from the bottom edge of the view. **Not Done.**

In addition, you'll add some animations to spruce things up a bit.

## Converting the sections

Before you can check off the rest of your to-do's, you need to convert all of the sections in `SpotInfoViewController` to use stack views.

And as you work through this section, you'll learn about the various properties you can use to configure a stack view, such as `alignment`, `distribution` and `spacing`.

### Rating section

The rating section is the low-hanging fruit here, because it's the simplest one to embed in a stack view.

Open **Main.storyboard** and in the **Spot Info View Controller** scene, select the **RATING** label and the stars label next to it:
![bordered width=96%](images/01-select-rating-label-and-stars-label_640x74.png)

Then click on the **Stack** button to embed them in a stack view. Remember, this button is at the bottom of the storyboard window:
![bordered width=20%](images/02-stack_button_outlined_146x40.png)

You can also use the menu bar and select **Editor \ Embed in \ Stack View**. Whichever way you go about it, this is the result:
![bordered width=96%](images/03-after-clicking-stack-button_640x74.png)

Now click on the **Pin** button — remember that's the square TIE fighter-looking icon that's sitting to the right of the stack button. Place a checkmark in **Constrain to margins** and add the following **three** constraints:

```bash
Top: 20, Leading: 0, Bottom: 20
```
![bordered width=30%](images/04-add-second-stack-view-constraints_264x171.png)

Now go to the **Attributes inspector** and set the spacing to **8**:
![bordered width=38%](images/05-set-spacing-to-8_259x87.png)

It's possible you may see a _Misplaced Views_ warning and see something like this in which the stars label has stretched beyond the bounds of the view:
![bordered width=96%](images/06-stars-label-weirdly-stretched_640x85.png)

Sometimes Xcode may temporarily show a warning or position the stack view incorrectly, but the warning will disappear as you make other updates. You can usually safely ignore these.

However, to fix it immediately, you can persuade the stack view to re-layout either by moving its frame by one point and back or temporarily changing one of its layout properties.

To demonstrate this, change the **Alignment** from **Fill** to **Top** and then back to **Fill**. You'll now see the stars label positioned correctly:
![bordered width=96%](images/07-change-alignment-to-top-and-back_640x85.png)

Build and run to verify that everything looks exactly the same as before.

### Unembedding a stack view

Before you go too far, it's good to have some basic "first aid" training. Sometimes you may find yourself with an extra stack view that you no longer need, perhaps because of experimentation, refactoring or just by accident.

Fortunately, there is an easy way to _unembed_ views from a stack view.

First, you'd select the stack view you want to remove. Then from the menu you'd choose **Editor \ Unembed**. Or another way is to hold down the **Option** key and click on the **Stack** button. The click **Unembed** on the context menu that appears:
![bordered width=20%](images/08-how-to-unembed_186x71.png)

### Your first vertical stack view

Now, you'll create your first vertical stack view. Select the **WHY VISIT** label and the **&lt;whyVisitLabel>** below it:
![bordered width=96%](images/09-select-why-visit-labels_640x90.png)

Xcode will correctly infer that this should be a vertical stack view based on the position of the labels. Click the **Stack** button to embed both of these in a stack view:
![bordered width=96%](images/10-embed-why-visit-labels_640x90.png)

The lower label previously had a constraint pinning it to the right margin of the view, but that constraint was removed when it was embedded in the stack view. Currently, the stack view has no constraints, so it adopts the intrinsic width of its largest view.

With the stack view selected, click on the **Pin** button. Checkmark **Constrain to margins**, and set the **Top**, **Leading** and **Trailing** constraints to **0**.

Then, click on the dropdown to the right of the bottom constraint and select **WEATHER (current distance = 20)**:
![bordered width=42%](images/11-dont-select-nearest-neighbor-constraint_463x417.png)

By default, constraints are shown to the nearest neighbor, which for the bottom constraint is the **Hide** button at a distance of 15. You actually needed the constraint to be to the **WEATHER** label below it.

Finally, click **Add 4 Constraints**. You should now see the following:
![bordered width=96%](images/12-why-visit-stack-view-stretched_640x90.png)

You now have an expanded stack view with its right edges pinned to the right margin of the view. However, the bottom label is still the same width. You'll fix this by updating the stack view's `alignment` — keep reading to discover how!.

### Alignment property

Remember how you previously learned that the `distribution` property specifies how a stack view lays out its views _along_ its axis? You had set the bottom stack view's `distribution` to _Equal Spacing_ to space the buttons within it equally.
![bordered width=33%](images/13-i_did_that_317x288.png)

Well, meet `alignment`. It's the property that determines how a stack view lays out its views _perpendicular_ to its axis. For a vertical stack view, the possible values are `Fill`, `Leading`, `Center` and `Trailing`.
![bordered width=30%](images/14-vertical-alignment-values_260x131.png)

Select each value to see how it affects the placement of the labels in the stack view:

**Fill:**
![bordered width=96%](images/15-alignment-fill_640x64.png)

**Leading:**
![bordered width=96%](images/16-alignment-leading_640x64.png)

**Center:**
![bordered width=96%](images/17-alignment-center_640x64.png)

**Trailing:**
![bordered width=96%](images/18-alignment-trailing_640x64.png)

When you're done testing each value, set the **Alignment** to **Fill**:
![bordered width=96%](images/19-now-select-alignment-fill_640x64.png)

Then build and run to verify that everything looks good, and that there are no regressions.

Specifying `Fill` means you want all the views to completely fill the stack view perpendicular to its axis. This causes the **WHY VISIT** label to expand itself to the right edge as well.

But what if you only wanted the bottom label to expand itself to the edge?

For now, it doesn't matter since both labels will have a clear background at runtime, but it'll matter when you're converting the weather section.

You'll learn how to accomplish that with the use of an additional stack view.

### Convert the "what to see" section

This section is very similar to the previous one, so the instructions here are brief.

1. First, select the **WHAT TO SEE** label and the **&lt;whatToSeeLabel>** below it.
2. Click on the **Stack** button.
3. Click on the **Pin** button.
4. Checkmark **Constrain to margins**, and add the following **four** constraints:

```bash
Top: 20, Leading: 0, Trailing: 0, Bottom: 20
```
5. Set the stack view's **Alignment** to **Fill**.

Your storyboard should now look like this:
![bordered width=66%](images/20-after-what-to-see-section_640x308.png)

Build and run to verify that everything still looks the same.

That leaves you with just the **weather** section left. But first, indulge in a quick detour to learn a little more about `alignment`.

## Alignment

The `alignment` property is an enum of type `UIStackViewAlignment`. Its possible values in the vertical direction are `.Fill`, `.Leading`, `.Center`, and `.Trailing` which you saw in the previous section.

The possible `alignment` values for a _horizontal_ stack view differ slightly:
![width=75%](images/21-horizontal-and-vertical-alignment_594x171.png)

It has `.Top` instead of `.Leading` and has `.Bottom` instead of `.Trailing`. There are also two more properties that are valid only in the horizontal direction, `.FirstBaseline` and `.LastBaseline`.

Here's are some visuals to illustrate how each value works:

### Horizontal axis:
Here labels of different widths are aligned according to each value:
![bordered width=90%](images/22-horizontal-alignment_1200x223.png)

Now if the labels were the same width and the stack view was not stretched beyond its intrinsic width with a constraint, it wouldn't matter what value was chosen since they would all just fill the stack view.

### Vertical axis:
Here the labels are configured with different font sizes to give them different intrinsic heights, in order to demonstrate the different values:
![bordered width=90%](images/23-vertical-alignment_1200x206.png)

### FirstBaseline and LastBaseline:

These values are valid only in a horizontal stack view. `FirstBaseline` uses the baseline of the _first_ line in multi-line text, and `LastBaseline` uses the baseline of the _last_ line in multi-line text.

![bordered width=90%](images/24-baseline-alignment_1200x232.png)

## Convert the weather section

The next task is to add the **weather** section to a stack view. You'll start by adding it to a stack view.
![bordered width=33%](images/25-stack_view_easy_peasy_318x295.png)

Remember that little **Hide** button? Get ready, because this stack view is a bit more complex due to the inclusion of the **Hide** button.
![bordered width=33%](images/26-yeah_i_got_this_251x234.png)

### One possible approach

>**Note**: This section explores one possible approach, but don't follow along in Xcode just yet. Consider this first section theoretical.

You could create a nested stack view by embedding the **WEATHER** label and the **Hide** button into a horizontal stack view, and then embed that horizontal stack view and the **&lt;weatherInfoLabel>** into a vertical stack view.

It would look something like this:
![bordered width=90%](images/27-weather-stack-in-stack_640x92.png)

Notice that the **WEATHER** label has expanded to be equal to the height of the **Hide** button. This isn't ideal since this will cause there to be extra space between the baseline of the **WEATHER** label and the text below it.

Remember that `alignment` specifies positioning perpendicular to the stack view. So, you could set the `alignment` to **Bottom**:
![bordered width=90%](images/28-weather-stack-in-stack-alignment-bottom_640x92.png)

But you really don't want the height of the **Hide** button to dictate the height of the stack view.
![bordered width=32%](images/29-developer_to_do_331x290.png)

When the `alignment` of a stack view is set to `fill` and the views are of different sizes in the alignment direction, the stack view determines which views to compress or expand based on the relative content hugging priorities or the content compression resistance priorities of its views.

In your case, the stack view decides to expand the **WEATHER** label because its vertical content hugging priority of 251 is less than the **Hide** button's compression resistance priority of 750.

You _could_ decrease the **Hide** button's vertical compression resistance priority to 200 which would cause the stack view to compress the **Hide** button instead:
![bordered width=90%](images/30-decrease-compression-resistence-priority_640x92.png)

However, this isn't ideal since it would reduce the size of the tap target of the button.

### Actual approach

The actual approach you'll take is to have the **Hide** button _not_ be in the stack view for the **weather** section, or any other stack view for that matter.

It will remain a subview of the top-level view, and you'll add a constraint from it to the **WEATHER** label — which will be in a stack view. That's right, you'll add a constraint from a button outside of a stack view to a label within a stack view!

### Change the weather section – for real

You can once again start following along in Xcode. Select the **WEATHER** label and the **&lt;weatherInfoLabel>** below it:
![bordered width=96%](images/32-select-weather-and-info-label_640x92.png)

Click on the **Stack** button:
![bordered width=96%](images/33-weather-click-stack-button_640x92.png)

Click on the **Pin** button, checkmark **Constrain to margins** and add the following **four** constraints:

```bash
Top: 20, Leading: 0, Trailing: 0, Bottom: 20
```

Set the stack view's **Alignment** to **Fill**:
![bordered width=96%](images/34-weather-alignment-fill_640x92.png)

You need a constraint between the **Hide** button's left edge and the **WEATHER** label's right edge, so having the **WEATHER** label fill the stack view won't work.

However, you _do_ want the bottom **&lt;weatherInfoLabel>** to fill the stack view.

You can accomplish this by embedding just the **WEATHER** label into a vertical stack view. Remember that the `alignment` of a vertical stack view can be set to `.Leading`, and if the stack view is stretched beyond its intrinsic width, its contained views will remain aligned to its leading side.

Select the **WEATHER** label using the document outline, or by using the **Control-Shift-click** trick you learned in the previous chapter:
![bordered width=96%](images/35-select-just-the-weather-label_640x92.png)

Then click on the **Stack** button:
![bordered width=96%](images/36-weather-in-horizontal-stack_640x92.png)

Set **Alignment** to **Leading**, and make sure **Axis** is set to **Vertical**:
![bordered width=96%](images/37-vertical-and-leading_640x92.png)

Perfect! You've got the outer stack view stretching the inner stack view to fill the width, but the inner stack view allows the label to keep its original width!

Build and run. Why on earth is the **Hide** button hanging out in the middle of the text?
![bordered width=32%](images/38-hide-label-incorrect-position_750x573.png)

It's because when you embedded the **WEATHER** label in a stack view, any constraints between it and the **Hide** button were removed. So you'll just add them back.

**Control-drag** from the **Hide** button to the **WEATHER** label:
![bordered width=40%](images/39-drag-to-weather-label_380x94.png)

Hold down **Shift** to select multiple options, and select **Horizontal Spacing** and **Baseline**. Then click on **Add Constraints**:
![bordered width=40%](images/40-add-multiple-constraints_380x224.png)

Build and run. The **Hide** button should now be positioned correctly, and since the label that is being set to hidden is embedded in a stack view, pressing **Hide** hides the label, and adjusts the views below it – all without having to manually adjust any constraints.
![bordered width=32%](images/41-hide-button-works_750x732.png)

Now that all the sections are in unique stack views, you're set to embed them all into an outer stack view, which will make the final two tasks incredibly simple.

### Top-level stack view

**Command-click** to select all five top-level stack views in the outline view:
![bordered width=73%](images/42-select-all-stack-views-in-outline_640x260.png)

Then click on the **Stack** button:
![bordered width=73%](images/43-stack-all-the-views_640x185.png)

Click the **Pin** button, checkmark **Constrain to margins** add constraints of **0** to all edges. Then set **Spacing** to **20** and **Alignment** to **Fill**. Your storyboard scene should now look like this:
![bordered width=73%](images/44-set-the-spacing-to-20-and-alignment-to-fill_640x300.png)

Build and run:
![bordered width=32%](images/45-hide-button-lost-again_750x487.png)

Whoops! Looks like the hide button lost its constraints again when the **WEATHER** stack view was embedded in the outer stack view. No biggie, just add constraints to it again in the same way you did before.

**Control-drag** from the **Hide** button to the **WEATHER** label, hold down **Shift**, select both **Horizontal Spacing** and **Baseline**. Then click on **Add Constraints**:
![bordered width=40%](images/46-add-constraints-to-button-again_380x223.png)

Build and run. The **Hide** button is now behaving itself.

### Repositioning views

Now that all of the sections are in a top-level stack view, you'll modify the position of the **what to see** section so that it's positioned above the **weather** section.

Select the **middle stack view** from the outline view and **drag it between** the first and second view.

>**Note:** Keep the pointer slightly to the left of the stack views that you're dragging it between, so that it remains a _subview_ of the outer stack view. The little blue circle should be positioned at the left edge between the two stack views and not at the right edge:
![bordered width=80%](images/47-drag-and-drop-to-reposition-section_639x130.png)

And now the **weather** section is third from the top, but since the **Hide** button isn't part of the stack view, it won't be moved, so its frame will now be misplaced and the Hide button will look like it's lost its mind again.
![bordered width=33%](images/48-seriously_not_again_308x277.png)

Click on the **Hide** button to select it:
![bordered width=80%](images/49-hide-button-not-moved_640x130.png)

Then click on the **Resolve Auto Layout Issues** triangle shaped button in the Auto Layout toolbar and under the **Selected Views** section, click on **Update Frames**:
![bordered width=40%](images/50-resolve-auto-layout-issues_356x269.png)

The **Hide** button will now be back in the correct position:
![bordered width=80%](images/51-hide-button-back-to-correct-position_640x130.png)

Granted, repositioning the view with Auto Layout and re-adding constraints would not have been the most difficult thing you've ever done, but didn't this feel oh-so-much nicer?

### Arranged subviews

Okay, back away from Xcode — it's time for some theory!

`UIStackView` has a property named `arrangedSubviews`, and it also has a `subviews` property since it's a subclass of `UIView` — which begs the question about how these two properties differ.

The `arrangedSubviews` array contains the subviews that the stack view lays out as part of its stack. The order in the array represents the ordering within the stack view, whereas the ordering in the `subviews` array represents the front-to-back placement of the subviews, i.e. the z-axis order.

Also, `arrangedSubviews` is always a subset of the `subviews` array. (You can't be an arranged subview if you're not even a subview!) Anytime a view is added to `arrangedSubviews` it's automatically added to `subviews`, but not vice versa.

The outline view in a storyboard for a stack view actually represents its `arrangedSubviews`. So, it's not possible to add a view only to the stack view's `subviews` using the storyboard; you'd have to do that in code.

When might you want to add a subview to a stack view, but not to its `arrangedSubviews`? One possible case could be to add a background view.

Views can programmatically be added to the stack view, i.e. to `arrangedSubviews`, by using `addArrangedSubview(_:)` or `insertArrangedSubview(_:atIndex:)`.

To remove an arranged subview, you can use `removeArrangedSubview(_:)`, however, using this method doesn't remove the view from `subviews`, so it doesn't actually get removed from the view hierarchy until you call `removeFromSuperview()` on the view.

And since it's not possible to have a view in `arrangedSubviews` that's not in `subviews`, you can take the shortcut of just calling `removeFromSuperview()` on the subview, since this will remove it from `arrangedSubviews` as well as from `subviews`.

### Size class based configuration

Finally you can turn your attention to the one remaining task on your list. In landscape mode, vertical space is at a premium, so you want to bring the sections of the stack view closer together. To do this, you'll use size classes to set the spacing of the top-level stack view to **10** instead of **20** when the vertical size class is compact.

Select the top-level stack view and click on the little **+** button next to **Spacing**:
![bordered width=33%](images/52-select-plus-button_260x120.png)

Choose **Any Width** > **Compact Height**:
![bordered width=50%](images/53-anywidth-compact-height_403x108.png)

And set the **Spacing** to **10** in the new **wAny hC** field:
![bordered width=33%](images/54-set-spacing-to-10_260x160.png)

Build and run. Portrait mode should be unchanged, so rotate the simulator (⌘←) to see your handiwork. Note that spacing between the sections has decreased and the buttons now have ample space from the bottom of the view:
![bordered iphone-landscape](images/55-spacing-in-iphone-landscape_1334x750.png)

If you didn't add a top-level stack view, you still _could_ have used size classes to set the vertical spacing to 10 on each of the four constraints that separate the five sections, but isn't it so much better to set it in just a single place?

You have better things to do with your time, like animation!

## Animation

Currently, it's a bit jarring when hiding and showing the weather details. It's the perfect place to add some animation to smooth the transition.

### Animating hidden

Stack views are fully compatible with the UIView animation engine. This means that animating the appearance/disappearance of an arranged subview, is as simple as toggling its `hidden` property _inside_ an animation block.

It's finally time to write some code again! Open **SpotInfoViewController.swift** and take a look at `updateWeatherInfoViews(hideWeatherInfo:animated:)`. When the user taps **Hide**, the current state gets saved. In `viewDidLoad()` this method gets called with `animated: false` and when the button is pressed it gets called with `animated: true`, so the method already receives the `animate` parameter correctly.

You'll see this line at the end of the method:

```swift
weatherInfoLabel.hidden = shouldHideWeatherInfo
```

Replace it with the following:

```swift
if animated {
  UIView.animateWithDuration(0.3) {
    self.weatherInfoLabel.hidden = shouldHideWeatherInfo
  }
} else {
  weatherInfoLabel.hidden = shouldHideWeatherInfo
}
```

Build and run, and tap the **Hide** or **Show** button. This looks much nicer, but why not take it a step further by adding some bounce?

Replace the following three lines:

```swift
UIView.animateWithDuration(0.3) {
  self.weatherInfoLabel.hidden = shouldHideWeatherInfo
}
```

With the following:

```swift
UIView.animateWithDuration(0.3,
  delay: 0.0,
  usingSpringWithDamping: 0.6,
  initialSpringVelocity: 10,
  options: [],
  animations: {
    self.weatherInfoLabel.hidden = shouldHideWeatherInfo
  }, completion: nil
)
```

Build and run. You should now see a nice, subtle bounce when you tap the button.

In addition to animating the hidden property on views contained within the stack view, you can also animate properties on the stack view itself, such as `alignment`, `distribution` and `spacing`.

You can even animate the `axis`, and in fact, that's what you'll do next.

### Animating the axis

Open **Main.storyboard** and locate the stack view for the **rating** section in the outline view. Open the assistant editor and **Control-drag** to **SpotInfoViewController** to create an outlet:
![bordered width=96%](images/56-create-outlet_1076x181.png)

Name the outlet **ratingStackView** and click on **Connect**:
![bordered width=60%](images/57-name-outlet_594x168.png)

Close the assistant editor and now open **SpotInfoViewController.swift** in the main editor. In `updateWeatherInfoViews(hideWeatherInfo:animated:)` replace the following nil completion block:

```swift
}, completion: nil
```

With the following code:

```swift
}, completion: { finished in
  UIView.animateWithDuration(0.3) {
    self.ratingStackView.axis =
      shouldHideWeatherInfo ? .Vertical : .Horizontal
  }
}
```

Once the initial hide or show animation completes, if the weather info was just hidden, then the `axis` of `ratingStackView` animates to horizontal. When the weather is shown again, the `axis` will be set back to vertical.
![bordered width=32%](images/58-rating-animation_750x902.png)

Add the following lines immediately below the existing line in the `else` clause:

```swift
} else {
  weatherInfoLabel.hidden = shouldHideWeatherInfo // existing line
  ratingStackView.axis = shouldHideWeatherInfo ? .Vertical : .Horizontal
}
```

This sets the `axis` of the `ratingStackView` correctly when the view first appears.

## Where to go from here?

In this chapter, you continued your dive into stack views and learned about the various properties that a stack view uses to position its subviews. Stack views are highly configurable, and there may be more than one way achieve the same result.

The best way to build on what you've learned is to experiment with various properties yourself. Instead of setting a property and moving on, see how playing with the other properties affects the layout of views within the stack view.

One way to speed up your learning is to test yourself, so before you change a property on a stack view, quiz yourself mentally to see if you can predict the change that will occur, and then see if your expectations match reality.

Stack views are now your new view hierarchy building blocks. Get to know them — and know them well. Really, just make them your new best friend.

Here are some related videos from WWDC 2015 that may be of interest:

- [Mysteries of Auto Layout, Part 1 (http://apple.co/1D47aKk)](https://developer.apple.com/videos/wwdc/2015/?id=218)
- [Mysteries of Auto Layout, Part 2 (http://apple.co/1HTcVJy)](https://developer.apple.com/videos/wwdc/2015/?id=219)
- [Implementing UI Designs in Interface Builder (http://apple.co/1H5vS84)](https://developer.apple.com/videos/wwdc/2015/?id=407)
