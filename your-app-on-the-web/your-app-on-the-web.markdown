# Chapter 2: Your App on the Web

Since the beginning of iOS, native and web technologies have been two distinctly separate camps. One is a closed ecosystem tightly controlled by Apple whereas the other is open and based on long-standing standards. On iOS, these two worlds don't often cross paths. When they did it wasn't easy or pretty. What happened in one world, say a mobile website, wouldn't affect what happened in the other, say the native app. 

Over the past couple of years, Apple has worked to shorten the distance between web and native. For example, in iOS 7 Apple introduced JavaScriptCore — a framework meant to bridge native code with JavaScript. On iOS 8, Apple introduced more features that brought your website and your app closer together, such as Continuity features like shared web credentials.

In iOS 9, Apple is going one step further and tearing down the last remaining walls between native apps and the web. In this chapter you'll read about two important developments in this area: universal links and web markup as it relates to the new search APIs in iOS 9 that you read in the last chapter. Without further ado, let's get started.

## Universal Links

If you've ever linked into a native app, either from a website or from another app, then you're probably familiar with universal links' predecessor: "deep" links. Before diving into universal links, let's do a quick refresher on deep links so you know exactly how they differ from the new technology you'll explore in this chapter.

Prior to iOS 9, the primary way to let apps communicate with each other was to register a custom URL scheme by adding a key to your **Info.plist**. For example, if you were developing a social network app for clowns you would have registered something like `clownapp://` or `clown://`.

iOS would then round up all of the apps on your phone and look at all the custom URL schemes that they registered. When iOS encountered a custom URL scheme handled by an installed app, the system would open that app and pass in the entire link.

Deep linking applied to system apps as well as third-party apps. You may have come across some of Apple's own URL schemes:

- Mail.app: mailto://john.appleseed@apple.com
- Phone.app: tel://1-408-555-5555
- Phone.app: sms://1-408-555-5555
- Facetime.app: facetime://user@icloud.com

So if you wanted to link into your app from anywhere else in iOS, all you had to do was construct a link with your URL custom scheme and execute it like this:

````
let url = NSURL(string: "clownapp://home/feed")!
UIApplication.sharedApplication().openURL(url)
````
iOS would then open your app and pass in the entire URL via the app delegate method `application(_:handleOpenURL:)`. Once inside that method, the app could interpret the URL whichever way it wanted and respond appropriately. 

This system worked fairly well for a long time (since iOS 3.0!) but had some major drawbacks:

1. **Privacy:** In addition to `openURL()`, `UIApplication` also has `canOpenURL(_:)`. The _intended_ purpose of this innocent-looking method was to provide a fall back if your device couldn't handle a particular custom URL. Unfortunately, it was exploited to find out what other apps a user has installed. For instance, if any app knows that a particular device can open `clownapp://`, it must mean that my social clown app is installed.
- **Collisions**: Let's say Facebook's custom URL scheme is fb://. What's stopping anyone else from also registering fb:// and capturing their deep links? In short, nothing. When two apps register for the same custom URL scheme, it's like dividing by zero. It's undefined.
- **No Fall back**: What happens if iOS tries to use a URL with a custom URL scheme that no installed app has registered? Nothing happens. The action fails silently. This problem gets worse on a mobile browser. A browser doesn't have `canOpenURL(_:)` so it better be sure there's an app backing the custom URL scheme before trying it.

>> **Note:** There is a way for a mobile browser to detect if an app is installed before trying to use its custom URL scheme by being smart with JavaScript and timeouts. This is "hacky" and violates user privacy so it won't be discussed in this chapter. 

Now that you've read about deep links and its limitations, let's go ahead and implement its successor: universal HTTP links.

## Adding universal links to RWDevCon

For this chapter you'll be working with an app called RWDevCon and its accompanying website http://www.rwdevcon.com. If RWDevCon sounds familiar, it's because it is the developer conference organized by the folks behind raywenderlich.com!

Unlike the rest of the chapters in this book, the "sample app" for this chapter is a real-world production app currently on the App Store.

> **Note:** This is one of the only, if not the only, places in the book where you won't be able to verify your work as you follow along. Apple made the connection between an app and its accompanying website extremely secure, so there's no way to "try out" this feature without having a real website accessible via `https` as well as an app in the App Store under an account where you are either the team agent or the team admin. 


### Getting Your App Ready - Part 1

Instead of registering a custom URL scheme, you will tie a domain with a native app. In this chapter, you'll tie rwdevcon.com with the RWDevCon native app. For this to be considered an improvement over the current system, Apple has to make sure only you can claim your website and no one else, right? 

To prove that you are you and that you want to tie your domain to your native app, there are two bonds you have to create. The first one is from your native app to your domain. The second, covered in the next section, ties your domain to your native app. 

Go to the files included with this chapter and open RWDevCon.xcodeproj. In the project navigator, select the RWDevcon project, then the main RWDevCon target and switch to the Capabilities tab and add the following two entries to the Associated Domains section:

![bordered height=35%](/images/associatedDomains.png)

>*Note:* Only a team agent or a team administrator on your Apple developer program can make this change. If you're not those roles, reach out to the right person on the team to make this change. 

### Getting Your Server Ready

Next, you have to create the link from your website to your native app. Open up your favorite text editor and type in the following JSON structure:

```
{
    "applinks": {
        "apps": [],
        "details": {
            "KFCNEC27GU.com.razeware.RWDevCon": {
                "paths": [
                    "/videos/*"
                ]
            }
        }
    }
}
```

Once you're done, name the file **apple-app-site-association** and save it somewhere on your computer. You'll need the file in a moment. For this universal HTTP linking to work correctly, this file name must match exactly and it **must not have an extension**, not even .json.

If you worked with some of iOS 8's continuity features, this file will look familiar. The **apple-app-site-association** file was introduced in iOS 8 and it is also used to implement shared web credentials between your website and your app, as well as other continuity features. 

You may be wondering where KFCNEC27GU.com.razeware.RWDevCon came from. It is your App ID, which is a two-part string used to identify an app. The string consists of a Team ID, KFCNEC27GU in this case, followed by a bundle ID, in the form of com.domainname.applicationname or com.razeware.RWDevCon in this case.

The Team ID is supplied by Apple and is unique to a specific development team. KFCNEC27GU is specific to the team that originally developed the RWDevCon app so you'll have to swap that out for your own team identifier. If you're looking for your own team identifier, the easiest way to find it is by logging into Apple's developer portal and going to Your Account > Account Summary. It is listed under Developer Account Summary:

![bordered height=35%](/images/teamID.png)

TODO: blur out Ray's address?

The bundle identifier is easier to find. If you don't know what it is for your app, click on the project file, select the main target and switch to the General Tab. It's listed next to **Bundle Identifier**. The convention is to make the bundle identifier a reverse-DNS notation identifier, such as com.razeware.RWDevCon, where the last component is the app's name.

You may also be wondering where **/videos/** came from. As the name suggests, the paths array contains a list of "white-listed" URL paths that you're letting your app handle instead of your website. If you're a little rusty on your URL components, the path is the part in bold:

    https://www.rwdevcon.com**/videos/2015/inspiration/**?name=Inspiration

If you want your app to open every incoming link for your domain, you can include a "/*" in the paths array and your app will handle everything.

Note: If you're targeting iOS 8 because your app also implements continuity features, you'll have to sign your **apple-app-site-association** file using the openssl. You can read more about this process in Apple's Handoff Programming Guide: https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/Handoff/AdoptingHandoff/AdoptingHandoff.html

Finally, you have to upload this file to the root of your domain. In this case, the file has to be accessible at the following locations **over HTTPS**:

    https://rwdevcon.com/apple-app-site-association
    https://www.rwdevcon.com/apple-app-site-association

If you can see the file when you request them with a web browse, that means you're ready for the next step.

> **Note:** Before uploading your apple-app-site-association file to your server, run your JSON through a JSON validator, such as http://www.jsonlint.com. Typing JSON by hand is prone to error. Having the slightest mistake in your JSON will mean your universal HTTP links won't work at all and you won't know why. Think ahead!

### Getting Your App Ready - Part 2

When the app receives a universal HTTP link, you want to respond by doing more than just opening the app. You want to take user to the correct place in the application! The final step to implement universal links is to handle the incoming URLs in your app. Open Xcode again and head to AppDelegate.swift. Add the following application delegate method:

```swift
  func application(application: UIApplication,
    continueUserActivity
    userActivity: NSUserActivity,
    restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
      let universalURL = userActivity.webpageURL!
      //handle universal URL
      
    }
    
    return true
  }
```

application(_:continueUserActivity:restorationHandler:) also plays a role in adopting Handoff and iOS 9's search APIs, but you'll focus on how to handle incoming universal links. 

If the incoming NSUserActivity is of type NSUserActivityTypeBrowsingWeb, it means you've landded in this method through a universal link. If this is the case, you're guaranteed that the user activity will have a non-nil webpageURL. The next step is to parse this URL into something your app can understand.

## Web Markup

TODO: benefits
- even if your app is not installed, you appear in search results, prompts users to install your app
- makes Handoff much simpler
- Useful for apps that have mirrored content from the web

Web markup is part of a much bigger topic in iOS 9: search. Search includes three different APIs: web markup, NSUserActivity and CoreSpotlight. All three APIs are important to your search strategy in iOS 9, but the second half of this chapter focuses on web markup. If you want to read more about the other two search APIs, read Chapter X, which covers them in detail.

Search in iOS 9 is about to get much better. Searching in an iOS device's Spotlight or in mobile Safari's URL bar will now work a lot like a search engine. Search results will come from a private index as well as a public index. The private index includes the "browsing history" of the user inside a particular app. This will be indexed and searchable through the iOS device.

The public index includes information from two sources: from popular in-app user activities that the app developers have marked as public as well as from the web. Wait a minute, the web? How is that going to work? Apple has developed a web crawler, Applebot, to crawl and index the web for mobile links. Next up, you'll learn about making your website indexable and searchable by Apple.

### Make your website discoverable

Applebot crawls the web far and wide but there's no guarantee that it will find your website. And if it can't find your website, Apple won't be able to index your app links and your app won't show up in Spotlight's organic results. 

Is there anything you can do to make your site more discoverable by Applebot? In fact there is. When you submit an app to the App Store you have to specify a Support URL (required) and a Marketing URL (optional). If any of those points to the app that contains your app links, that's all you have to do.

If you need to change them to point to your app's website, you can do so in iTunes Connect. Simply log into iTunes Connect, go to My Apps and navigate to your app's information page. The fields you want to verify or change are labeled Support URL and Marketing URL:

![bordered height=35%](/images/supportURL.png)

Doing this only ensures that Applebot can see the entry point to your website. The content you want to index should be accessible from this entry point. This means there should be a path of links that takes you from this entry point to the content you want to link.

Something else you can do to make your website discoverable is check that your site's robots.txt file lets Applebot do its job. Robots.txt, also known as the robots exclusion protocol, is a standards used by websites to communicates with web crawlers and other web robots like Applebot. The file specifies parts of the site that the web crawler should **not** scan or process.

Not all web crawlers follow these directives, but Applebot does! If your robots.txt specifies a certain part of your site shouldn't be crawled then those mobile links won't ever show up in Spotlight. You can learn more about the robots exlusion standard in Wikipedia: https://en.wikipedia.org/wiki/Robots_exclusion_standard.

### Enable Smart Banners

Smart Banners have been around since iOS 6. They used to be simple marketing tools provided by Apple that allowed developers to add advertising banners to promote apps directly on a website.

A Smart Banner on your website invites users who don't have your app installed to download it from the App Store and it gives users who already have your app installed an easy way to open a page deep within the app. If you've never seen a Smart Banner before, it looks like this:

![bordered height=35%](/images/appBanner.png)

In iOS 9, Apple is breathing new life into Smart App Banners and making them an integral part of web markup. In addition to being a marketing tool, Smart App Banners will now help your mobile content get indexed in Apple's public search index. Let's see this in action.

Go to the files that came with this chapter and locate the source code for http://www.rwdevcon.com. Open the file /videos/talk-ray-wenderlich-teamwork.html and add the following meta tag inside the head tag:

```
<meta name="apple-itunes-app" content="app-id=958625272, app-argument=http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

The complete head tag should look like this:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="apple-itunes-app" content="app-id=958625272, app-argument=http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">

    <title>RWDevCon 2016: The Tutorial Conference – Videos</title>

    <script type="text/javascript" src="//use.typekit.net/tnb2xob.js"></script>
    <script type="text/javascript">try{Typekit.load();}catch(e){}</script>
    
    <link rel="stylesheet" type="text/css" href="/assets/css/style.css" />
    
    <!-- HTML5 Video Shiv -->
    <script type="text/javascript">
      document.createElement('video');document.createElement('audio');document.createElement('track');
    </script>
</head>
```

The most important part of the meta tag is the name attribute, which must always be apple-itunes-app. This identifies the type of meta tag, which in turn tells Safari to display your Smart App Banner.

The content attribute contains the following two paramters/arguments:
- app-id: This parameter to your app's Apple ID. It is 958625272 for the RWDevCon app and it will be different for your app. The easiest way to find out your App's Apple ID is to log into iTunes Connect, lick Manage your apps and then click on the application you're interested.
- app-argument: This parameter contains the URL that Safari passes back to the application. This used to require that you use a custom-scheme deep link, but Apple now strongly recommends you switch over to HTTP universal links. That's what you use in this example. 

> **Note:** This was a quick overview of Smart Banners. If you'd like to learn more about Smart Banner's full capabilities, you can read the Smart App Banners Tutorial on raywenderlich.com: http://www.raywenderlich.com/80347/smart-app-banners-tutorial. You can also read the Safari Web Content Guide on this topic: https://developer.apple.com/library/prerelease/ios/documentation/AppleApplications/Reference/SafariWebContent/PromotingAppswithAppBanners/PromotingAppswithAppBanners.html#//apple_ref/doc/uid/TP40002051-CH6.

As an alternative to using Smart Banners, you can also use one of the open standards that Apple supports to provide deep links on your website. This currently includes Twitter Cards and Facebook's App Links. This is a good alternatives if you've already implemented one of those on your website.

//TODO: samples for both formats

> Note: For more information about Twitter Cards, you can visit https://dev.twitter.com/cards/mobile. Similarly, for more information about Facebook's App Links, visit http://applinks.org.

### Handle Links in your app

The next thing you need to do is to handle incoming search results links. Open Xcode once again and implement the following app delegate method in AppDelegate.swift:

```
  func application(application: UIApplication,
    openURL url: NSURL, sourceApplication: String?,
    annotation: AnyObject) -> Bool {
      
      if let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true),
        let path = components.path, let query = components.query {
          
          if path == "/videos" {
            //Do something with the query
          }
      }
      
      return false
  }
```

### Semantic markup using Open Graph

You've learned how to add Smart Banners to a web page to make it easier for Applebot to index your universal links. But just because Applebot can find and crawl your website doesn't mean that your content will ever show up in Spotlight! Your content also has to be relevant and engaging if it 

Apple ranks search results based on some secret algorithm they've developed. Little is known about 

### Validation Tool

## Where to go form here?

As mentioned in the beginning of the chapter, iOS 9 is bringing the web and app ecosystem closer to each other than ever. Custom scheme deep links are all but deprecated in iOS 9 and Apple strongly suggests that you start using universal http links as soon as you can make the transition. This will make linking from the web to your apps a seamless experience.

This chapter also discussed web markup as continuation of chapter 2's search APIs discussion. This particularly applies to apps that have websites that mirror their content. Implementing web markup correctly is one more way you can get new users. This chapter covered a lot of ground, but you still only dipped your toes in each topic. 

You should also not miss the following WWDC Sessions:
- [Seamless Linking To Your App (http://apple.co/1IBTu8q)](https://developer.apple.com/videos/wwdc/2015/?id=509)
- [Introducing Search APIs (http://apple.co/1He5uhh)](https://developer.apple.com/videos/wwdc/2015/?id=709)
- [Your App, Your Website, and Safari (http://apple.co/2KBTu8q)](https://developer.apple.com/videos/wwdc/2014/#506)]

Apple also provides excellent programming guides for universal linking and web markup:
- [App Search Programming Guide (http://apple.co/aHcnuah)](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/index.html#//apple_ref/doc/uid/TP40016308)
- [iOS Search API Best Practices and FAQs (http://apple.co/1He3shh)](https://developer.apple.com/library/prerelease/ios/technotes/tn2416/_index.html)

~~~~~

Notes:
- What will open your app: WKWebview, UIWebView, Safari, openURL, chrome? (yes)

Blockers:
- Upload apple-app-site-association
- Get team admin to turn on associated domains

Resources:
- http://blog.hokolinks.com/how-to-implement-apple-universal-links-on-ios-9/

- check: check smart banners work in video pages
- turn on associated domins, blocked!
- build to a device, blocked! no certificate
- open app, blocked!
- validator

* TODOs
- update apple-app-site-association to newest format
- add width and height meta tags to image
- add width and height meta tags to video


