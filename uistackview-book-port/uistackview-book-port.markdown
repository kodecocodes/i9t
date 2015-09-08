# Tutorial: Introduction to UIStackView

We've all been there. There's a new requirement and you need to add or remove a view at runtime, and also need to reposition adjacent views.

What approach do you take? Do you add outlets to constraints in your storyboard so that you can activate or deactivate certain ones? Or do you use a third party library? Or depending on the complexity maybe you do everything in code.

Maybe this time around your view hierarchy didn't have to change at runtime, but you still had to figure out how to squeeze this one new view into your storyboard.

Did you ever end up just clearing all constraints and re-adding them from scratch because it was easier than performing painstaking _constraints-surgery_?

With the introduction of `UIStackView`, the above tasks become trivial. Stack views provide a way to lay out a series of views horizontally or vertically. By configuring a few simple properties such as alignment, distribution, and spacing, you can define how the contained views adjust themselves to the available space.

> **Note**: This chapter assumes basic familiarity with Auto Layout. If you're new to Auto Layout get check out the [Auto Layout Tutorial Part 1](http://www.raywenderlich.com/83129/beginning-auto-layout-tutorial-swift-part-1) tutorial.


## Getting started

In this tutorial, you'll work on an app called **Vacation Spots**. It's a simple app that shows you a list of places to get away from it all.

But don't pack your bags just yet, because there are a few issues you'll fix by using stack views, and in a much simpler way than if you were using Auto Layout alone.

Start by downloading the [starter project](TODO: Link) for this tutorial and run it on the **iPhone 6 Simulator**. You'll see a list of places you can go on vacation.
![bordered width=30%](images/01-table-view-is-now-correct_750x1334.png)

Go to the info view for London by tapping on the **London** cell.

At first glance, the view may seem okay, but it has a few issues.

1. Look at the row of buttons at the bottom of the view. They are currently positioned with a fixed amount of space between themselves, so they don't adapt to the screen width. To see the problem in full glory, temporarily rotate the simulator to landscape orientation by pressing **Command-left**.

![bordered iphone-landscape](images/02-issues-visible-in-landscape-view_1334x750.png)

2. Tap on the **Hide** button next to **WEATHER**. It successfully hides the text, but it doesn't reposition the section below it, leaving a block of blank space.

![bordered width=31%](images/03-hide-weather-issue_750x1334.png)

3. The ordering of the sections can be improved. It would be more logical if the **what to see** section was positioned right after the **why visit** section, instead of having the **weather** section in between them.

4. The bottom row of buttons is a bit too close to the bottom edge of the view in landscape mode. It would be better if you could decrease the spacing between the different sections – but only in landscape mode.

Now that you have an idea of the improvements you'll be making, it's time to dive into the project.

Open **Main.storyboard** and take a look at the **Spot Info View Controller** scene. And boom! Have some color with your stack view.
![bordered width=40%](images/04-colorful-scene-in-storyboard_504x636.png)

These labels and buttons have various background colors set that will be cleared at runtime. In the storyboard, they're simply visual aids to help show how changing various properties of a stack view will affect the frames of its embedded views.

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

Size classes are still enabled, but the size of the initial Navigation Controller has been set to **iPhone 4-inch** under the **Simulated Metrics** section in the **Attributes inspector**. This just makes it a bit easier to work with the storyboard; the simulated metrics property has no effect at runtime — the view will resize for different devices.
![bordered width=96%](images/05-simulated-metrics-iphone-4-inch_639x173.png)

## Your first stack view

The first thing you'll fix by using a stack view is the spacing between the bottom row of buttons. A stack view can distribute its views along its axis in various ways, and one of the ways is with an equal amount of spacing between each view.

Fortunately, embedding existing views into a new stack view is not rocket science. First, select all of the buttons at the bottom of the **Spot Info View Controller** scene by **clicking** on one, then **Command-click** on the other two:
![bordered width=63%](images/06-select-bottom-row-of-buttons_420x80.png)

If the outline view isn't already open, go ahead and open it by using the **Show Document Outline** button at the bottom left of the storyboard canvas:
![bordered width=20%](images/07-document-outline-button_120x40.png)

Verify that all 3 buttons are selected by checking them in the outline view:
![bordered width=54%](images/08-verify-button-selection_360x90.png)

In case they aren't all selected, you can also **Command-click** on each button in the outline view to select them.

Once selected, click on the new **Stack** button in the Auto Layout toolbar at the bottom right of the storyboard canvas:
![bordered width=20%](images/09-stack_button_outlined_148x52.png)

The buttons will become embedded in a new stack view:
![bordered width=96%](images/10-bottom-row-is-now-in-stack-view_640x100.png)

The buttons are now flush with each other – you'll that fix shortly.

While the stack view takes care of positioning the buttons, you still need to add Auto Layout constraints to position the stack view itself.

When you embed a view in a stack view, any constraints to other views are removed. For example, prior to embedding the buttons in a stack view, the top of the **Submit Rating** button had a vertical spacing constraint connecting it to the bottom of the **Rating:** label:
![bordered width=63%](images/11-prior-constraint_420x90.png)

Click on the **Submit Rating** button to see that it no longer has any constraints attached to it:
![bordered width=60%](images/12-no-more-constraints_400x80.png)

Another way to verify that the constraints are gone is by looking at the **Size inspector** (⌥⌘5):
![bordered width=96%](images/13-check-size-inspector_640x80.png)

In order to add constraints to position the stack view itself, you'll first need to select it. Selecting a stack view in the storyboard can get tricky if its views completely fill the stack view.

One simple way is to select the stack view in the outline view:
![bordered width=99%](images/14-stack-view-document-outline-selection_660x80.png)

Another trick is to hold **Shift** and **Right-click** on any of the views in the stack view, or **Control-Shift-click** if you're using a trackpad. You'll get a context menu that shows the view hierarchy at the location you clicked, and you simply select the stack view by clicking on it in the menu.

For now, select the stack view using the **Shift-Right-click** method:
![bordered width=40%](images/15-select-stack-view-in-view-hierarchy-menu_400x280.png)

Now, click the **Pin** button on the Auto Layout toolbar to add constraints to it:
![bordered width=20%](images/16-pin-button_142x57.png)

First add a check to **Constrain to margins**. Then add the following constraints to the edges of your stack view:

```bash
Top: 20, Leading: 0, Trailing: 0, Bottom: 0
```

Double-check the numbers for the top, leading, trailing, and bottom constraints and make sure that the **I-beams** are selected. Then click on **Add 4 Constraints**:
![bordered width=30%](images/17-bottom-stack-view-constraints_264x364.png)

Now the stack view is the correct size, but it has stretched the first button to fill in any extra space:
![bordered width=60%](images/18-first-button-is-stretched_400x80.png)

The property that determines how a stack view lays out its views along its axis is its `distribution` property. Currently, it's set to `Fill`, which means the contained views will completely fill the stack view along its axis. To accomplish this, the stack view will only expand one of its views to fill that extra space; specifically, it expands the view with the lowest horizontal content hugging priority, or if all of the priorities are equal, it expands the first view.

However, you're not looking for the buttons to fill the stack view completely – you want them to be equally spaced.

Make sure the stack view is still selected, and go to the **Attributes inspector**. Change the **Distribution** from **Fill** to **Equal Spacing**:
![bordered width=96%](images/19-change-distribution-to-equal-spacing_640x148.png)

Now build and run, tap on any cell, and rotate the simulator (⌘→). You'll see that the bottom buttons now space themselves equally!
![bordered iphone-landscape](images/20-now-buttons-are-equally-spaced_1334x750.png)

In order to solve this problem without a stack view, you would have had to use spacer views, one between each pair of buttons. You'd have to add equal width constraints to all of the spacer views as well as lots of additional constraints to position the spacer views correctly.

It would have looked something like the following. For visibility in the screenshot, the spacer views have been given a light gray background:
![bordered width=50%](images/21-alternate-solution-1_346x76.png)

This isn't too much of an issue if you only have to do this once in the storyboard, but many views are dynamic. It's not a straightforward task to add a new button or to hide or remove an existing button at runtime because of the adjacent spacer views and constraints.

In order to hide a view within a stack view, all you have to do is set the contained view's `hidden` property to `true` and the stack view handles the rest. This is how you'll fix the spacing under the **WEATHER** label when the user hides the text below it. You'll do that a bit later in the tutorial once you've added the weather section labels into a stack view.

## Converting the sections

You will convert all of the other sections in `SpotInfoViewController` to use stack views as well. This will enable you to easily complete the remaining tasks. You'll convert the rating section next.

### Rating section

Right above the stack view that you just created, select the **RATING** label and the stars label next to it:
![bordered width=96%](images/22-select-rating-label-and-stars-label_640x74.png)

Then click on the **Stack** button to embed them in a stack view:
![bordered width=96%](images/23-after-clicking-stack-button_640x74.png)

Now click on the **Pin** button. Place a checkmark in **Constrain to margins** and add the following **three** constraints:

```bash
Top: 20, Leading: 0, Bottom: 20
```
![bordered width=30%](images/24-add-second-stack-view-constraints_264x171.png)

Now go to the **Attributes inspector** and set the spacing to **8**:
![bordered width=38%](images/25-set-spacing-to-8_259x87.png)

It's possible you may see a _Misplaced Views_ warning and see something like this in which the stars label has stretched beyond the bounds of the view:
![bordered width=96%](images/26-stars-label-weirdly-stretched_640x85.png)

Sometimes Xcode may temporarily show a warning or position the stack view incorrectly, but the warning will disappear as you make other updates. You can usually safely ignore these.

However, to fix it immediately, you can persuade the stack view to re-layout either by moving its frame by one point and back or temporarily changing one of its layout properties.

To demonstrate this, change the **Alignment** from **Fill** to **Top** and then back to **Fill**. You'll now see the stars label positioned correctly:
![bordered width=96%](images/27-change-alignment-to-top-and-back_640x85.png)

Build and run to verify that everything looks exactly the same as before.

### Unembedding a stack view

Before you go too far, it's good to have some basic "first aid" training. Sometimes you may find yourself with an extra stack view that you no longer need, perhaps because of experimentation, refactoring or just by accident.

Fortunately, there is an easy way to _unembed_ views from a stack view.

First, you'd select the stack view you want to remove. Then hold down the **Option** key and click on the **Stack** button. The click **Unembed** on the context menu that appears:
![bordered width=20%](images/28-how-to-unembed_186x71.png)

Another way to do this is to select the stack view and then choose **Editor \ Unembed** from the menu.

### Your first vertical stack view

Now, you'll create your first vertical stack view. Select the **WHY VISIT** label and the **&lt;whyVisitLabel>** below it:
![bordered width=96%](images/29-select-why-visit-labels_640x90.png)

Xcode will correctly infer that this should be a vertical stack view based on the position of the labels. Click the **Stack** button to embed both of these in a stack view:
![bordered width=96%](images/30-embed-why-visit-labels_640x90.png)

The lower label previously had a constraint pinning it to the right margin of the view, but that constraint was removed when it was embedded in the stack view. Currently, the stack view has no constraints, so it adopts the intrinsic width of its largest view.

With the stack view selected, click on the **Pin** button. Checkmark **Constrain to margins**, and set the **Top**, **Leading** and **Trailing** constraints to **0**.

Then, click on the dropdown to the right of the bottom constraint and select **WEATHER (current distance = 20)**:
![bordered width=50%](images/31-dont-select-nearest-neighbor-constraint_463x417.png)

By default, constraints are shown to the nearest neighbor, which for the bottom constraint is the **Hide** button at a distance of 15. You actually needed the constraint to be to the **WEATHER** label below it.

Finally, click **Add 4 Constraints**. You should now see the following:
![bordered width=96%](images/32-why-visit-stack-view-stretched_640x90.png)

You now have an expanded stack view with its right edges pinned to the right margin of the view. However, the bottom label is still the same width. You'll fix this by updating the stack view's `alignment` property.

### Alignment property

The `alignment` property determines how a stack view lays out its views _perpendicular_ to its axis. For a vertical stack view, the possible values are `Fill`, `Leading`, `Center` and `Trailing`.

The possible `alignment` values for a _horizontal_ stack view differ slightly:
![width=75%](images/33-horizontal-and-vertical-alignment_594x171.png)

It has `.Top` instead of `.Leading` and has `.Bottom` instead of `.Trailing`. There are also two more properties that are valid only in the horizontal direction, `.FirstBaseline` and `.LastBaseline`.

Select each value to see how it affects the placement of the labels for the vertical stack view:

**Fill:**
![bordered width=96%](images/34-alignment-fill_640x64.png)

**Leading:**
![bordered width=96%](images/35-alignment-leading_640x64.png)

**Center:**
![bordered width=96%](images/36-alignment-center_640x64.png)

**Trailing:**
![bordered width=96%](images/37-alignment-trailing_640x64.png)

When you're done testing each value, set the **Alignment** to **Fill**:
![bordered width=96%](images/38-now-select-alignment-fill_640x64.png)

Then build and run to verify that everything looks good and that there are no regressions.

Specifying `Fill` means you want all the views to completely fill the stack view perpendicular to its axis. This causes the **WHY VISIT** label to expand itself to the right edge as well.

But what if you only wanted the bottom label to expand itself to the edge?

For now, it doesn't matter since both labels will have a clear background at runtime, but it will matter when you're converting the weather section.

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
![bordered width=66%](images/39-after-what-to-see-section_640x308.png)

Build and run to verify that everything still looks the same.

This leaves you with just the **weather** section left.

## Convert the weather section

The **weather** section is more complex than the others due to the inclusion of the **Hide** button.

One approach you could take would be to create a nested stack view by embedding the **WEATHER** label and the **Hide** button into a horizontal stack view, and then embedding that horizontal stack view and the **&lt;weatherInfoLabel>** into a vertical stack view.

It would look something like this:
![bordered width=90%](images/40-weather-stack-in-stack_640x92.png)

Notice that the **WEATHER** label has expanded to be equal to the height of the **Hide** button. This isn't ideal since this will cause there to be extra space between the baseline of the **WEATHER** label and the text below it.

Remember that `alignment` specifies positioning perpendicular to the stack view. So, you could set the `alignment` to **Bottom**:
![bordered width=90%](images/41-weather-stack-in-stack-alignment-bottom_640x92.png)

But you really don't want the height of the **Hide** button to dictate the height of the stack view.

The actual approach you'll take is to have the **Hide** button _not_ be in the stack view for the **weather** section, or any other stack view for that matter.

It will remain a subview of the top-level view, and you'll add a constraint from it to the **WEATHER** label — which will be in a stack view. That's right, you'll add a constraint from a button outside of a stack view to a label within a stack view!

Select the **WEATHER** label and the **&lt;weatherInfoLabel>** below it:
![bordered width=96%](images/42-select-weather-and-info-label_640x92.png)

Click on the **Stack** button:
![bordered width=96%](images/43-weather-click-stack-button_640x92.png)

Click on the **Pin** button, checkmark **Constrain to margins** and add the following **four** constraints:

```bash
Top: 20, Leading: 0, Trailing: 0, Bottom: 20
```

Set the stack view's **Alignment** to **Fill**:
![bordered width=96%](images/44-weather-alignment-fill_640x92.png)

You need a constraint between the **Hide** button's left edge and the **WEATHER** label's right edge, so having the **WEATHER** label fill the stack view won't work.

However, you _do_ want the bottom **&lt;weatherInfoLabel>** to fill the stack view.

You can accomplish this by embedding just the **WEATHER** label into a vertical stack view. Remember that the `alignment` of a vertical stack view can be set to `.Leading`, and if the stack view is stretched beyond its intrinsic width, its contained views will remain aligned to its leading side.

Select the **WEATHER** label using the document outline, or by using the **Control-Shift-click** method:
![bordered width=96%](images/45-select-just-the-weather-label_640x92.png)

Then click on the **Stack** button:
![bordered width=96%](images/46-weather-in-horizontal-stack_640x92.png)

Set **Alignment** to **Leading**, and make sure **Axis** is set to **Vertical**:
![bordered width=96%](images/47-vertical-and-leading_640x92.png)

Perfect! You've got the outer stack view stretching the inner stack view to fill the width, but the inner stack view allows the label to keep its original width!

Build and run. Why on earth is the **Hide** button hanging out in the middle of the text?
![bordered width=32%](images/48-hide-label-incorrect-position_750x573.png)

It's because when you embedded the **WEATHER** label in a stack view, any constraints between it and the **Hide** button were removed.

To add new constraints **Control-drag** from the **Hide** button to the **WEATHER** label:
![bordered width=40%](images/49-drag-to-weather-label_380x94.png)

Hold down **Shift** to select multiple options, and select **Horizontal Spacing** and **Baseline**. Then click on **Add Constraints**:
![bordered width=40%](images/50-add-multiple-constraints_380x224.png)

Build and run. The **Hide** button should now be positioned correctly, and since the label that is being set to hidden is embedded in a stack view, pressing **Hide** hides the label, and adjusts the views below it – all without having to manually adjust any constraints.
![bordered width=32%](images/51-hide-button-works_750x732.png)

Now that all the sections are in unique stack views, you're set to embed them all into an outer stack view, which will make the final two tasks trivial.

### Top-level stack view

**Command-click** to select all five top-level stack views in the outline view:
![bordered width=73%](images/52-select-all-stack-views-in-outline_640x260.png)

Then click on the **Stack** button:
![bordered width=73%](images/53-stack-all-the-views_640x185.png)

Click the **Pin** button, checkmark **Constrain to margins** add constraints of **0** to all edges. Then set **Spacing** to **20** and **Alignment** to **Fill**. Your storyboard scene should now look like this:
![bordered width=73%](images/54-set-the-spacing-to-20-and-alignment-to-fill_640x300.png)

Build and run:
![bordered width=32%](images/55-hide-button-lost-again_750x487.png)

Whoops! Looks like the hide button lost its constraints again when the **WEATHER** stack view was embedded in the outer stack view. No problem, just add constraints to it again in the same way you did before.

**Control-drag** from the **Hide** button to the **WEATHER** label, hold down **Shift**, select both **Horizontal Spacing** and **Baseline**. Then click on **Add Constraints**:
![bordered width=40%](images/56-add-constraints-to-button-again_380x223.png)

Build and run. The **Hide** button is now positioned correctly.

### Repositioning views

Now that all of the sections are in a top-level stack view, you'll modify the position of the **what to see** section so that it's positioned above the **weather** section.

Select the **middle stack view** from the outline view and **drag it between** the first and second view.

>**Note:** Keep the pointer slightly to the left of the stack views that you're dragging it between so that it remains a _subview_ of the outer stack view. The little blue circle should be positioned at the left edge between the two stack views and not at the right edge:
![bordered width=80%](images/57-drag-and-drop-to-reposition-section_639x130.png)

And now the **weather** section is third from the top, but since the **Hide** button isn't part of the stack view, it won't be moved, so its frame will now be misplaced.

Click on the **Hide** button to select it:
![bordered width=80%](images/58-hide-button-not-moved_640x130.png)

Then click on the **Resolve Auto Layout Issues** triangle shaped button in the Auto Layout toolbar and under the **Selected Views** section, click on **Update Frames**:
![bordered width=40%](images/59-resolve-auto-layout-issues_356x269.png)

The **Hide** button will now be back in the correct position:
![bordered width=80%](images/60-hide-button-back-to-correct-position_640x130.png)

Granted, repositioning the view with Auto Layout and re-adding constraints would not have been the most difficult thing you've ever done, but didn't this feel oh-so-much nicer?

### Size class based configuration

Finally, you can turn your attention to the one remaining task on your list. In landscape mode, vertical space is at a premium, so you want to bring the sections of the stack view closer together. To do this, you'll use size classes to set the spacing of the top-level stack view to **10** instead of **20** when the vertical size class is compact.

Select the top-level stack view and click on the little **+** button next to **Spacing**:
![bordered width=33%](images/61-select-plus-button_260x120.png)

Choose **Any Width** > **Compact Height**:
![bordered width=50%](images/62-anywidth-compact-height_403x108.png)

And set the **Spacing** to **10** in the new **wAny hC** field:
![bordered width=33%](images/63-set-spacing-to-10_260x160.png)

Build and run. The spacing in portrait mode should remain unchanged. Rotate the simulator (⌘←) and note that the spacing between the sections has decreased and the buttons now have ample space from the bottom of the view:
![bordered iphone-landscape](images/64-spacing-in-iphone-landscape_1334x750.png)

If you didn't add a top-level stack view, you still _could_ have used size classes to set the vertical spacing to 10 on each of the four constraints that separate the five sections, but isn't it so much better to set it in just a single place?

You have better things to do with your time, like animation!

## Animation

Currently, it's a bit jarring when hiding and showing the weather details. You'll add some animation to smooth the transition.

Stack views are fully compatible with the UIView animation engine. This means that animating the appearance/disappearance of an arranged subview, is as simple as toggling its `hidden` property _inside_ an animation block.

It's time to write some code! Open **SpotInfoViewController.swift** and take a look at `updateWeatherInfoViews(hideWeatherInfo:animated:)`.

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

Build and run, and tap the **Hide** or **Show** button. Doesn't the animated version feel much nicer?

In addition to animating the hidden property on views contained within the stack view, you can also animate properties on the stack view itself, such as `alignment`, `distribution`, `spacing` and even the `axis`.

## Where to go from here?

In this tutorial, you learned a lot about stack views as well as the various properties that a stack view uses to position its subviews. Stack views are highly configurable, and there may be more than one way achieve the same result.

The best way to build on what you've learned is to experiment with various properties yourself. Instead of setting a property and moving on, see how playing with the other properties affects the layout of views within the stack view.

This tutorial was an abbreviated version of Chapter 6, "UIStackView and Auto Layout changes" and Chapter 7, "Intermediate UIStackView" from iOS 9 by Tutorials. If you'd like to learn more about UIStackView and other new features in iOS 9 please check out the book!
