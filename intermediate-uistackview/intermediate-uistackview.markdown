# Chapter 7: Intermediate UIStackView

Welcome back! In the previous chapter, you spent some quality time with stack views and masterfully spaced a row buttons with a horizontal stack view. Moreover, you left the days of using dummy container views in the dust because also started playing around with layout guides and layout anchors, and you used them vertically center two labels in a table view cell. There's no looking back now. 

In this chapter, you'll make further improvements to the Vacation Spots app by using – you guessed it – stack views.

## Getting started

Open your project from the previous chapter to continue from where you left off, or open the **VacationSpots-Starter** project for this chapter.

### A recap of your to-do's

Here's a quick recap of the four tasks needed to improve `SpotInfoViewController`; these were laid out for you in the previous chapter .

1. Equally space the bottom row of buttons. **Done!**

2. After pressing the Hide button, the section below it should reposition to occupy the empty space. **Not Done.**

3. Swap the positions of the What to See and **Weather** sections. **Not Done.**

4. Increase the spacing between sections in landscape mode so that the bottom row of buttons is a comfortable distance from the bottom edge of the view. **Not Done.**

For extra credit, you'll add some animations to spruce things up a bit.

## Converting the sections

Before you can check off the rest of your to-do's, you need to convert all of the sections in `SpotInfoViewController` to use stack views. 

And as you work through this section, it just so happens that you'll learn about the various properties you can use to configure a stack view, such as `alignment`, `distribution` and `spacing`.

### Rating section

The Rating section is the low-hanging fruit here, because it's the simplest one to embed in a stack view. So, you'll convert it first.

Select the **Rating:** label and the stars label next to it:

![bordered width=90%](images/01-select-rating-label-and-stars-label_600x100.png)

Then click on the **Stack** button to embed them in a stack view. It's this button at the bottom of the storyboard window:

![bordered width=45%](images/stack-button.png)

You can also use the menu bar, **Editor \ Embed in \ Stack View**. Whichever way you go about it, this is the result:

![bordered width=90%](images/02-after-clicking-stack_626x93.png)

Now click on the **Pin** button -- that's the square TIE Fighter-looking icon that's sitting to the right of the stack button. With the **Constrain to margins** box checked, add these constraints:
- Top: 20
- Leading: 0
- Bottom: 20

![bordered width=30%](images/03-add-second-stack-view-constraints_287x412.png)

Now go to the **attributes inspector** and set the spacing to **8**:

![bordered width=90%](images/04-set-spacing-to-8_621x100.png)

>**Note:** You may get a _Misplaced Views_ warning here. In fact, you may become old friends when you're making changes to a stack view's frame; updating frames won't eliminate the warning. Just go about your business and the warning will go away as you continue working with the stack view. Or, you can force it to go away by moving the stack view by one point and then back by using the arrow keys.

Build and run to verify that everything looks exactly the same as before.

## Unembedding a stack view

Before you go too far, you'll need some basic "first aid" training. Trust me, it'll come in handy because sometimes you'll find yourself with an extra stack view that you no longer need, perhaps because of experimentation, refactoring or just because. 

Fortunately, there is an easy way to _unembed_ views from a stack view.

First, select the stack view you want to remove. Then either choose **Editor\Unembed** from the menu, or hold down the **Option** key and click on the **Stack** button. When you see the context menu, click **Unembed**.

And just like that, it's gone.

![bordered width=30%](images/05-how-to-unembed_187x73.png)


## Fix "Why Visit"

And now, you'll create your first vertical stack view. Select the **Why Visit:** label and the **&lt;whyVisitLabel>** below it:

![bordered width=96%](images/06-select-why-visit-labels_640x88.png)

Xcode is pretty smart, so it'll infer that you'd like a vertical stack view based on the position of the labels. Click the **Stack** button to embed both of these into a stack view:

![bordered width=96%](images/07-embed-why-visit-labels_640x88.png)

The bottom label previously had a constraint pinning it to the right margin of the view, but that constraint vanished when it was embedded into this stack view. Currently, your stack view has no constraints, so it adopts the intrinsic width of its largest view.

With the stack view selected, click on the **Pin** button. You'll add a total of four constraints. First, with the **Constrain to margins** option selected, add **Top**, **Leading** and **Trailing** constraints of **0**. 

Then, click on the dropdown next to the bottom constraint and select **Weather: (current distance = 20)**:

![bordered width=55%](images/08-dont-select-nearest-neighbor_463x415.png)

By default, constraints are shown for the nearest neighbor, which for the bottom constraint was the **Hide** button at a distance of 15. However, you wanted the constraint to be to the **Weather:** label below it.

[Author TODO: The last paragraph confused me. Please check that the edited version is both accurate and clear!]

Finally, click **Add 4 Constraints**. You should now see the following:

![bordered width=96%](images/09-why-visit-stack-view-stretched_640x100.png)

Now you have an expanded stack view with its right edges pinned to the right margin of the view. However, the bottom label is still the same width.

### Alignment property

Remember how you previously learned that the `distribution` property specifies how a stack view lays out its views along its _axis_, and you set the bottom stack view's `distribution` to _Equal Spacing_ to space the buttons within it equally? 

![bordered width=40%](images/i_did_that.png)

Well, meet `alignment`. It's the property that determines how a stack view lays out its views _perpendicular_ to its axis. For a vertical stack view, the possible values are `Fill`, `Leading`, `Center` and `Trailing`.

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

Specifying `Fill` means you want all the views to completely fill the stack view perpendicular to its axis. This causes the green **What to See:** label to expand itself to the right edge as well.

But what if you don't want the label to expand itself to the edge?

For now, it doesn't matter since both labels will have a clear background at runtime, but it'll matter when you're converting the weather section. 

You'll learn how to accomplish that with the use of an additional stack view.

### Change "What to See"

You'll find that the things you do in this section are similar to the **Fix "Why Visit"** section, so the instructions are brief.

1. First, select the **What to See:** label and the **&lt;whatToSeeLabel>** below it.
2. Click on the **Stack** button.
3. Click on the **Pin** button.
4. Add the following **four** constraints, making sure to select the margins option:

```bash
top: 20, leading: 0, trailing: 0, bottom: 20
```
5. Set the stack view's **Alignment** to **Fill**.

Your storyboard should look like this:
![bordered width=70%](images/16-after-what-to-see-section_640x286.png)

Build and run to verify that everything still looks the same.

That leaves you with just the **Weather** section to-do. But first, indulge in a quick detour to learn a little more about `alignment`.

## Alignment

The alignment property is an enum of type `UIStackViewAlignment`. As mentioned just a bit ago, its possible values in the vertical direction are:
- `.Fill`
- `.Leading`
- `.Center`
- `.Trailing`

But the values for a _horizontal_ stack view differ slightly. They are:
- `.Fill`
- `.Top`
- `.Center`
- `.Bottom`. 

Here's a nice visual with labels that hold different font sizes to illustrate how each value works:

![bordered width=90%](images/18-vertical-alignment_1200x206.png)

There are also two more properties that are exclusive to the horizontal direction:

- `.FirstBaseline` which uses the baseline of the _first_ line in multi-line text 
- `.LastBaseline` which uses the baseline of the _last_ line in multi-line text.

![bordered width=90%](images/19-baseline-alignment_1200x232.png)

## Move the Weather section

Next on that list of to-dos is juggling the Weather section around. You'll start by adding it to a stack view. 

![bordered width=40%](images/stack_view_easy_peasy.png)

Remember that little hide button? Get ready, because this stack view is a bit more complex due to the inclusion of the **Hide** button.

![bordered width=35%](images/yeah_i_got_this.png)

### One possible approach

>**Note**: This section explores one possible approach, but don't follow along just yet. Consider this first section theoretical, and just absorb it.

You could create a nested stack view by embedding the **Weather:** label and the **Hide** button into a horizontal stack view, and then embed that horizontal stack view and the **&lt;weatherInfoLabel>** into a vertical stack view.

It would look something like this:

![bordered width=90%](images/20-weather-stack-in-stack_640x95.png)

Notice that the **Weather:** label has expanded, so it's equal to the height of the **Hide** button. This isn't ideal since it'll make extra spacing between the **Weather:** label and the text below it.

Remember that `alignment` specifies positioning perpendicular to the stack view. So, you could set `alignment` to `Bottom`:

![bordered width=90%](images/21-weather-stack-in-stack-alignment-bottom_640x95.png)

But then the **Hide** button gets an ego complex and dictates the height of the stack view. Nobody wants a tyrant for a button. 

![bordered width=40%](images/developer_to_do.png)

When the `alignment` of a stack view is set to `fill` and the views are of different sizes in the alignment direction, the stack view determines which views to compress or expand based on the relative content hugging priorities or the content compression resistance priorities of its views. 

In your case, the stack view decides to expand the **Weather:** label because its vertical content hugging priority of 251 is less than the **Hide** button's compression resistance priority of 750.

You could decrease the **Hide** button's vertical compression resistance priority to 200 which would cause the stack view to compress the **Hide** button instead:

![bordered width=90%](images/22-decrease-compression-resistence-priority_640x95.png)

However, this isn't ideal since it would reduce the tap target of the button.

### Actual approach

Surprise! The approach you'll take is to kick the **Hide** button out of the stack view for **Weather**, and it won't live in any stack view for that matter. 

Keep it as a subview of the top-level view, and then add a constraint from it to the **Weather:** label – that will be in the stack view. That's right, you'll add a constraint from a button outside of a stack view to a label placed within a stack view!

![bordered width=40%](images/celebrate_all_lightbulbs.png)

### Change the Weather section – for real

Follow these steps again. Select the **Weather:** label and the **&lt;weatherInfoLabel>** below it:

![bordered width=96%](images/23-select-weather-and-info-label_640x95.png)

Click on the **Stack** button:

![bordered width=96%](images/24-weather-click-stack-button_640x95.png)

Click on the **Pin** button, and add the following constraints (with the margins option checked):

```bash
top: 20, leading: 0, trailing: 0, bottom: 20
```

Set the stack view's **Alignment** to **Fill**:

![bordered width=96%](images/26-weather-alignment-fill_640x95.png)

You need a constraint between the left edge of the **Hide** button to the right edge of the **Weather:** label, so having the **Weather:** label fill the stack view won't work. 

However, you _do_ want the bottom **&lt;weatherInfoLabel>** to fill the stack view. So, embed _just_ the **Weather:** label into a vertical stack view. 

Remember that the `alignment` of a vertical stack view can be set to `.Leading`, and if the stack view is stretched beyond its intrinsic width, its contained views will align to the leading side.

Select only the **Weather:** label using the document outline, or the **Shift-Option-click** trick you learned in the previous chapter:

![bordered width=96%](images/27-select-just-the-weather-label_640x95.png)

Then click on the **Stack** button:

![bordered width=96%](images/28-weather-in-horizontal-stack_640x95.png)

Set the **Alignment** to **Leading**, and make sure the **Axis** is set to **Vertical**:

![bordered width=96%](images/29-vertical-and-leading_640x95.png)

Eureka! You've got the outer stack view stretching the inner stack view to fill the width, but the inner stack view allows the label to keep its original width!

Build and run. Why on earth is that **Hide** button hanging out in the middle of the text?

![bordered width=32%](images/30-hide-label-incorrect-position_750x701.png)

It's because when you embedded the **Weather:** label in a stack view, any constraints between it and the **Hide** button vanished like that ubiquitous lost sock.

So put it back. **Control-drag** from the **Hide** button to the **Weather:** label:

![bordered width=50%](images/31-drag-to-weather-label_420x100.png)

Hold down **Shift** to select multiple options, and select **Horizontal Spacing** and **Baseline**. Then click on **Add Constraints**:

![bordered width=40%](images/32-add-multiple-constraints_420x222.png)

Build and run. The **Hide** button should now be in perfect position, and since you embedded the label that you've set to hidden in a stack view, pressing **Hide** hides the label, and adjusts the views below it – all without having to manually adjust a single constraint.

![bordered width=32%](images/33-hide-button-works_750x737.png)

Now that all the sections are in unique stack views, you're set to wrap them in an outer stack view, which will make the final two tasks almost stupid simple.

### Top-level stack view

**Command-click** to select all five top-level stack views in the outline view, but make sure you don't select the nested stack view that contains the Weather label:

![bordered width=75%](images/34-select-all-stack-views-in-outline_640x264.png)

Click the **Stack** button:

![bordered width=75%](images/35-stack-all-the-views_640x210.png)

Click the **Pin** button, and with the margins option checked, add constraints of **0** to all edges. 

Set **Spacing** to **20** and **Alignment** to **Fill**:

![bordered width=75%](images/37-set-the-spacing-to-20-and-alignment-to-fill_639x289.png)

Build and run:

![bordered width=32%](images/38-hide-button-lost-again_750x533.png)

Whoops! Did the Hide button lose its mind? Not so much. It just lost its constraints to the **Weather:** label when the **Weather** stack view was embedded in the outer stack view. No biggie, just add constraints to it again in the same way you did before:

**Control-drag** from the **Hide** button to the **Weather:** label, hold down **Shift**, select both **Horizontal Spacing** and **Baseline**. Then click on **Add Constraints**:

![bordered width=50%](images/39-add-constraints-to-button-again_420x221.png)

Build and run. Now the **Hide** button is behaving.

### Repositioning views

Now that all of the sections are in a top-level stack view, you'll modify the position of **What to See** so that it's positioned above the **Weather** section. 

You ready for a big challenge here? Make ready...to drag and drop:

Select the **middle stack view** from the outline view and **drag it between** the first and second view. 

>**Pro tip**: Keep the mouse slightly to the left of the stack views that you're dragging it between, so that it remains a _subview_ of the outer stack view. The little blue circle should be positioned at the left edge between the two stack views and not the right edge:

![bordered width=80%](images/40-drag-and-drop-to-reposition-section_640x162.png)

And now the **Weather** section is third from the top, but since the **Hide** button isn't part of the stack view, it won't be moved, so its frame will now be misplaced and the Hide button will look like its lost its mind again. 

![bordered width=40%](images/seriously_not_again.png)

Click on the **Hide** button to select it:

![bordered width=80%](images/41-hide-button-not-moved_640x150.png)

Then click on the **Resolve Auto Layout Issues** triangle shaped button in the Auto Layout toolbar and under the **Selected Views** section, click on **Update Frames**:

![bordered width=40%](images/42-resolve-auto-layout-issues_356x269.png)

The **Hide** button will now be back in the correct position:

![bordered width=80%](images/43-hide-button-back-to-correct-position_640x100.png)

Granted, repositioning the view with Auto Layout and re-adding constraints would not have been the most difficult thing you've ever done, but didn't this easy interface feel oh-so-much nicer?

### Arranged subviews

Okay, shift gears here because it's time for some theory! 

`UIStackView` has a property named `arrangedSubviews`, and it also has a `subviews` property since it's a subclass of `UIView` – which begs the question about how these two properties differ.

`arrangedSubviews` contains the subviews that the stack view lays out as part of its stack. The order in the array represents the ordering within the stack, whereas the ordering in the `subviews` array represents the front-to-back placement of the subviews. 

`arrangedSubviews` is always a subset of the `subviews` array. (You can't be an arranged subview if you're not even a subview!) Anytime a view is added to `arrangedSubviews` it's automatically added to `subviews`, but not vice versa.

The outline view in a storyboard for a stack view actually represents its `arrangedSubviews`. So, it's not possible to add a view only to the stack view's `subviews` using the storyboard; you'd have to code to accomplish that.

When would you want to add a subview to a stack view, but not to its `arrangedSubviews`? One possible case could be to add a background view.

Views can be programmatically added to the stack view, e.g. to `arrangedSubviews`, by using `addArrangedSubview(_:)` or `insertArrangedSubview(_:atIndex:)`.

To remove an arranged subview, you can use `removeArrangedSubview(_:)`, however, using this method doesn't remove the view from the `subviews` array, so it doesn't actually get removed from the view hierarchy until you call the view's `removeFromSuperview()` method. 

You can take the shortcut of just calling `removeFromSuperview()`, since this will also remove it from `arrangedSubviews`.

To _temporarily_ remove an arranged subview, you can set its `hidden` property to `true`. The stack view will detect this and automatically resize and move the other subviews. This is what's happening already when you tap the Hide / Show button for the weather section.

### Size class based configuration

And now to the very last task on your list. In landscape mode, vertical space is at a premium, so you want the components of the stack to cinch together. 

To do this, you'll use size classes to set the spacing of the top-level stack view to **10** instead of **20** when the vertical size class is compact.

Select the top-level stack view and click on the little **+** button next to **Spacing**:

![bordered width=33%](images/44-select-plus-button_260x137.png)

Choose **Any Width** > **Compact Height**:

![bordered width=50%](images/45-anywidth-compact-height_403x108.png)

And set the **Spacing** in the new **wAny hC** field to **10**:

![bordered width=33%](images/46-set-spacing-to-10_260x160.png)

Build and run. Portrait mode should be unchanged, so rotate the simulator (⌘←) to see your handiwork. Note that spacing between sections has decreased and the buttons now have ample space from the bottom of the view:

![bordered iphone-landscape](images/47-spacing-in-iphone-landscape_1334x750.png)

If you didn't add a top-level stack view, you _could_ have used size classes to set the vertical spacing to 10 on each of the four constraints that separate the five sections, but why? You just changed the look of your app with a single setting! 

There's better things to do with your time, like animating stuff to make this a pretty app. 

## Animation

Currently, it's a bit jarring when hiding and showing the Weather details. It's the perfect place to add some animation to smooth the transition between the hidden and non-hidden states. 

### Animating hidden

Start with the hiding animation; all you have to do is update the hidden property within an animation block.

Open **SpotInfoViewController.swift** and take a look at `updateWeatherInfoViews(hideWeatherInfo:animated:)`. When the user taps Hide, the current state gets saved. `animated: false` calls this method in `viewDidLoad()`, and when the button is pressed, it gets called with `animated: true`, so the method already receives the `animate` parameter correctly.

In the `updateWeatherInfoViews`, you'll see this line:

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

Build and run, and tap the **Hide/Show** button. Much better, but since implementing the animation was that easy, why not take it a step further by adding some bounce?

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

Build and run. You should now see a nice, subtle bounce when you tap **Hide/Show**.

In addition to animating the hidden property on views contained within the stack view, you can also animate properties on the stack view itself, such as `alignment`, `distribution` and `spacing`.

You can even animate the `axis`, and in fact, that's what you'll do next.

### Animating the axis

Open **Main.storyboard** and locate the Rating stack view in the outline view. Open the assistant editor and **Control-drag** to **SpotInfoViewController** in the assistant editor to create an outlet.

![bordered width=96%](images/48-create-outlet_1050x192.png)

Name the outlet `ratingStackView` and click on **Connect**:

![bordered width=44%](images/49-name-outlet_490x216.png)

Open **SpotInfoViewController.swift** in the main editor and in `updateWeatherInfoViews(hideWeatherInfo:animated:)`, replace the `nil` completion block:

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

This makes it so that once the initial **Hide** or **Show** button animation completes, and if the Weather info was just hidden, then the `axis` of the `ratingStackView` changes to horizontal. When the weather is shown again, the `axis` will be set back to vertical.


![bordered width=32%](images/50-rating-animation_750x514.png)


Also, in order to show the `axis` of the `ratingStackView` correctly when the view first appears, add the following line to update the axis right below the existing line in the `else` clause:

```swift
} else {
  weatherInfoLabel.hidden = shouldHideWeatherInfo // existing line

  // Add the following line
  ratingStackView.axis = shouldHideWeatherInfo ? .Vertical : .Horizontal
}
```

## Where to go from here?

In this chapter, you continued your dive into stack views and learned about the various properties that a stack view uses to lay out its subviews. 

As you now know, stack views are highly configurable, and there may be more than one way to get the result you're looking for. 

The best way to build on what you've learned is to experiment with various properties for yourself. Instead of setting a property and moving on, see how setting other properties affects the layout of views in the stack view.

One way to speed up your learning is to test yourself, so before you change a property on a stack view, quiz yourself mentally to see if you can predict the change that will occur, and then see if your expectations match reality.

Stack views are now your new view hierarchy building blocks. Get to know them – and know them well. Really, just make them your new best friend.

Here are some videos from WWDC 2015 that will be of interest to continue learning more about stack views:

- [Mysteries of Auto Layout, Part 1 (http://apple.co/1D47aKk)](https://developer.apple.com/videos/wwdc/2015/?id=218)
- [Mysteries of Auto Layout, Part 2 (http://apple.co/1HTcVJy)](https://developer.apple.com/videos/wwdc/2015/?id=219)
- [Implementing UI Designs in Interface Builder (http://apple.co/1H5vS84)](https://developer.apple.com/videos/wwdc/2015/?id=407)