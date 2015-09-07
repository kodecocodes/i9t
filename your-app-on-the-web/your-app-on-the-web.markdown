## Chapter X: Your App on the Web

Since the beginning of iOS, native and web technologies have been two distinctly separate camps. One is a closed ecosystem tightly controlled by Apple whereas the other is based on long-standing open standards. On iOS, these two worlds wouldn't often cross paths, and when they did it wasn't easy or pretty. What happened in one world, say a mobile website, wouldn't at all affect what happened in the other, say the native app. 

For the past few years, Apple has worked to shorten the distance between web and native. For example, in iOS 7 Apple introduced JavaScriptCore — a framework meant to bridge native code with JavaScript. On iOS 8, Apple introduced more features that brought your website and your app closer together, such as Continuity and shared web credentials.

In iOS 9, Apple is turning it up a notch and tearing down the last remaining walls between native apps and the web. In this chapter you'll read about two important developments in this area: universal HTTP links and web markup as it relates to the new search APIs in iOS 9. Without further ado, let's get started.

## Universal HTTP links

If you've ever linked to a native app, you're probably familiar with universal HTTTP link's predecessor: "deep" links. Before diving into universal HTTP links, let's do a quick refresher on deep links so you know exactly how they differ from what we have now.

Prior to iOS 9, the main way to let apps communicate with each other was to register a custom URL scheme by adding a key to your Info.plist file. For example, if you're developing a social network app for clowns you would have registered clownapp:// or something similar.

iOS would then round up all of the apps on your phone and look at all the custom URL schemes that were registered. Then if the system came across a URL that contained a custom URL scheme handled by an installed app, it would open that app and pass in the entire link.

Deep linking applied to both system apps as well as third-party apps. You may have even come across some of Apple's own URL schemes:

mailto://john.appleseed@apple.com
tel://1-408-555-5555
sms://1-408-555-5555
facetime://user@icloud.com
facetime-audio://user@icloud.com

So if you wanted to "link" into your app from anywhere else in iOS, all you had to do was construct a link with your custom scheme and execute it like this:

````
let url = NSURL(string: "clownapp://home/feed")!
UIApplication.sharedApplication().openURL(url)
````
Doing this would open your app and pass you the entire URL via app delegate method application(_:handleOpenURL:), where you could interpret the URL and respond appropriately. 

This system worked fairly well for a long time (since iOS 3.0!) but it wasn't without major drawbacks:

- Privacy: Unfortunately, UIApplication also shipped with method canOpenURL(_:). The _intended_ purpose of this method was to provide a fallback if your device couldn't handle a particular custom URL. However, it can and was exploited to find out what other apps you have installed. If any app knows that this device can open clownapp://, it means that my social clown app is installed.
- Custom Scheme Collisions: Let's say Facebook's custom URL scheme is fb://. What's stopping anyone else from also registering fb:// and capturing their deep links? In short, nothing. When two apps register for the same custom URL scheme, it's like dividing by zero. It's undefined.
- No Graceful Fallback: What happens if iOS tries to go to URL with a custom scheme that no installed app has registered to handle? Nothing happens — the action fails silently. This is a particularly bad problem going from a mobile browser to a deep link. The browser doesn't have canOpenURL(_:) so it better be sure there's an app backing the custom URL scheme before it tries it.

>>Note: For reference, there are ways for a mobile browser to detect if an app is installed before trying to use its custom scheme by being smart with JavaScript and timeouts. This is "hacky" and violates user privacy so it won't be discussed in this chapter. 

Now that you've read about deep links and its limitations, let's go ahead and implement its successor: universal HTTP links.

## Adding universal links to RWDevCon

For this chapter you'll be working with an app called RWDevCon and its accompanying website http://www.rwdevcon.com. If RWDevCon sounds familiar, it's because it is the developer conference organized by the folks behind raywenderlich.com!

Unlike the rest of the chapters in this book, the "sample app" for this chapter is a real-world production app that's currently on the App Store. That's a lot of responsibility on your shoulders. Are you ready? 

### Getting Your App Ready - Part 1

Instead of coming up and registering with a custom URL scheme, you will tie a domain with a native app. In this chapter, you'll tie rwdevcon.com with the RWDevCon native app. For this to be considered an improvement over the current system, Apple has to make sure only you can claim your website and no one else, right? 

To prove that you are you and that you want to tie your domain to your native app, there are two bonds you have to create. The first one is from your native app to your domain. The second, covered in the next section, ties your domain to your native app. 

Go to the files included with this chapter and open RWDevCon.xcodeproj. In the project navigator, select the RWDevcon project, then the main RWDevCon target and switch to the Capabilities tab and add the following two entries to the Associated Domains section:

//Add image here (/images/associatedDomains.png)

>*Note:* Only a team agent or a team administrator on your Apple developer program can make this change. If you're not those roles, reach out to the right person on the team to make this change. 

### Getting Your Server Ready

The first step to implement universal HTTP links has more to do with the web than with native apps. Open up your favorite text editor and type in the following JSON structure:

```swift
{
    "applinks": {
        "apps": [],
        "details": {
            "KFCNEC27GU.com.razeware.RWDevCon": {
                "paths": [
                    "/videos/rwdevcon/2015/*"
                ]
            }
        }
    }
}
```

Once you're done, name the file **apple-app-site-association** and save it somewhere accessible. The name must match exactly and the file **must not have an extension**, not even .json.



>*Note:* Before uploading your apple-app-site-association file to your server, run your JSON through a JSON validator, such as http://www.jsonlint.com. Typing JSON by hand is prone to error. Having the slightest mistake in your JSON will mean your universal HTTP links won't work at all and you won't know why. Think ahead!

### Getting Your App Ready - Part 2

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
- Get team admin to turn on associated domains

Resources:
- http://blog.hokolinks.com/how-to-implement-apple-universal-links-on-ios-9/
- WWDC 2015 talk: Seamless Linking to Your app 
- App Search Programming Guide: https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/
- Search validation tool: https://search.developer.apple.com/appsearch-validation-tool

