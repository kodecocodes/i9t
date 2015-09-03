## Chapter X: Your App on the Web

Since the beginning of iOS, native and web technologies have been two distinctly separate camps. One is a closed ecosystem tightly controlled by Apple whereas the other is based on long-standing open standards. On iOS, these two worlds wouldn't often cross paths, and when they did it wasn't easy or pretty. What happened in one world, say a mobile website, wouldn't at all affect what happened in the other, say the native app. 

For the past few years, Apple has worked to shorten the distance between web and native. For example, in iOS 7 Apple introduced JavaScriptCore — a framework meant to bridge native code with JavaScript. On iOS 8, Apple introduced more features that brought your website and your app closer together, such as Continuity and shared web credentials.

In iOS 9, Apple is turning it up a notch and tearing down the last remaining walls between native apps and the web. In this chapter you'll read about two important developments in this area: universal HTTP links and web markup as it relates to the new search APIs in iOS 9. Without further ado, let's get started.

## Universal HTTP links

If you've ever linked to a native app, you're probably familiar with universal HTTTP link's predecessor: "deep" links. Before diving into universal HTTP links, let's do a quick refresher on deep links so you know exactly how they differ from what we have now.

Prior to iOS 9, the main way to let apps communicate with each other was to register a custom URL scheme by adding a key to your Info.plist file. For example, if you're developing a social network app for clowns you would have registered clownapp:// or something similar.

iOS would then round up all of the apps on your phone and look at all the custom URL schemes that were registered. Then if it came across a URL that contained a custom URL scheme handled by an installed apps, it would open that app and pass in the entire link.



## Web Markup

Web markup is a portion of a much bigger search topic introduced in iOS 9

### Add markup for mobile deep links

### Enable smart banners

### Semantic markup using Open Graph

### Validation Tool

## Where to go form here?

This chapter covered a lot of ground, but you still only dipped your toes in each topic. 

You should also nos miss the following WWDC Sessions:
- [Seamless Linking To Your App (http://apple.co/1IBTu8q)](https://developer.apple.com/videos/wwdc/2015/?id=509)
- [Introducing Search APIs (http://apple.co/1He5uhh)](https://developer.apple.com/videos/wwdc/2015/?id=709)
- [Your App, Your Website, and Safari (http://apple.co/2KBTu8q)(https://developer.apple.com/videos/wwdc/2014/#506)]

~~~~~

Notes:
- What will open your app: WKWebview, UIWebView, Safari, openURL, chrome? (yes)
- Mention you need SSL access to your domain
- Don't append .json to the apple-app-site-association
- Ammend robots.txt if necessary


Blockers:
- SSL access to rwdevcon.com

Resources:
- http://blog.hokolinks.com/how-to-implement-apple-universal-links-on-ios-9/
- WWDC 2015 talk: Seamless Linking to Your app 
- App Search Programming Guide: https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/
- Search validation tool: https://search.developer.apple.com/appsearch-validation-tool

