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

```swift
let url = NSURL(string: "clownapp://home/feed")!
UIApplication.sharedApplication().openURL(url)
```

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

Instead of registering a custom URL scheme, you will tie a domain to a native app. In this chapter, you'll tie `rwdevcon.com` to the RWDevCon native app. For this to be considered an improvement over the current system, Apple has to make sure only you can claim your website and no one else, right? 

To prove that you are you and that you want to tie your domain to your native app, there are two bonds you have to create. The first one is from your native app to your domain. The second, covered in the next section, ties your domain to your native app. 

Go to the files included with this chapter and open **RWDevCon.xcodeproj**. In the project navigator, select the `RWDevcon` project, then the main `RWDevCon` target, switch to the **Capabilities** tab and add the following two entries to the **Associated Domains** section:

![bordered height=35%](/images/associatedDomains.png)

When you try to do this, Xcode will throw an error because you're not a member of the exclusive raywenderlich.com iOS developer program. Bummer! Unfortunately, there's no way to get around this error message for this tutorial. When you try add the associated domains for your own app, make sure you first sign into Xcode with the appropriate Apple ID. You can do this by going to **Xcode/Preferences/Account** then tapping on the plus button.

> **Note**: There's one more caveat to turning on Associated Domains. Only a **team agent** or a **team administrator** on the Apple developer account can make this change. If you're not assigned one of those roles, reach out to the right person on the team to make this change. 

### Getting Your Server Ready

Next, you have to create the link from your website to your native app. Open up your favorite text editor and type in the following JSON:

```javascript
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

Once you're done, name the file **apple-app-site-association** and save it somewhere on your computer. You'll need the file in a moment. For universal HTTP linking to work correctly, this file name must match *exactly* and it **must not have an extension**, not even `.json`.

This file will probably look familiar to you, and for good reason! Apple introduced the **apple-app-site-association** file in iOS 8 to implement shared web credentials between your website and your app as well as web browser-to-native app Handoff. 

You may be wondering where **KFCNEC27GU.com.razeware.RWDevCon** came from. It is your app's App ID, which is a two-part string used to identify an app. The string consists of a Team ID, KFCNEC27GU in this case, followed by a bundle ID, in the form of `com.domainname.applicationname` or com.razeware.RWDevCon in this case.

The Team ID is supplied by Apple and is unique to a specific development team. KFCNEC27GU is specific to the `raywenderlich.com` development team so you'll have a different identifier for your account

The easiest way to find your team identifier if you don't know it is by logging into Apple's [developer portal](http://developer.apple.com/) and going to **Your Account** and then to **Account Summary**. Your team identifier will be listed under **Developer Account Summary**:

![bordered height=35%](/images/teamID.png)

//TODO: blur out Ray's address?

The bundle identifier is even easier to find. If you don't know what it is for your app, go to Xcode, go to the Project Navigator and click on the project file, then select the main target and switch to the **General Tab**. The identifier you're looking for is listed next to **Bundle Identifier**:

![bordered height=35%](/images/bundleID.png)

The convention is to make the bundle identifier a reverse-DNS notation identifier, such as com.razeware.RWDevCon, where the last component is the app's name. You may also be wondering where **/videos/** came from. As the name suggests, the `paths` array contains a list of "white-listed" URL paths that you're letting your app handle instead of your website. If you're a little rusty on your URL components, the path is **/videos/2015/inspiration/** in the URL below:

    https://www.rwdevcon.com/videos/2015/inspiration/?name=Inspiration

Notice that the `paths` array can support some basic pattern matching, such as the `*` wildcard, which matches any number of characters. It also supports `?` to match any single character. You can combine both wildcards in a single path, such as in `/videos/*/year/201?/videoName` or you can use a single `*` to specify your entire website.

Once you have your **apple-app-site-association** file ready, you have to upload it to the root of your HTTPS web server. In this case, since you specified both `rwdevcon.com` and `www.rwdevcon.com` in your Associated Domains, the file has to be accessible, without any redirects, **over HTTPS** at the following locations:

    https://rwdevcon.com/apple-app-site-association
    https://www.rwdevcon.com/apple-app-site-association

Obviously, since you don't have access to the web servers hosting `www.rwdevcon.com`, you can't do this step yourself. Luckily, Ray has already uploaded the file to the root of the web server for you. Thanks Ray! You can verify that it's there by requesting the file with your favorite web browser.

Before moving on to the next section, there are two caveats that you should know about:

1. If you have to target iOS 8 because your app has Continuity features like Handoff and shared web credentials, you'll have to sign your **apple-app-site-association** file using the `openssl`. You can read more about this process in Apple's [Handoff Programming Guide](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/Handoff/AdoptingHandoff/AdoptingHandoff.html).

1. Before uploading your **apple-app-site-association** file to your HTTPS web server, run your JSON through an online validator such as [JSONLint](http://www.jsonlint.com). Typing JSON by hand is prone to error. Universal HTTP links won't work if there's even the slightest syntax error in your JSON file!

### Getting Your App Ready - Part 2

When the app receives an incoming universal link, you'll want to respond by taking the user to the right place in the app. The final step to implementing universal links is to parse, understand and handle the incoming URLs in RWDevCon. Open Xcode, switch to `Session.swift` and add the following class method:

```swift
class func sessionByWebPath(path: String,
  context: NSManagedObjectContext) -> Session? {
  
  let fetch = NSFetchRequest(entityName: "Session")
  fetch.predicate = NSPredicate(format: "webPath = %@",
    argumentArray: [path])
  
  do {
    let results = try context.executeFetchRequest(fetch)
    return results.first as? Session
  } catch let fetchError as NSError {
    print("fetch error: \(fetchError.localizedDescription)")
  }
  
  return nil
}
```

In the RWDevCon app, `Session` is the Core Data class that represents a particular presentation. `Session` contains a `webPath` property that holds the path of the corresponding video page in `rwdevcon.com`. The class method you just added passes in a URL's path string (e.g. `/videos/talk-ray-wenderlich-teamwork.html`) and returns the corresponding session object, or nil if it can't find one.

Next, go to `AppDelegate` and add the following helper method:

```swift
func presentVideoViewController(URL: NSURL) {
  
  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  let navID = "NavPlayerViewController"
  
  let navVideoPlayerVC =
  storyboard.instantiateViewControllerWithIdentifier(navID)
    as! UINavigationController
  
  navVideoPlayerVC.modalPresentationStyle = .FormSheet
  
  let videoPlayerVC = navVideoPlayerVC.topViewController
    as! AVPlayerViewController
  
  videoPlayerVC.player = AVPlayer(URL: URL)
  
  let rootViewController = window!.rootViewController!
  rootViewController.presentViewController(navVideoPlayerVC,
    animated: true, completion: nil)
}
```

This method takes in a video URL and presents an `AVPlayerViewController` embedded in a `UINavigationController` to play it. The video player and the container navigation controller have already been set up. If you want to see how they're configured you can open **Main.storyboard** to see them.

Finally, add the following `UIApplicationDelegate` method:

```swift
func application(application: UIApplication,
  continueUserActivity
  userActivity: NSUserActivity,
  restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    
    //1
    if userActivity.activityType ==
      NSUserActivityTypeBrowsingWeb {

      let universalURL = userActivity.webpageURL!
      
    //2
      if let components = NSURLComponents(URL: universalURL,
        resolvingAgainstBaseURL: true),
        let path = components.path {
          
          if let session = Session.sessionByWebPath(path,
            context: coreDataStack.context) {
    //3
              let videoURL = NSURL(string: session.videoUrl)!
              presentVideoViewController(videoURL)
          } else {
    //4
            let app = UIApplication.sharedApplication()
            let url = NSURL(string: "http://www.rwdevcon.com")!
            app.openURL(url)
          }
      }
    }
    return true
}
```

The system calls this method when there's an incoming universal HTTP link. Pay close attention to what's happening.  Here's a breakdown of what each section does:

1. The system invokes this method for several types of `NSUserActivity`. The type that corresponds to universal HTTP links is `NSUserActivityTypeBrowsingWeb`. When you see a user activity of this type, you're guaranteed that the `NSUserActivity` will have its `webPageURL` property (of type `NSURL?`) set to something you can inspect, so you go ahead and unwrap the optional.
1. You use the new `NSURLComponents` API to extract the URL's path and you use it to reverse-map to the correct `Session` object using the class method you added earlier, `Session.sessionByWebPath(_:_:)`.
1. `Session.sessionByWebPath(_:_:)` returns an optional `Session`. If there's a value behind the optional, you use the session's `videoURL` property to present the video player.
1. If there's no value behind the optional, which can happen if you're handed a universal link that the app can't understand, then you fall back to opening the homepage in Safari.

> **Note:** `application(_:continueUserActivity:restorationHandler:)` should also look familiar. Apple introduced this `UIApplicationDelegate` method back in iOS 8 to help developers implement Handoff. The method also makes an appearance in this book's Chapter 2 in relation to the new search APIs in iOS 9. This method is a real polymath!

Build and run to validate your work. Again, you won't be able to validate the code you just wrote but you can see what the final result is supposed to look like. Double-tap the home screen button to go back to Springboard. Locate and delete the RWDevCon version of the app you've been working on. Then go to the App Store and download the latest version of RWDevCon.

//TODO: This part won't work until we release an update to RWDevCon

Now open your favorite mail client and write yourself an e-mail that looks like this:

![iphone](/images/testlinks.png)

This part assumes that you're able to receive and open the e-mail on your test device. Open the e-mail on the device that you've been using to follow along and tap on the first link. This opens the app and starts streaming a video:

![iphone](/images/videovalidlink.png)

You tapped on a valid link that corresponds to Tammy Coron's 2015 inspiration talk titled "Possibility". Woo hoo! Now go back to your mail client and tap on the second link. Doing this also opens the app, but then you're bounced back to Safari:

![iphone](/images/videoinvalidlink.png)

Great job! You've seen how RWDevCon handles the universal links that it recognizes and how it gracefully falls back to Safari for the ones that it doesn't recognize. So what exactly can trigger your app receiving a universal HTTP link? As you saw, tapping on the directly link from another app will trigger this action. Executing the URL from Safari, `WKWebView`, `UIWebView` or using `UIApplication`'s `openURL(_:)` can also be triggers.

In the last screen shot, notice how there's a banner on top? That's a Smart Banner, and you'll learn much more about them in the second half of the chapter.

## Web Markup

Now that you know how to implement and handle universal links in iOS 9, it's time to move to the second topic of this chapter: web markup. As it turns out, web markup is part a much bigger topic that you started to learn about in Chapter 2. That topic is search! 

To refresh your memory, search includes three different APIs: `NSUserActivity`, `CoreSpotlight` and web markup. All three APIs are important pieces of your search strategy but the second half of this chapter will only focus on web markup. If you skipped Chapter 2 but want to learn more about search, go back and read that chapter. Web markup will still be here when you come back :]

To recap from the last chapter, in iOS 9, search results that appear in Spotlight and in Safari will now include content from native apps. Wait a minute, you may be thinking, wasn't that already the case in iOS 8 and before? That's correct, but search results only included content from Apple's own apps such as Mail and Notes. In iOS 9, for the first time ever, Spotlight and Safari search results will now include content from third party apps. Woo hoo!

There are many ways to show up in iOS 9 search results, but you'll learn about one in particular. If you have a website that mirrors your app's content, you can mark up its web pages with universal links that your native app can understand. 

Apple's web crawler, lovingly named Applebot, will then crawl your website and index your mobile links. Then, when iOS users search for relevant keywords, Apple can surface your content *even if they don't have your app already installed*.

In other words, if you have a website and optimize your web markup correctly, you'll be able to get new downloads organically. Without further ado, let's dive into the specifics of web markup.

### Make your website discoverable

Applebot crawls the web far and wide but there's no guarantee that it will ever land on your website. Fortunately, there are a few things you can do to make your site more discoverable and easier to crawl. 

1. Point your app's **support URL** as well as its optional **marketing URL** in iTunes Connect to the domain that contains your web markup. These support URLS are Applebot's entry points to start crawling your content.

> If you need to change your support URLs, you can do so in iTunes Connect. Simply log into iTunes Connect, go to **My Apps** and navigate to your app's detail page. The fields you want to change (or at least verify) are labeled **Support URL** and **Marketing URL**:

![bordered height=35%](/images/supportURL.png)

2. Make sure the pages that contain your web markup are accessible from your support URL and marketing URL. If there aren't any direct paths from these entry points to your web markup, you should create them.

3. Check that your site's **robots.txt** file lets Applebot do its job. **Robots.txt**, also known as the robots exclusion protocol, is a standard used by websites to communicates with web crawlers and other web robots like Applebot. The file specifies which parts of the site the web crawler should **not** scan or process.

> Not all web crawlers follow these directives, but Applebot does! You can learn more about the robots exclusion standard in [Wikipedia](https://en.wikipedia.org/wiki/Robots_exclusion_standard).

### Embed Universal Links using Smart Banners

Once you make sure Applebot can find and crawl your website, the next step is to...add something worth finding! Apple's recommended way of adding mobile links to your site is by using Smart Banners.

Smart Banners have been around since iOS 6. Before iOS 9, they used to be simple marketing tools provided by Apple that allowed developers to add advertising banners to promote apps directly on a website.

Adding a Smart Banner to a website invites visitors who don't have your app installed to download it from the App Store. It also gives visitors who already have your app installed an easy way to open a page deep within the app. You briefly saw a smart banner in the last section, but here it is up close:

![bordered height=35%](/images/appBanner.png)

This particular Smart Banner is promoting the RWDevCon iOS app on the RWDevCon website. The banner says **OPEN** because Safari detects that the visitor has the RWDevCon app installed on their device. That's why it's smart! 

If the visitor hadn't installed the RWDevCon app, the Smart Banner would say **VIEW** instead of OPEN. Tapping it would take you to the RWDevCon's App Store page.

In iOS 9, Apple is breathing new life into Smart Banners by making them an integral part of search. In addition to their day job as marketing tools, Smart Banners will also help surface universal links for Applebot to crawl and index. Let's see this in action.

Go to the files that came with this chapter and locate the source code for `www.rwdevcon.com`. Open the file **/videos/talk-ray-wenderlich-teamwork.html** and add the following meta tag inside the `head` tag:

```html
<meta name="apple-itunes-app" content="app-id=958625272, app-argument=http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

The most important part of the meta tag is the `name` attribute, which must always be **apple-itunes-app**. This identifies the type of meta tag as a Smart Banner meta tag, which in turn tells Safari to display your Smart Banner.

The content attribute contains two paramters/arguments that you should also pay attention to:

- **app-id**: This parameter corresponds to your app's Apple ID (yes, apps have them too!). 
> **Note**: The easiest way to find your app's Apple ID is to log into iTunes Connect, click **Manage your apps** and then navigate to the app in question. For this particular example, the Apple ID for RWDevCon is 958625272. This number will be different for your app. 
- **app-argument:** This parameter contains the URL that Safari passes back into the app (if it's installed). Before iOS 9, the value of this parameter used to be a custom URL scheme deep link, but Apple now strongly recommends switching over to HTTP universal links. 

> **Note:** This was a quick overview of Smart Banners. If you'd like to learn more about their full capabilities, you can read Ray's [Smart Banners tutorial](http://www.raywenderlich.com/80347/smart-app-banners-tutorial). You can also read the [Safari Web Content Guide](https://developer.apple.com/library/prerelease/ios/documentation/AppleApplications/Reference/SafariWebContent/PromotingAppswithAppBanners/PromotingAppswithAppBanners.html#//apple_ref/doc/uid/TP40002051-CH6) on the topic.

Adding Smart Banners to your website is helpful for many reasons, including increasing the odds of getting indexed by Applebot. However, there are also serious downsides to using Smart Banners. For one, Smart Banners only work in Safari. If a visitor comes to your website through another browser such as Chrome, they won't see the Smart Banner. 

Apple understands that not everyone wants to use Smart Banners, which is why Applebot also supports two other methods of ingesting mobile links. The two options are Twitter Cards and Facebook's App Links. If you've already implemented these on your site, the good news is that you won't have to switch over to Smart Banners.

This is what the RWDevCon example would look like using Twitter Cards:

```html
<meta name="twitter:app:name:iphone" content="RWDevCon">
<meta name="twitter:app:id:iphone" content="958625272">
<meta name="twitter:app:url:iphone" content="http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

And with Facebook's App Links:

```html
<meta property="al:ios:app_name" content="RWDevCon">
<meta property="al:ios:app_store_id" content="958625272">
<meta property="al:ios:url" content="http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

> **Note**: To learn more about Twitter Cards, head over to their [documentation page](https://dev.twitter.com/cards/mobile). The same goes for [Facebook's App Links](http://applinks.org).

Since you don't have the privileges to deploy code to `rwdevcon.com` (sorry!) you won't be able to see your changes in action. However, there is a way to see what the end result is supposed to look like. Go to the App Store and download the latest version of the RWDevCon app. You'll find it if you search for "RWDevCon".

Now switch to mobile Safari and head to `http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html`. The top of the web page looks like this:

![bordered height=35%](/images/appBanner2.png)

If you don't see the Smart Banner, swipe down on the page until it comes into view. Do you notice the difference? This Smart Banner is thinner than the one you saw before. The thinner Smart Banner also changed to say **Open in the RWDevCon app**. This special Smart Banner only shows up for URLs that match at least one of the paths specified in the **apple-app-site-association** file you saw earlier. 

Verify this behavior by going to the homepage at `http://www.rwdevcon.com`. You'll see the regular-sized banner is still there, not the thin banner you saw on the video page. Even though the homepage also has the appropriate meta tag, the URL in its `app-argument` parameter doesn't match the **/videos/** path you specified in the **apple-app-site-association** file.

> **Note:** Smart Banners don't work on the iOS simulator, so you always have to use a device if you want to see and interact with them.

If you tap on the thin Smart Banner, Safari will open the RWDevCon app and play the correct video. This is because you implemented `application(_:continueUserActivity:restorationHandler:)` in the previous section. Good job!

//TODO: This won't work until a new version of RWDevCon is in the App Store. 

### Semantic markup using Open Graph

So far you've learned how to add Smart Banners to a web page to make it easier for Applebot to index universal links. However, just because Applebot can find and crawl a website, it doesn't mean that its content will show up in Spotlight! The content also has to be relevant and engaging if it has any chance of competing with other search results.

Apple doesn't reveal much about the relevance algorithm that determines the ranking for Spotlight search results, but it does reveal a big hint: all things equal, *engaging* content does better and ranks higher. If users tap on (or otherwise engage with) your search results, relative to all other search results your website will rank higher. 

To this end, Apple recommends adding markup for structured data. Let's see this in action. Go back to **/videos/talk-ray-wenderlich-teamwork.html** and below the `meta` tag you added earlier to enable Smart Banners, add the following:

```html
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
You just added rich web markup to the web page by adding a `video` meta tag, an `image`meta tag and a `description` meta tag. These meta tags contains information that technically is already on the page, but making it explicit using `meta` tags helps Applebot scrape your website and get what it needs. You can refer to the 

In the last example, "og" stands for Open Graph. If you want to learn more about Open Graph, make sure to check out its [documentation page](http://ogp.me). Open Graph is one of several standards Apple supports for structured markup. Other standards include [schema.org](http://www.schema.org), [RDFA](http://rdfa.info) and [JSON LD](http://json-ld.org). 

The goal of adding rich markup to your web pages is to adorn Spotlight's search results with more information. For example, a quick search for "ray wenderlich" comes up with these results:

![iphone](/images/catnap.png)

Pay attention to the CatNap video that Ray recently uploaded to Youtube, marked in red. In addition to the web page's title, the search result also contains a video thumbnail as well as a description. Youtube was able to achieve this by providing rich semantic markup.

### Validation Tool

Since there's no "compiler" for the web, how are you supposed to know if your web markup is correct? Along with iOS 9, Apple also launched a web-based [App Search API Validation Tool](https://search.developer.apple.com/appsearch-validation-tool/) that looks like this:

![bordered height=30%](/images/validation.png)

To see the validation tool in action, visit the validation tool URL and test the video page for Ray's 2015 inspiration talk. Once you've typed in the URL, click on "Test URL". 

When you do this, a version of Applebot tries to crawl the URL you provided and gives you back a "report card" of the things are are missing or need to improve. For example, as of this writing, the validation tool returns this set of suggestions:

![bordered height=30%](/images/validationToolResults.png)

//TODO: Re-take this screenshot once the last set of changes get deployed on rwdevcon.com

## Where to go from here?

As mentioned in the beginning of the chapter, iOS 9 is bringing the web and app ecosystem closer to each other than ever. Custom scheme deep links are all but deprecated in iOS 9 and Apple strongly suggests that you start using universal http links as soon as you can make the transition. This will make linking from the web to your apps a seamless experience.

This chapter also discussed web markup as continuation of Chapter 2's search APIs discussion. This particularly applies to apps that have websites that mirror their content. This chapter covered a lot of ground, but you still only dipped your toes in each topic. 

For example, there are ways to add rich semantic markup to your sites that weren't discussed on this chapter. These include using supported schemas such as `Interactionount`, `Organization` and `SearchAction`. As time goes on, Apple will support more schemas and more ways to markup your web pages to make search results come alive.

You should also not miss the following WWDC Sessions:
- [Seamless Linking To Your App (http://apple.co/1IBTu8q)](https://developer.apple.com/videos/wwdc/2015/?id=509)
- [Introducing Search APIs (http://apple.co/1He5uhh)](https://developer.apple.com/videos/wwdc/2015/?id=709)
- [Your App, Your Website, and Safari (http://apple.co/2KBTu8q)](https://developer.apple.com/videos/wwdc/2014/#506)]

Apple also provides excellent programming guides for universal linking and web markup:
- [App Search Programming Guide (http://apple.co/aHcnuah)](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/index.html#//apple_ref/doc/uid/TP40016308)
- [iOS Search API Best Practices and FAQs (http://apple.co/1He3shh)](https://developer.apple.com/library/prerelease/ios/technotes/tn2416/_index.html)


