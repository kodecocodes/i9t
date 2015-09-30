```metadata
author: Pietro Rea
number: 3
title: Your App on the Web
```
# Chapter 3: Your App on the Web

Native and web technologies have historically lived in two distinct camps within iOS: native apps are part of a closed ecosystem tightly controlled by Apple, whereas web technologies are based on open standards and frameworks. These two worlds don't cross paths often, and what happens on a mobile website often doesn't directly affect what happens in a native app.

In the last few years, Apple has worked to bring the camps of web and native apps closer together. iOS 7 introduced JavaScriptCore, a framework to bridge native code with JavaScript. iOS 8 saw the release of features such as Continuity and shared web credentials.

iOS 9 pulls the web and native worlds just a little closer with **universal links** and **web markup**, which let you provide deep links directly into your app and surface web content in Spotlight and Safari search.

You probably have a bunch of ideas on how to use those features from that basic introduction alone, so jump straight into the next section to see how to blur the lines between web and native apps.

## Getting started

Unlike the rest of this book, the "sample app" for this chapter is a real-world app available on the App Store. You'll be working with the app for **RWDevCon**, the conference organized by the folks behind [raywenderlich.com](http://www.raywenderlich.com). You'll also be making some tweaks to its accompanying website: [rwdevcon.com](http://rwdevcon.com).

![iPhone bordered](images/01-rwdevcon-screenshot.png)

In the starter files for this chapter, you'll find both the code for the iOS app and the code for the website. There's quite a lot there, but don't be put off – you'll only be editing one or two files and adding some extra functionality to the videos section. Feel free to take a look through the project to familiarize yourself with its contents; you can also browse the real [RWDevCon website (http://rwdevcon.com)](http://rwdevcon.com) and download the iOS app from the App Store ([http://apple.co/1YoKMTi](http://apple.co/1YoKMTi)).

> **Note:** Due to the infrastructure and security requirements for web markup and universal links, this chapter is unfortunately the only place in this book where you **won't** be able to verify your work as you follow along. There's no easy way to try out these features without having a real website accessible via HTTPS and an associated app in the App Store under an account where you're either the team agent or the team admin.
>
> The rest of this chapter includes a number of tutorial sections to give you some experience with universal links and web markup. You won't be able to run the sample app on a device, since you won't have the required provisioning profiles, but you can still get an understanding of how everything fits together.

## Linking to your app

If you've ever linked into a native app, either from a website or from another app, then you're probably familiar with the predecessor to universal links: **deep links**. Before diving into universal links, read through the following refresher on deep links so you'll know exactly how they differ from the new technology you'll explore in this chapter.

### Deep links

Before iOS 9, the primary way apps communicated with each other was to register a custom URL scheme using the `CFBundleURLTypes` key in **Info.plist**. For example, if you were developing a social network app for clowns you might have registered something like `clownapp://` or `clown://`. You might have seen some of Apple's own URL schemes in use, such as `tel://`, `sms://`, or `facetime://`.

Once you've registered your custom scheme, you can link into your app from other places in iOS by constructing a URL such as `clownapp://home/feed`. When the link is opened, iOS launches your app and passes in the entire URL via the app delegate method `application(_:handleOpenURL:)`. Your app then can interpret the URL in any manner and respond appropriately.

This system worked fairly well for a long time (since iOS 3.0, in fact!) but it has some major drawbacks:

- **Privacy:** In addition to `openURL(_:)`, `UIApplication` also has the method `canOpenURL(_:)`. The _intended_ purpose of this innocent-looking method is to check if there's an app installed on the device that can handle a specific URL. Unfortunately, this method was exploited to gather a list of installed apps; if you know that a particular device can open a `clownapp://` URL then you also know that the device has the social clown app installed.
- **Collisions**: Facebook's custom URL scheme is `fb://`. There's nothing stopping another app from registering `fb://` as _their_ URL scheme and capturing Facebook's deep links. When two apps register for the same custom URL scheme, it's indeterminate which app will win out and launch.
- **No fallback**: If iOS tries to open a link of a custom URL scheme that's not registered to _any_ app, the action fails silently.

iOS 9 solves many of these problems and more with universal links; instead of registering for custom URL schemes, universal links use standard HTTP and HTTPS links. You can register to handle specific links for any web domains that you own.

### Universal links

If you owned the domain `clownapp.com`, you could register `http://clownapp.com/clowns/*` as a universal app link. If the user installs your social clown app and taps the link `http://clownapp.com/clowns/fizbo` within Safari or a web view, iOS takes them straight to Fizbo's profile within your app.

If they don't have the app installed, they are taken to the clown's information on your website, just as if they'd followed a standard HTTP link. You'll see the same behavior if you open the link with `openURL(_:)`.

Universal links have other advantages over deep links:

- **Unique:** There's no way other apps can register a handler for your domain.
- **Secure:** To tie your domain and app together, you have to upload a securely-signed file to your web server. There's also no way for other apps to tell whether your app is installed.
- **Simple:** A universal link is just a normal HTTP link which works for both your website and your app. So even if a user doesn't have your app installed, or isn't running iOS 9, the link will still bring them to Safari.

Enough theory for now — time to find out how to add universal links to your own apps.

### Registering your app to handle universal links

To tie your website to your native app and prove that it's _your_ website, there are two 'bonds' you have to create: you have to tell your native app about your domain, and you have to tell your domain about your native app. After that, you simply need to add some code to your app to handle incoming links.

First up: letting the RWDevCon app know about the `rwdevcon.com` domain.

Go to the starter files included with this chapter and open **RWDevCon.xcodeproj** from the **rwdevcon-app** directory. In the project navigator, select the **RWDevCon project**, then the main **RWDevCon target**. Switch to the **Capabilities** tab and add the following domains to the **Associated Domains** section:

- `applinks:rwdevcon.com`
- `applinks:www.rwdevcon.com`

Your Associated Domains section should look like the following when done:

![bordered width=90%](/images/02-associated-domains.png)

This tells iOS which domains your app should respond to. Make sure to prefix your domain names with `applinks:`.

Xcode may prompt you to select a development team when you attempt to change these settings. For the purposes of this tutorial, simply cancel out of this dialog when it appears. Unfortunately, you won't be able to run the demo app on a device since you're not a member of the Ray Wenderlich development team.

When you add the associated domains for your _own_ app, make sure you first sign into Xcode with the appropriate Apple ID. Do this by going to **Xcode\Preferences\Accounts** and tapping on the **+** button. You'll then need to turn on the Associated Domains setting and add any domains you want to listen for.

> **Note**: Only a **team agent** or a **team administrator** of an Apple developer account can turn on the Associated Domains capability. If you're not assigned one of those roles, reach out to the right person on your team to make this change.

### Registering your server to handle universal links

Next, you have to create the link from your website to your native app. To do this, you need to place a JSON file on your webserver that contains some information about your app. You won't be able to follow along for this section since you don't have access to the `rwdevcon.com` web server to upload a file, but here's what the contents of that file should look like:

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

The file must be named **apple-app-site-association** and it _must not_ have an extension — not even `.json`.

The file name might look familiar to you, and for good reason! Apple introduced the **apple-app-site-association** file in iOS 8 to implement shared web credentials between your website and your app as well as for Handoff tasks between web and native apps.

The `applinks` section of this file determines which of your apps can handle particular URL paths on your website. Somewhat confusingly, the `"apps"` property should _always_ be an empty array.

The `details` section contains an array of dictionaries pairing an `appID` with a list of `paths`.

Your `appID` string consists of your **team ID** (`KFCNEC27GU` in this example) followed by your app's **bundle ID** (`com.razeware.RWDevCon` in this case).

The team ID is supplied by Apple and is unique to a specific development team. `KFCNEC27GU` is specific to the Ray Wenderlich development team; you'll have a different identifier for your own account. 

If you don't know your team ID, the easiest way to find it is by logging into Apple's [developer member center (developer.apple.com/membercenter)](https://developer.apple.com/membercenter). Log in, click on **Your Account**, and then look for your team ID within the account summary:

![bordered width=80%](/images/03-team-ID.png)

If you don't know your app's bundle ID, go to Xcode and click on your project in the **project navigator**. Select the main target for your app and switch to the **General** tab. The identifier you're looking for is listed as **Bundle Identifier**:

![bordered width=80%](/images/04-bundle-ID.png)

A bundle ID typically uses reverse-DNS notation in the form `com.exampledomain.exampleappname`.

As the name of **apple-app-site-association** suggests, the `paths` array contains a list of "white-listed" URLs that your app should handle. If you're a little rusty on your URL components, the path in the following URL is **/videos/2015/inspiration/**; it's the bit that follows the domain name:

    https://www.rwdevcon.com/videos/2015/inspiration/?name=Inspiration

The `paths` array can support some basic pattern matching, such as the `*` wildcard, which matches any number of characters. It also supports `?`, which matches any single character. You can combine both wildcards in a single path, such as `/videos/*/year/201?/videoName`, or you can simply use a single `*` to specify your entire website.

That's all there is to path management; you can add as many paths as you like for your app to handle, or even add multiple apps to handle different paths.

Once you have **apple-app-site-association** ready, you have to upload it to the root of your web server. In the case of RWDevCon, since you specified both `rwdevcon.com` and `www.rwdevcon.com` in your associated domains, the file must be accessible at the following locations:

    https://rwdevcon.com/apple-app-site-association
    https://www.rwdevcon.com/apple-app-site-association

It must be hosted without any redirects, and be accessible **over HTTPS**.

Since you don't have access to the web servers that host `www.rwdevcon.com`, you can't do this step yourself. Luckily, Ray has already uploaded the file to the root of the web server for you – thanks Ray! You can verify it's there by requesting the file through your favorite web browser.

Before moving on to the next section, there are two caveats to consider when managing your site association file:

1. If your app must target iOS 8 because it contains Continuity features such as Handoff or shared web credentials, you'll have to sign **apple-app-site-association** using `openssl`. You can read more about this process in Apple's [Handoff Programming Guide (http://apple.co/1yG4jR9)](http://apple.co/1yG4jR9).

2. Before you upload **apple-app-site-association** to your web server, run your JSON through an online validator such as [JSONLint (www.jsonlint.com)](http://www.jsonlint.com). Universal links won't work if there's even the slightest syntax error in your JSON file!

### Handling universal links in your app

When your app receives an incoming universal link, you should respond by taking the user straight to the targeted content. The final steps in implementing universal links are to parse the incoming URLs, determine what content to show, and navigate the user to the content.

Head back to the **RWDevCon project** in Xcode and add the following class method to **Session.swift** at the bottom of the class:

```swift
class func sessionByWebPath(path: String,
  context: NSManagedObjectContext) -> Session? {

    let fetch = NSFetchRequest(entityName: "Session")
    fetch.predicate =
      NSPredicate(format: "webPath = %@", [path])

    do {
      let results = try context.executeFetchRequest(fetch)
      return results.first as? Session
    } catch let fetchError as NSError {
      print("fetch error: \(fetchError.localizedDescription)")
    }

    return nil
}
```

In the RWDevCon app, the Core Data class `Session` represents a particular presentation and contains a `webPath` property that holds the path of the corresponding video page on `rwdevcon.com`. The method above takes a URL's path, such as `/videos/talk-ray-wenderlich-teamwork.html`, and returns either the corresponding session object or `nil` if it can't find one.

Next, open **AppDelegate.swift** and add the following helper method to `AppDelegate`:

```swift
func presentVideoViewController(URL: NSURL) {  
  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  let navID = "NavPlayerViewController"

  let navVideoPlayerVC =
    storyboard.instantiateViewControllerWithIdentifier(navID)
    as! UINavigationController

  navVideoPlayerVC.modalPresentationStyle = .FormSheet

  if let videoPlayerVC = navVideoPlayerVC.topViewController
    as? AVPlayerViewController {

      videoPlayerVC.player = AVPlayer(URL: URL)

      let rootViewController = window?.rootViewController
      rootViewController?.presentViewController(
        navVideoPlayerVC, animated: true, completion: nil)
  }
}
```

This method takes in a video URL and presents an `AVPlayerViewController` embedded in a `UINavigationController`. The video player and container navigation controller have already been set up and are loaded from the main storyboard. If you want to see how they're configured you can open **Main.storyboard** to have a look.

Finally, still in **AppDelegate.swift**, implement the following `UIApplicationDelegate` method below the method you just added:

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
                return true
            } else {
              //4
              let app = UIApplication.sharedApplication()
              let url =
                NSURL(string: "http://www.rwdevcon.com")!
              app.openURL(url)
            }
        }
    }
    return false
}
```

The system calls this delegate method when there's an incoming universal HTTP link. Here's a breakdown of what each section does:

1. The system invokes this method for several types of `NSUserActivity`; `NSUserActivityTypeBrowsingWeb` is the type that corresponds to universal HTTP links. When you see a user activity of this type, you're guaranteed that the `NSUserActivity` instance will have its `webPageURL` property of type `NSURL?` set to something you can inspect. Therefore you can unwrap the optional.
2. You use an instance of `NSURLComponents` to extract the URL's path; you can then use `sessionByWebPath(_:context:)` along with the URL to map to the correct `Session` object.
3. `sessionByWebPath(_:context:)` returns an optional `Session`. If there's a value behind the optional, you use the session's `videoURL` property to present the video player using `presentVideoViewController(_:)`.
4. If there's no value behind the optional, which can happen if you're handed a universal link the app can't understand, you simply launch the RWDevCon home page in Safari and return `false` to tell the system you couldn't handle the activity.

> **Note:** `application(_:continueUserActivity:restorationHandler:)` may look familiar to you; Apple introduced this `UIApplicationDelegate` method in iOS 8 to allow developers to implement Handoff. It also makes an appearance in Chapter 2, "Introducing App Search", which deals with the new search APIs in iOS 9. This method is a jack of all trades!

Although you won't be able to validate the code you just wrote, it's still useful to see how to handle an incoming link. To see what the final result should look like, download the RWDevCon app from the App Store ([apple.co/1YoKMTi](http://apple.co/1YoKMTi)).

On your device, open your favorite mail client and send yourself an e-mail that contains the following two links:

![bordered width=80%](/images/05-testlinks.png)

Once you receive the email, tap the first link. This should open the app and start streaming Tammy Coron's 2015 inspiration talk titled "Possibility":

![iPhone](/images/06-video-link-valid.png)

Looks great! Now return to your mail client and tap the second link. The app opens, but then you're bounced back to Safari, as shown below:

![iphone](/images/07-video-link-invalid.png)

The RWDevCon app neatly handles the universal links it recognizes, but gracefully falls back to Safari for any that it doesn't.

Besides tapping a link, you can also load the URL directly in Safari, a `WKWebView`, a `UIWebView`, or use `openURL(_:)` on an instance of `UIApplication` to trigger your app to handle a universal link.

Did you notice the banner at the top of the previous screenshot? That's a **Smart App Banner**; you'll learn more about those in the second half of the chapter.

## Working with web markup

Now that you know how to implement and handle universal links in iOS 9, it's time to move to the second topic of this chapter: web markup. As it turns out, web markup is part of a much bigger topic that's covered about in Chapter 2, "Introducing App Search".

Search includes three different APIs: `NSUserActivity`, `CoreSpotlight` and web markup. Chapter 2 covered `NSUserActivity` and `CoreSpotlight`; it's well worth a read through that chapter if you haven't done so already.

Search results that appear in Spotlight and in Safari can now include content from native apps in iOS 9, and you can use web markup to get your app's content to surface in those search results. If you have a website that mirrors your app's content, you can mark up its web pages with standards-based markup, Smart App Banners, and universal links your native app understands.

Apple's web crawler, lovingly named "Applebot", will then crawl your website and index your mobile links. When iOS users search for relevant keywords, Apple can surface your content _even if users don't have your app installed_. In other words, optimizing your markup on your site helps you get new downloads organically.

### Making your website discoverable

Applebot crawls the web far and wide, but there's no guarantee when, or even if, it will land on your website. Fortunately, there are a few things you can do to make your site more discoverable and easier to crawl.

1. In iTunes Connect, point your app's **Support URL** as well as its **Marketing URL** to the domain that contains your web markup. These support URLs are Applebot's entry points to crawl your content:

![bordered width=80%](/images/08-support-URL.png)

2. Make sure the pages that contain your web markup are accessible from your support marketing URLs. If there aren't any direct paths from these URLs to your web markup, you should create them so Applebot can find the web markup.

3. Check that your site's **robots.txt** file is set up so that Applebot can do its job. **Robots.txt**, also known as the _robots exclusion protocol_, is a web standard for  communicating with web crawlers and other web robots; it specifies which parts of the site the web crawler should not scan or process.

> **Note:** Not all web crawlers follow these directives, but Applebot does! You can learn more about the robots exclusion standard on [Wikipedia (http://bit.ly/1MNna6A)](http://bit.ly/1MNna6A).

### Embedding universal links using Smart App Banners

Once Applebot can find and crawl your website, the next step is to add something worth crawling! Apple recommends the use of Smart App Banners to add mobile links to your site.

Smart App Banners have been around since iOS 6; they've typically been seen as advertising banners that promote apps on a website. Visitors who didn't have your app installed would get a link to the app in the App Store; for those who did have the app installed, the banner could provide an easy way to link to a page deep within your app.

Here's the Smart App Banner from the last section up close:

![bordered height=20%](/images/09-app-banner-1.png)

This particular Smart App Banner promotes the RWDevCon iOS app on the RWDevCon website. Since Safari's detected that the visitor has the app installed, the banner says **OPEN**; otherwise, the Smart App Banner would say **VIEW** and take you to the App Store page for the RWDevCon app. That's why they call them "smart" banners! :]

iOS 9 brings new uses to Smart App Banners by making them an integral part of search. In addition to their day job as marketing tools, Smart App Banners can also help surface universal links for Applebot to crawl and index.

> **Note:** The remainder of this chapter is all about editing the HTML of your website to improve its discoverability and presence in search results in iOS 9. It should be easy enough to follow, even if you're not familiar with HTML. If somebody else takes care of your website for you, be sure to show them this chapter so they can make the required changes! :]

Go to the starter files that came with this chapter and locate the source code for `www.rwdevcon.com` in the **rwdevcon-site** folder. Open **talk-ray-wenderlich-teamwork.html** in the **videos** folder and add the following `meta` tag inside the `head` tag, above the page title:

```html
<meta name="apple-itunes-app" content="app-id=958625272, app-argument=http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

The `name` attribute of this `meta` tag is very important, and must always be **apple-itunes-app**. This identifies the type of the meta tag as a Smart App Banner meta tag, which in turn tells Safari to display your Smart App Banner.

The `content` attribute contains two important parameters:

- **app-id**: This parameter corresponds to your app's Apple ID. Yes, apps have Apple IDs too! But this is different from the sort of Apple ID you use to log into iCloud. Your app's Apple ID is simply a unique number; all apps on the App Store have them. The easiest way to find your app's ID is to log into iTunes Connect, click **My Apps** and then navigate to the app in question. The Apple ID for RWDevCon is `958625272`; the ID would be different for your own app.
- **app-argument:** This contains the URL Safari will pass back to the app if it's installed. Prior to iOS 9, the value of this parameter was a custom URL scheme deep link, but Apple now strongly recommends you switch to HTTP/HTTPS universal links.

> **Note:** This was a quick overview of Smart App Banners. To learn more about their full capabilities, read Ray's [Smart App Banners tutorial (http://bit.ly/1iYlyea)](http://www.raywenderlich.com/80347/smart-app-banners-tutorial) as well as the [Safari Web Content Guide (http://apple.co/1KYeI4I)](http://apple.co/1KYeI4I).

Adding Smart App Banners to your website is helpful for many reasons, including better odds of being indexed by Applebot. However, it's worth noting that Smart App Banners only work in Safari; if a visitor comes to your website through another browser such as Chrome, they won't see the banner.

Apple understands that not everyone wants to use Smart App Banners, which is why Applebot also supports two other methods of surfacing mobile links: Twitter Cards and App Links.

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

> **Note**: To learn more, read through Twitter's [documentation page on Twitter Cards (https://dev.twitter.com/cards/mobile)](http://bit.ly/1REZOkC) as well as Facebook's [App Links documentation (http://applinks.org)](http://applinks.org).

Since you don't have the privileges to deploy code to `rwdevcon.com` (sorry, Ray's kind of picky about things like that), you won't be able to see your changes in action. However, you can see how it's supposed to work using the RWDevCon app from the App Store.

Use mobile Safari to load <http://www.rwdevcon.com/videos/talk-jake-gundersen-opportunity.html>. That's the video for Jake Gundersen's 2015 talk titled "Opportunity". The top of the web page should look like this:

![bordered height=30%](/images/10-app-banner-2.png)

If you don't see the Smart App Banner, swipe down on the page until it comes into view. Notice anything different from the Smart App Banner you saw earlier? This one is thinner, and has changed to say **Open in the RWDevCon app**. This special banner only shows up for URLs that match at least one of the paths specified in **apple-app-site-association**.

You can verify this behavior by navigating to the site root <http://www.rwdevcon.com>. You'll see the regular-sized banner, not the thin banner you saw on the video page. Even though the homepage _also_ has the appropriate meta tag, the URL in its `app-argument` parameter doesn't match the **/videos/** path you specified in **apple-app-site-association**.

> **Note:** Smart App Banners don't work on the iOS simulator, so you must use a device to view and interact with the banners.

Tap the thin banner; Safari opens the RWDevCon app and plays the correct video via your implementation of `application(_:continueUserActivity:restorationHandler:)` in the previous section.

### Semantic markup using Open Graph

You've learned how to add Smart App Banners to a web page to make it easier for Applebot to index universal links. However, just because Applebot can find and crawl a website doesn't mean its content will show up in Spotlight! The content also has to be relevant and engaging if it has any chance of competing with other search results.

Apple doesn't reveal much about the relevance algorithm that determines the ranking for Spotlight search results, but it has said that _engagement_ with content will be taken into consideration. If users tap or otherwise significantly engage with your search results, your site result will rank relatively higher than other site.

To this end, Apple recommends adding markup for structured data to allow Spotlight to provide richer search results.

Open **/videos/talk-ray-wenderlich-teamwork.html** and add the following code below the `meta` tag you added earlier:

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
This adds rich web markup to the web page via the `video`, `image` and `description` meta tags, which explicitly points to information contained on the page, helping Applebot find the information it's looking for.

In the `property` fields above, "og" stands for **Open Graph**. To learn more about Open Graph, check out the Open Graph documentation at <http://ogp.me>; it's one of several standards Apple supports for structured markup. Other standards include [schema.org (http://www.schema.org)](http://www.schema.org), [RDFA (http://rdfa.info)](http://rdfa.info) and [JSON LD (http://json-ld.org)](http://json-ld.org).

The goal of adding rich markup to your web pages is to adorn Spotlight's search results with more information. For example, as this book goes to press, a quick search for "ray wenderlich" comes up with these results:

![iphone](/images/11-catnap.png)

Notice the "CatNap for tvOS" video that Ray recently uploaded to YouTube, marked in red. In addition to the title of the web page, the search result also contains a video thumbnail as well as a description. YouTube was able to achieve this through rich semantic markup.

### Validating your markup

Since there's no "compiler" for the web, how are you supposed to know if your web markup is correct? Apple's created a web-based [App Search API Validation Tool (http://apple.co/1F8tTGt)](https://search.developer.apple.com/appsearch-validation-tool/) for just that purpose.

To see the validation tool in action, try it out with the URL of the video page for Ray's 2015 inspiration talk. Simply visit the Validation Tool's web page, enter the video page URL, and click **Test URL**. The tool will provide you with a "report card" of the good parts of your markup, along with things that are missing or need to be improved. 

For example, as of this writing, the validation tool returns this set of suggestions for `http://rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html`:

![bordered height=30%](/images/13-validation-tool-results.png)

Apple's validation tool checks for the `meta` tags you added earlier, as well as for the page's `title` tag, Smart App Banner and universal link.

## Where to go from here?

iOS 9 brings the web and app ecosystems closer than ever before. Apple strongly suggests that you start using universal links as soon as you can to make linking from the web a seamless experience. Furthermore, if you have a website that mirrors your app's content, web markup can help you provide rich search results in Spotlight and Safari.

This chapter covered a lot of ground, but believe it or not you've only dipped your toes into each topic. There are other ways to add rich semantic markup to your sites that you haven't seen yet, such as supported schemas including `InteractionCount`, `Organization` and `SearchAction`. As time goes on, Apple will support more schemas and more ways to markup your web pages to make search results come alive.

Although you weren't able to test your changes as you worked through this chapter, I still hope you found it useful to walk through the steps required to add web markup and universal links to your own apps.

You should definitely check out the following WWDC sessions if you want to find out more about your app and the web:

- [Seamless Linking To Your App (http://apple.co/1Way2xz)](https://developer.apple.com/videos/wwdc/2015/?id=509)
- [Introducing Search APIs (http://apple.co/1LFjZZD)](https://developer.apple.com/videos/wwdc/2015/?id=709)
- [Your App, Your Website, and Safari (http://apple.co/1OGLhE3)](https://developer.apple.com/videos/wwdc/2014/#506)

Apple also provides the following excellent programming guides for universal linking and web markup:

- [App Search Programming Guide (http://apple.co/1ip7lGE)](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/index.html#//apple_ref/doc/uid/TP40016308)
- [iOS Search API Best Practices and FAQs (http://apple.co/1Mj4yJe)](https://developer.apple.com/library/prerelease/ios/technotes/tn2416/_index.html)
