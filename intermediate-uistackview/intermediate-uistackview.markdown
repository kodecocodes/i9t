# Chapter 7: Intermediate UIStackView

Welcome back! In the previous chapter, you were introduced to stack views and used a horizontal stack view to equally space a row of buttons. You also learned about layout guides and layout anchors and used them to vertically center two labels in a table view cell, without the use of dummy container views.

In this chapter, you'll continue learning about stack views by further improving the Vacation Spots app with the use of stack views.

## Getting Started

Open your project from the previous chapter to continue from where you left off, or open the **VacationSpots-Starter** project for this chapter.

### Quick Recap

Here is a quick recap of the 4 tasks mentioned in the previous chapter to improve `SpotInfoViewController`.

1. Equally space the bottom row of buttons. **Done**

2. When the **Hide** button is pressed, reposition the section below it to occupy the empty space.

3. Swap the positions of the **What to See** section and the **Weather** section.

4. Increase the spacing between sections in landscape mode so that the bottom row of buttons isn't too close to the bottom edge of the view.

In addition, you'll add some animation to spruce things up a bit as well.

## Converting the Sections

You'll convert all of the sections in `SpotInfoViewController` to use stack views. As you proceed, you'll learn about the various properties that can be used to configure a stack view, such as `alignment`, `distribution`, and `spacing`.

### Rating Section

The **Rating** section is the simplest one to embed in a stack view so you'll convert it first.

Select the **Rating:** label and the stars label next to it:

![bordered width=90%](images/01-select-rating-label-and-stars-label_600x100.png)

Then click on the **Stack** button to embed them in a stack view. The Stack button is at the bottom of the storyboard window:

![bordered width=45%](images/stack-button.png)

You can also use the menu bar, **Editor \ Embed in \ Stack View**. The result will look like this:

![bordered width=90%](images/02-after-clicking-stack_626x93.png)

Now click on the **Pin** button (that's the square TIE Fighter to the right of the stack button) and with the **Constrain to margins** box checked, add constraints of Top 20, Leading 0 and Bottom 20:

![bordered width=30%](images/03-add-second-stack-view-constraints_287x412.png)

Now go to the **Attributes inspector** and set the spacing to **8**:

![bordered width=90%](images/04-set-spacing-to-8_621x100.png)

>**Note:** You may get a _Misplaced Views_ warning here. In fact, you may get it often when you do something that changes a stack view's frame, and updating frames won't eliminate the warning. The warning will go way on its own as you continue working with the stack view. Or you can force it to go away by moving the stack view by one point and back by using the arrow keys.

Build and run to verify that everything looks exactly the same as before.

### Unembedding a Stack View

Before you proceed too far, some basic first aid training can come in handy! Sometimes you may find yourself with an extra stack view that you no longer need perhaps because of experimentation, refactoring, or just by accident. Fortunately, there is an easy way to _unembed_ views from a stack view.

First select the stack view that you want to remove. Then you can either choose **Editor\Unembed** from the menu, or you can hold down the **Option** key and click on the **Stack** button. You'll see a context menu from which you can click **Unembed**.

![bordered width=30%](images/05-how-to-unembed_187x73.png)


### Why Visit Section

You'll now create your first vertical stack view. Select the **Why Visit:** label and the and the **&lt;whyVisitLabel>** below it:

![bordered width=96%](images/06-select-why-visit-labels_640x88.png)

Xcode will infer that you'd like a vertical stack view based on the position of the labels. Click the **Stack** button to embed both of these into a stack view:

![bordered width=96%](images/07-embed-why-visit-labels_640x88.png)

The bottom label previously had a constraint pinning it to the right margin of the view, but that constraint was removed when it was embedded into this stack view. The stack view does not have any constraints yet and so it adopts the intrinsic width of its largest view.

With the stack view selected, click on the **Pin** button. You'll add a total of **4** constraints. First, with the **Constrain to margins** option selected,  add **Top**, **Leading** and **Trailing** constraints of **0**. 

Then, click on the dropdown next to the bottom constraint and select **Weather: (current distance = 20)**:

![bordered width=55%](images/08-dont-select-nearest-neighbor_463x415.png)

By default, constraints are shown for the nearest neighbor, which for the bottom constraint was the **Hide** button at a distance of 15, but you instead wanted the constraint to be to the **Weather:** label below it.

Finally, click **Add 4 Constraints**. You should now see the following:

![bordered width=96%](images/09-why-visit-stack-view-stretched_640x100.png)

The stack view itself has expanded so that its right edges are pinned to the right margin of the view, however, the bottom label is still the same width.

You previously learned that the `distribution` property specifies how a stack view lays out its views along its axis, and you had set the bottom stack view's `distribution` to Equal Spacing to space the buttons within it equally.

The property that determines how a stack view lays out its views _perpendicular_ to its axis is the `alignment` property. For a vertical stack view, the possible values are `Fill`, `Leading`, `Center`, and `Trailing`.

![bordered width=30%](images/10-vertical-alignment-values_260x131.png)

Select each value to see how it affects the placement of the labels in the stack view:

**Fill:**
![bordered width=96%](images/11-alignment-fill_650x60.png)

**Leading:**
![bordered width=96%](images/12-alignment-leading_650x60.png)

**Center:**
![bordered width=96%](images/13-alignment-center_650x60.png)

**Trailing:**
![bordered width=96%](images/14-alignment-trailing_650x60.png)

When you are done testing each value, set the **Alignment** to **Fill**:

![bordered width=96%](images/15-set-to-fill-duplicate_650x60.png)

Then build and run to verify that everything looks good, and that there are no regressions.

Specifying `Fill` means that you want all views in the stack view to completely fill the stack view perpendicular to its axis. You'll notice that this causes the green **What to See:** label to expand itself to the right edge as well.

What if you didn't want the label to expand itself to the edge? For now it doesn't matter since both labels will have a clear background at runtime, but it will matter when converting the weather section, and you'll learn how to accomplish that with the use of an additional stack view.

### What to See Section

This section is very similar to the **Why Visit** section, so the steps here are brief.

1. First, select the **What to See:** label and the **&lt;whatToSeeLabel>** below it.
2. Click on the **Stack** button.
3. Click on the **Pin** button.
4. Add the following **4** constraints, with the margins option selected:

```bash
top: 20, leading: 0, trailing: 0, bottom: 20
```
5. Set the stack view's **Alignment** to **Fill**.

At this point, your storyboard should look like the following:
![bordered width=70%](images/16-after-what-to-see-section_640x286.png)

Build and run to verify that everything still looks the same.

Now only the **Weather** section remains. But first a quick detour to learn a little more about the `alignment` property.

### Alignment

The `alignment` property is an enum of type `UIStackViewAlignment`. Its possible values in the vertical direction are `.Fill`, `.Leading`, `.Center`, and `.Trailing` which you saw in the previous section.

The possible `alignment` values for a _horizontal_ stack view differ slightly. They are `.Fill`, `.Top`, `.Center`, and `.Bottom`. The following labels contain text with different font sizes to illustrate the different alignment values:

![bordered width=90%](images/18-vertical-alignment_1200x206.png)

There are also two more properties that are valid only in the horizontal direction, `.FirstBaseline` which uses the baseline of the first line in multi-line text and `.LastBaseline` which uses the baseline of the last line in multi-line text.

![bordered width=90%](images/19-baseline-alignment_1200x232.png)

### Weather Section

The next task is to add the **Weather** section to a stack view. This stack view is a bit more complex than the others due to the inclusion of the **Hide** button.

#### One Possible Approach

>**Note**: This section explores one possible approach that can be taken but don't follow along just yet. Consider this first section theoretical.

One approach you could take is to embed the **Weather:** label and the **Hide** button into a horizontal stack view, and then embed that horizontal stack view and the **&lt;weatherInfoLabel>** into a vertical stack view, to created a nested stack view.

That would look something like this:

![bordered width=90%](images/20-weather-stack-in-stack_640x95.png)

Notice that the **Weather:** label has expanded to be equal to the height of the **Hide** button. This isn't ideal since this will cause there to be extra spacing between the **Weather:** label and the text below it.

Recall that `alignment` specifies positioning perpendicular to the stack view. You could set the `alignment` to `Bottom`:

![bordered width=90%](images/21-weather-stack-in-stack-alignment-bottom_640x95.png)

But you really don't want the height of the **Hide** button to dictate the height of the stack view.

When the `alignment` of a stack view is set to Fill and the views are of different sizes in the alignment direction, the stack view determines which views to compress or expand based on the relative content hugging priorities or the content compression resistance priorities of its views. In this case, the stack view decides to expand the **Weather:** label because its vertical content hugging priority of 251 is less than the **Hide** button's compression resistance priority of 750.

You could decrease the **Hide** button's vertical compression resistance priority to 200 which would cause the stack view to compress the **Hide** button instead:

![bordered width=90%](images/22-decrease-compression-resistence-priority_640x95.png)

However, this isn't ideal since this would reduce the tap target of the button.

#### Actual Approach

The approach you'll take is to have the **Hide** button _not_ be in the stack view for the **Weather** section, or any other stack view for that matter. It will remain a subview of the top-level view, and you'll add a constraint from it to the **Weather:** label that will be in the stack view. That's right, you'll add a constraint from a button outside of a stack view to a label placed within a stack view!

Now you can start following these steps again. Select the **Weather:** label and the **&lt;weatherInfoLabel>** below it:

![bordered width=96%](images/23-select-weather-and-info-label_640x95.png)

Click on the **Stack** button:

![bordered width=96%](images/24-weather-click-stack-button_640x95.png)

Click on the **Pin** button and add the following constraints (with the margins option checked):

```bash
top: 20, leading: 0, trailing: 0, bottom: 20
```

Set the stack view's **Alignment** to **Fill**:

![bordered width=96%](images/26-weather-alignment-fill_640x95.png)

You want to add a constraint between the left edge of the **Hide** button to the right edge of the **Weather:** label. So having the **Weather:** label fill the stack view won't work. However, you still want the bottom **&lt;weatherInfoLabel>** to fill the stack view.

You can accomplish this by embedding just the **Weather:** label into a vertical stack view. Recall that the `alignment` of a vertical stack view can be set to `.Leading` and if the stack view is stretched beyond its intrinsic width, its contained views will remain aligned to the leading side.

Select only the **Weather:** label (using the document outline, or the shift-option-click trick you learned in the previous chapter):

![bordered width=96%](images/27-select-just-the-weather-label_640x95.png)

Then click on the **Stack** button:

![bordered width=96%](images/28-weather-in-horizontal-stack_640x95.png)

Set the **Alignment** to **Leading**, and make sure the **Axis** is set to **Vertical**:

![bordered width=96%](images/29-vertical-and-leading_640x95.png)

Perfect! What's happening here is that the outer stack view is stretching the inner stack view to fill the width, but the inner stack view allows the label to keep it's original width!

Build and run. Note that the **Hide** button is not positioned correctly:

![bordered width=32%](images/30-hide-label-incorrect-position_750x701.png)

This is because when the **Weather:** label was embedded in a stack view any constraints between it and the **Hide** button were removed.

**Control-drag** from the **Hide** button to the **Weather:** label:

![bordered width=50%](images/31-drag-to-weather-label_420x100.png)

Hold down **Shift** to select multiple options, and select **Horizontal Spacing** and **Baseline**. Then click on **Add Constraints**:

![bordered width=40%](images/32-add-multiple-constraints_420x222.png)

Build and run. The **Hide** button should now be positioned correctly, and since the label that is being set to hidden is embedded in a stack view, pressing **Hide** will hide the label, and will also adjust the views below it, all without having to manually adjust any constraints.

![bordered width=32%](images/33-hide-button-works_750x737.png)

Now that each individual section is in a stack view, you're all set to place the individual stack views in an outer stack view which will make the final two tasks trivial.

### Top-Level Stack View

**Command-click** to select all five top-level stack views in the outline view (don't select the nested stack view that contains the Weather label):

![bordered width=75%](images/34-select-all-stack-views-in-outline_640x264.png)

Click the **Stack** button:

![bordered width=75%](images/35-stack-all-the-views_640x210.png)

Click the **Pin** button and with the margins option checked add constraints of **0** to all edges. 

Set the **Spacing** to **20** and the **Alignment** to **Fill**:

![bordered width=75%](images/37-set-the-spacing-to-20-and-alignment-to-fill_639x289.png)

Build and run:

![bordered width=32%](images/38-hide-button-lost-again_750x533.png)

Whoops, looks like the **Hide** button lost its constraints to the **Weather:** label when the **Weather** stack view was embedded in the outer stack view. No problem, just add constraints to it again in the same way you did before:

**Control-drag** from the **Hide** button to the **Weather:** label, hold down **Shift**, select both **Horizontal Spacing** and **Baseline**. Then click on **Add Constraints**:

![bordered width=50%](images/39-add-constraints-to-button-again_420x221.png)

Build and run. The **Hide** button should now be positioned correctly.

### Repositioning Views

Now that all of the sections are in a top-level stack view, you'll correct the position of the **What to See** section so that it's positioned above the **Weather** section. All it will take now is a drag and drop:

Select the middle stack view from the outline view and drag it right between the first and second view. Make sure that you keep the mouse slightly to the left of the stack views that you are dragging it in between, so that it remains a subview of the outer stack view. The little blue circle should be positioned at the left edge between the two stack views and not the right edge:

![bordered width=80%](images/40-drag-and-drop-to-reposition-section_640x162.png)

The **Weather** section is now the third one but since the **Hide** button isn't part of the stack view it won't be moved, so its frame will now be misplaced. Click on the **Hide** button to select it:

![bordered width=80%](images/41-hide-button-not-moved_640x150.png)

Then click on the **Resolve Auto Layout Issues** triangle shaped button in the Auto Layout toolbar and under the **Selected Views** section, click on **Update Frames**:

![bordered width=40%](images/42-resolve-auto-layout-issues_356x269.png)

The **Hide** button will now be back in the correct position:

![bordered width=80%](images/43-hide-button-back-to-correct-position_640x100.png)

Now granted, repositioning the view with Auto Layout and re-adding constraints would not have been the most difficult thing to do, but doesn't this feel so much nicer?

### Arranged Subviews

It's time for some theory! `UIStackView` has a property named `arrangedSubviews`, and it also has a `subviews` property since it's a subclass of `UIView`, which begs the question about how these two properties differ.

`arrangedSubviews` contains the subviews that the stack view is laying out as part of its stack. The order in the array represents the ordering within the stack, whereas the ordering in the `subviews` array represents the front-to-back placement of the subviews. `arrangedSubviews` is always a subset of the `subviews` array (you can't be an arranged subview if you're not even a subview!). Anytime a view is added to `arrangedSubviews` it automatically gets added to `subviews` but not vice versa.

The outline view in a storyboard for a stack view actually represents its `arrangedSubviews`. So it's not possible to add a view only to the stack view's `subviews` using the storyboard, that would have to be done in code.

When would you want to add a subview to a stack view, but not to its `arrangedSubviews`? One possible case could be to add a background view.

Views can programmatically be added to the stack view (i.e. to `arrangedSubviews`) by using `addArrangedSubview(_:)` or `insertArrangedSubview(_:atIndex:)`.

To remove an arranged subview, you can use `removeArrangedSubview(_:)`, however, using this method does not remove the view from the `subviews` array so it doesn't actually get removed from the view hierarchy until you call the view's `removeFromSuperview()` method. You can take the shortcut of just calling `removeFromSuperview()` since this will also remove it from `arrangedSubviews`.

To _temporarily_ remove an arranged subview, you can set its `hidden` property to `true`. The stack view will detect this and automatically resize and move the other subviews. This is what's happening already when you tap the Hide / Show button for the weather section.

### Size Class based Configuration

There is one final task that remains from the initial list. In landscape mode, vertical space is at a premium so you want to bring the components of the stack closer together. To do this, you'll use size classes to set the spacing of the top-level stack view to **10** instead of **20** when the vertical size class is compact.

Select the top-level stack view and click on the little **+** button next to **Spacing**:

![bordered width=33%](images/44-select-plus-button_260x137.png)

Choose **Any Width** > **Compact Height**:

![bordered width=50%](images/45-anywidth-compact-height_403x108.png)

And set the **Spacing** in the new **wAny hC** field to **10**:

![bordered width=33%](images/46-set-spacing-to-10_260x160.png)

Build and run. There should be no changes in portrait mode. Now rotate the simulator (⌘←). Note that the spacing between the sections has decreased and the buttons now have ample space from the bottom of the view:

![bordered iphone-landscape](images/47-spacing-in-iphone-landscape_1334x750.png)

If you didn't add a top-level stack view, you could still have used size classes to set the vertical spacing to 10 on each of the four constraints separating the five sections, but isn't it so much better to set it in just a single place?

## Animation

### Animating Hidden

Currently, hiding and showing the Weather details text is a bit jarring. It would be nice to add some animation so that the transition between the hidden and non-hidden state is a bit smoother. In order to animate the hiding, all you have to do is update the hidden property within an animation block.

Open **SpotInfoViewController.swift** and take a look at the `updateWeatherInfoViews(hideWeatherInfo:animated:)` method. When the user taps the **Hide** button the current state gets saved. In `viewDidLoad()` this method gets called with `animated: false` and when the button is pressed it gets called with `animated: true`, so the method already receives the `animate` parameter correctly.

In the `updateWeatherInfoViews` method, you'll see a this line:

```swift
weatherInfoLabel.hidden = shouldHideWeatherInfo
```
Replace that line with the following code:

```swift
if animated {
  UIView.animateWithDuration(0.3) {
    self.weatherInfoLabel.hidden = shouldHideWeatherInfo
  }
} else {
  weatherInfoLabel.hidden = shouldHideWeatherInfo
}
```

Build and run, and tap on the **Hide/Show** button. This looks much nicer, but you can take it a step further by adding some bounce to it.

Replace the following 3 lines:

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

Build and run. You should now see a nice subtle bounce when you tap **Hide/Show**.

In addition to animating the hidden property on views contained within the stack view, you can also animate properties on the stack view itself such as `alignment`, `distribution`, and `spacing`.

You can even animate the `axis`, and in fact that's what you'll do next.

### Animating the Axis

Open **Main.storyboard** and locate the Rating stack view in the outline view. Open the assistant editor and **Control-drag** to **SpotInfoViewController** in the assistant editor to create an outlet.

![bordered width=96%](images/48-create-outlet_1050x192.png)

Name the outlet `ratingStackView` and click on **Connect**:

![bordered width=44%](images/49-name-outlet_490x216.png)

Open **SpotInfoViewController.swift** in the main editor and in `updateWeatherInfoViews(hideWeatherInfo:animated:)` replace the nil completion block:

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

Now once the initial **Hide** or **Show** button animation completes, if the Weather info was just hidden, then the `axis` of the `ratingStackView` will change to horizontal. When the weather is shown again the `axis` will be set back to vertical.


![bordered width=32%](images/50-rating-animation_750x514.png)


Also in order to show the `axis` of the `ratingStackView` correctly when the view first appears add the following line to update the axis right below the existing line in the else clause:

```swift
} else {
  weatherInfoLabel.hidden = shouldHideWeatherInfo // existing line

  // Add the following line
  ratingStackView.axis = shouldHideWeatherInfo ? .Vertical : .Horizontal
}
```

## Where To Go From Here?

In this chapter you continued learning about stack views, and learned about the various properties that a stack view uses to lay out its subviews. Stack views are highly configurable, and there may be more that one way to get the result you are looking for. The best way to continue learning is to experiment with various properties yourself. Instead of setting a property and moving on, see how setting other properties affect the layout of views in the stack view.

One way to speed up your learning is to test yourself, so before you change a property on a stack view, quiz yourself mentally to see if you can predict the change that will occur, and see if your expectations match reality. Stack views are now your new view hierarchy building blocks. Get to know them and well and make them your best friend.

Here are some videos from WWDC 2015 that will be of interest to continue learning more about stack views:

- [Mysteries of Auto Layout, Part 1 (http://apple.co/1D47aKk)](https://developer.apple.com/videos/wwdc/2015/?id=218)
- [Mysteries of Auto Layout, Part 2 (http://apple.co/1HTcVJy)](https://developer.apple.com/videos/wwdc/2015/?id=219)
- [Implementing UI Designs in Interface Builder (http://apple.co/1H5vS84)](https://developer.apple.com/videos/wwdc/2015/?id=407)
