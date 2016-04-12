```metadata
author: "By Jawwad Ahmad"
number: "8"
title: "Chapter 8: Intermediate UIStackView"
```

# Chapter 8: Intermediate UIStackView

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

$[=s=]

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

$[break]
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
![width=33%](images/13-i_did_that_317x288.png)

Well, meet `alignment`. It's the property that determines how a stack view lays out its views _perpendicular_ to its axis. For a vertical stack view, the possible values are `Fill`, `Leading`, `Center` and `Trailing`.
![bordered width=30%](images/14-vertical-alignment-values_260x131.png)

Select each value to see how it affects the placement of the labels in the stack view:

**Fill:**
![bordered width=96%](images/15-alignment-fill_640x64.png)

$[=s=]

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

$[=s=]

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
![width=33%](images/25-stack_view_easy_peasy_318x295.png)

Remember that little **Hide** button? Get ready, because this stack view is a bit more complex due to the inclusion of the **Hide** button.
![width=33%](images/26-yeah_i_got_this_251x234.png)

### One possible approach

>**Note**: This section explores one possible approach, but don't follow along in Xcode just yet. Consider this first section theoretical.

You could create a nested stack view by embedding the **WEATHER** label and the **Hide** button into a horizontal stack view, and then embed that horizontal stack view and the **&lt;weatherInfoLabel>** into a vertical stack view.

It would look something like this:
![bordered width=90%](images/27-weather-stack-in-stack_640x92.png)

Notice that the **WEATHER** label has expanded to be equal to the height of the **Hide** button. This isn't ideal since this will cause there to be extra space between the baseline of the **WEATHER** label and the text below it.

Remember that `alignment` specifies positioning perpendicular to the stack view. So, you could set the `alignment` to **Bottom**:
![bordered width=90%](images/28-weather-stack-in-stack-alignment-bottom_640x92.png)

But you really don't want the height of the **Hide** button to dictate the height of the stack view.
![width=32%](images/29-developer_to_do_331x290.png)

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

$[=s=]

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
![width=33%](images/48-seriously_not_again_308x277.png)

$[=s=]

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

$[=s=]

Add the following lines immediately below the existing line in the `else` clause:

```swift
} else {
  weatherInfoLabel.hidden = shouldHideWeatherInfo
  ratingStackView.axis =
    shouldHideWeatherInfo ? .Vertical : .Horizontal
}
```

This sets the `axis` of the `ratingStackView` correctly when the view first appears.

## Where to go from here?

In this chapter, you continued your dive into stack views and learned about the various properties that a stack view uses to position its subviews. Stack views are highly configurable, and there may be more than one way achieve the same result.

The best way to build on what you've learned is to experiment with various properties yourself. Instead of setting a property and moving on, see how playing with the other properties affects the layout of views within the stack view.

One way to speed up your learning is to test yourself, so before you change a property on a stack view, quiz yourself mentally to see if you can predict the change that will occur, and then see if your expectations match reality.

Stack views are now your new view hierarchy building blocks. Get to know them — and know them well. Really, just make them your new best friend.

Here are some related videos from WWDC 2015 that may be of interest:

- Mysteries of Auto Layout, Part 1 [apple.co/1D47aKk](https://developer.apple.com/videos/wwdc/2015/?id=218)
- Mysteries of Auto Layout, Part 2 [apple.co/1HTcVJy](https://developer.apple.com/videos/wwdc/2015/?id=219)
- Implementing UI Designs in Interface Builder [apple.co/1H5vS84](https://developer.apple.com/videos/wwdc/2015/?id=407)
