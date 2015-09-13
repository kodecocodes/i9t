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

> **Note**: This only applies to developer accounts comprising of multiple people, but only a **team agent** or a **team administrator** can make this change. If you're not those roles, reach out to the right person on the team to make this change. 

### Getting Your Server Ready

Next, you have to create the link from your website to your native app. Open up your favorite text editor and type in the following JSON structure:

```
{
    "applinks": {
        "apps": [],
        "details": [
            {
                "appID": "KFCNEC27GU.com.razeware.RWDevCon",
                "paths": [
                    "/videos/*"
                ]
            }
        ]
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

> **Note:** If you're targeting iOS 8 because your app also implements continuity features, you'll have to sign your **apple-app-site-association** file using the openssl. You can read more about this process in Apple's Handoff Programming Guide: https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/Handoff/AdoptingHandoff/AdoptingHandoff.html

Finally, you have to upload this file to the root of your domain. In this case, the file has to be accessible at the following locations **over HTTPS**:

    https://rwdevcon.com/apple-app-site-association
    https://www.rwdevcon.com/apple-app-site-association

If you can see the file when you request them with a web browse, that means you're ready for the next step.

> **Note:** Before uploading **apple-app-site-association** file to your server, run your JSON through a JSON validator, such as http://www.jsonlint.com. Typing JSON by hand is prone to error. Having the slightest mistake in your JSON will mean your universal HTTP links won't work at all and you won't know why. Think ahead!

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

Now that you know how to implement and handle universal links in iOS 9, it's time to move to the second topic in this chapter: web markup. As it turns out, web markup is part a much bigger topic that you started to learn about in chapter 2. That topic is search! 

To refresh your memory, search includes three different APIs: NSUserActivity, CoreSpotlight and web markup. All three approaches are important pieces of your search strategy but the second half of this chapter will only focus on web markup. If you skipped chapter 2 but want to learn more about search, go back and read that chapter. Web markup will still be here when you come back :]

To recap from the last chapter, in iOS 9 search results in Spotlight and in Safari will now include content from native apps. Wait a minute, you may be thinking, wasn't that already the case in iOS 8 and before? Yes, but search results only included content from Apple's own apps such as Mail and Notes. What makes this change in iOS 9 exciting is that, for the first time, search results will also include third party apps. Woo hoo!

There are many ways to show up in Spotlight search results, but you'll learn about one in particular in the coming sections. If you have a website that mirrors your app's content, you can mark up its web pages with universal links that your native app can understand. Apple's web crawler, lovingly named Applebot, will then crawl your website and index your universal links. Then when iOS users search for relevant keywords, Apple can your your them your native content *even if they don't have your app already installed*.

In other words, if you have a website and optimize your web markup correctly, you'll be able to get new downloads organically. Without further ado, let's dive into the specifics of web markup.

### Make your website discoverable

Applebot crawls the web far and wide but there's no guarantee that it will ever land on your website. Fortunately, there are a few things you can do to make your site more discoverable and easy to crawl. 

1. Point your app's **support URL** as well as the optional **marketing URL** in iTunes Connect to the domain that contains your web markup. These support URLS are Applebot's entry points to start crawling your content.

If you need to change your marketing or support URLs, you can do so in iTunes Connect. Simply log into iTunes Connect, go to **My Apps** and navigate to your app's detail page. The fields you want to change or at least verify are labeled Support URL and Marketing URL:

![bordered height=35%](/images/supportURL.png)

2. Make sure the pages that contain your web markup are accessible from your support URL and marketing URL. If there aren't any direct paths from these entry points to your web markup, you should create them.

3. Check that your site's **robots.txt** file lets Applebot do its job. **Robots.txt**, also known as the robots exclusion protocol, is a standard used by websites to communicates with web crawlers and other web robots like Applebot. The file specifies which parts of the site that the web crawler should **not** scan or process.

> Not all web crawlers follow these directives, but Applebot does! If your **robots.txt** specifies a certain part of your site shouldn't be crawled then those mobile links won't ever show up in Spotlight. You can learn more about the robots exlusion standard in Wikipedia: https://en.wikipedia.org/wiki/Robots_exclusion_standard.


### Embed Universal Links with Smart Banners

Once you make sure Applebot can crawl your website, the next step is to add your mobile links to your site's source code. Apple's recommended way of doing this is by using Smart Banners.

Smart Banners have been around since iOS 6. They used to be simple marketing tools provided by Apple to allow developers to add advertising banners to promote apps directly on a website.

A Smart Banner is always associated with a specific native app. Adding a Smart Banner to a website invites visitors who don't have your app installed to download it from the App Store. It also gives visitors who already have your app installed an easy way to open a page deep within the app. Here's a Smart Banner in action:

![bordered height=35%](/images/appBanner.png)

The banner says "OPEN" because Safari detects that the visitor has installed the RWDevCon iOS app. That's why they're smart! If the visitor hadn't installed the RWDevCon app, the Smart Banner would say "VIEW" and tapping it would take you to its App Store page.

In iOS 9, Apple is breathing new life into Smart App Banners and making them an integral part of web markup. On top of being marketing tools, Smart App Banners will now help your mobile content get indexed in Apple's public search index. Let's see this in action.

Go to the files that came with this chapter and locate the source code for `http://www.rwdevcon.com`. Open the file **/videos/talk-ray-wenderlich-teamwork.html** and add the following meta tag inside the head tag:

```
<meta name="apple-itunes-app" content="app-id=958625272, app-argument=http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

If you're wondering exactly where to put it, the complete `<head>` tag should look similar to this snippet:

```
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

The most important part of the meta tag is the `name` attribute, which must always be **apple-itunes-app**. This identifies the type of meta tag as a Smart Banner meta tag, which in turn tells Safari to display your Smart App Banner.

The content attribute contains two paramters/arguments that you should also pay attention to:
- **app-id**: This parameter maps to your app's Apple ID (yes, apps have them too!). The easiest way to find out your app's Apple ID is to log into iTunes Connect, click **Manage your apps** and then click on the application you're interested. In this case, the Apple ID for RWDevCon is 958625272 but it will be different for your app. 
- **app-argument:** This parameter contains the URL that Safari passes back to the application. Before iOS 9, this meant passing in a deep link with a custom URL, but Apple now strongly recommends switching over to HTTP universal links. That's what you'll use in this example. 

> **Note:** This was a quick overview of Smart Banners. If you'd like to learn more about their full capabilities, you can read Ray's Smart App Banners tutorial on raywenderlich.com: http://www.raywenderlich.com/80347/smart-app-banners-tutorial. You can also read the Safari Web Content Guide on this topic: https://developer.apple.com/library/prerelease/ios/documentation/AppleApplications/Reference/SafariWebContent/PromotingAppswithAppBanners/PromotingAppswithAppBanners.html#//apple_ref/doc/uid/TP40002051-CH6.

Smart Banners are helpful for many reasons, including increasing the odds of getting a website indexed by Applebot. However, Smart Banners also have their downsides. For one, Smart Banners only works in Safari. If a visitor comes to your website through another browser such as Chrome or Opera, they won't see the Smart Banner. 

Apple understands that not everyone will want to use Smart Banners, which is why they're supporting other options. As an alternative to using Smart Banners, you can also use one of the open standards, which currently includes Twitter Cards and Facebook's App Links. This is a good alternatives if you've already implemented one of those on your website.

This is what the RWDevCon example look like using Twitter Cards:

```
<meta name="twitter:app:name:iphone" content="RWDevCon">
<meta name="twitter:app:id:iphone" content="958625272">
<meta name="twitter:app:url:iphone" content="http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

And with Facebook's App Links:

```
<meta property="al:ios:app_name" content="RWDevCon">
<meta property="al:ios:app_store_id" content="958625272">
<meta property="al:ios:url" content="http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

> **Note**: For more information about Twitter Cards, you can visit https://dev.twitter.com/cards/mobile. Similarly, for more information about Facebook's App Links, visit http://applinks.org.

Since you don't have the privileges to deploy code to `rwdevcon.com` (sorry!) you won't be able to see your changes in action. However, there is a way to see what the end result is supposed to look like. Go to the App Store and download the latest version of the RWDevCon app. You'll find it if you search for "RWDevCon".

Now switch to mobile Safari and head to http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html. The top of the page looks like this:

![bordered height=35%](/images/appBanner2.png)

//TODO: Verify this screenshot later on. The text on the banner is misaligned, which will probably get fixed before the release.

If you don't see the Smart Banner, swipe down on the page until it comes into view. So what changed? The Smart Banner became thinner and it changed to say "Open in the RWDevCon app". This special version of the Smart Banner only shows up for URLs that match at least one of the paths specified in the **apple-app-site-association** file you saw earlier. 

Verify this behavior by going to the homepage at `http://www.rwdevcon.com`. You'll see the regular-sized banner, not the thin banner you saw on the video page. Even though the homepage also has the appropriate meta tag, the URL in its `app-argument` parameter doesn't match the **/videos/** path you specified in the **apple-app-site-association** file.

> **Note:** Smart App Banners don't work on the simulator, so you always have to use a device if you want to see and interact with them.

If you tap on the thin smart banner, Safari will open the RWDevCon app and play the correct video. You'll implement this behavior shortly in the local version of the app you've been working on.

//TODO: This won't work until a new version of RWDevCon is in the App Store. 

### Handling universal links in RWDevCon

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
**Add a Pomodoro here**

//TODO: show what its supposed to link to in the app
//TODO: show that raywenderlich video is not in app, fall back to safari
//TODO: show that another video can be played in the app

### Semantic markup using Open Graph

So far you've learned how to add Smart Banners to a web page to make it easier for Applebot to index a web site's universal links. However, just because Applebot can find and crawl a website, it doesn't mean that its content will show up in Spotlight! The content also has to be relevant and engaging if it has any chance of competing with other search results.

Apple doesn't reveal much about the relevance algorithm that determines the ranking for Spotlight search results, but it does give a us developers big hint: all things equal, engaging content ranks higher. If users tap on (or otherwise engage with) your search results relative to all other search results, your website will rank higher. 

To this end, Apple recommends adding markup for structured data. Let's see this in action. Go back to **/videos/talk-ray-wenderlich-teamwork.html** and below the `meta` tag you added earlier to enable Smart Banners, add the following:

```
<meta property="og:image" content="http://www.rwdevcon.com/assets/images/videos/talk-ray-wenderlich-teamwork.jpg" />
<meta property="og:image:secure_url" content="https://www.rwdevcon.com/assets/images/videos/talk-ray-wenderlich-teamwork.jpg" />
<meta property="og:image:type" content="image/jpeg" />
<meta property="og:image:width" content="640" />
<meta property="og:image:height" content="340" />

<meta property="og:video" content="http://www.rwdevcon.com/videos/Ray-Wenderlich-Teamwork.mp4" />
<meta property="og:video:secure_url" content="https://www.rwdevcon.com/videos/Ray-Wenderlich-Teamwork.mp4" />
<meta property="og:video:type" content="video/mp4" />
<meta property="og:video:width" content="1280" />
<meta property="og:video:height" content="720" />

<meta property="og:description" content="Learn how teamwork lets you dream bigger, through the story of an indie iPhone developer who almost missed out on the greatest opportunity of his life." />
```
You just added rich web markup to the web page by adding a video tag, an image tag and a description tag. The meta tags you just added contains information that's technically already on the page, but making it explicit using `meta` tags helps Applebot scrape your website and get what it needs.


> **Note**: In the examples above, "og" stands for Open Graph. This is one of several standards Apple supports for structured markup. Other standards include schma.org, RDFA and JSON LD.

//TODO: add action to play video

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

- Useful for apps that have mirrored content from the web

~~~~~

Notes:
- What will open your app: WKWebview, UIWebView, Safari, openURL, chrome? (yes)

Blockers:
- Upload apple-app-site-association
- Get team admin to turn on associated domains

Resources:
- http://blog.hokolinks.com/how-to-implement-apple-universal-links-on-ios-9/

- check smart banners work in video pages
- turn on associated domins, works!
- build to a device, blocked! 
- smart banner opens app, works, must handle link!
- validator, must update

* TODOs
- update apple-app-site-association to newest format
- add width and height meta tags to image
- add width and height meta tags to video


