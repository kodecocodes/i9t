# Chapter 2: Your App on the Web

On iOS, native and web technologies have been two distinctly separate camps. Native apps are part of a closed ecosystem which is tightly controlled by Apple, whereas web technologies are based on open standards. These two worlds don't often cross paths. What happens on your mobile website can't directly affect what happens in your native app.

Over the past couple of years, Apple has worked to bring web and native closer together. For example, in iOS 7 Apple introduced JavaScriptCore: a framework meant to bridge native code with JavaScript. On iOS 8, Apple introduced features such as Continuity and shared web credentials.

In iOS 9, Apple is pushing things forward yet again. In this chapter you'll read about two important developments in this area: universal links and web markup. These technologies allow web content to be surfaced in Spotlight and Safari search, and provide deep links directly into your app. Sounds cool? Without further ado, let's get started.

## Getting started

Unlike the rest of this book, the "sample app" for this chapter is actually a real-world production app currently on the App Store. You'll be working with the app for **RWDevCon**, the conference organized by the folks behind [raywenderlich.com](http://www.raywenderlich.com)! You'll also be making some tweaks to its accompanying website: <http://www.rwdevcon.com>.

![iPhone bordered](images/01-rwdevcon-screenshot.png)

In the starter files for this chapter, you'll find both the code for the iOS app and the code for the website. There's quite a lot there, but don't be put off! You'll just be adding some extra functionality to the videos section. Feel free to take a look through and familiarize yourself. You can also browse the real [RWDevCon website (http://rwdevcom.com)](http://rwdevcom.com) and download the iOS app from the App Store ([http://apple.co/1YoKMTi](http://apple.co/1YoKMTi)).

> **Note:** Due to the infrastructure and security requirements for web markup and universal links, this chapter is unfortunately the only place in this book where you **won't** be able to verify your work as you follow along. There's just no easy way to try out these features without having a real website accessible via HTTPS and an associated app in the App Store under an account where you are either the team agent or the team admin.
>
> The rest of this chapter includes a number of tutorial sections so that you can get some experience implementing the new functionality that you'll be learning about. You won't be able to build the sample app onto a device (due to not having the required provisioning profiles), but you can still get an understanding of how everything fits together.

## Linking to your app

If you've ever linked into a native app, either from a website or from another app, then you're probably familiar with universal links' predecessor: "deep" links. Before diving into universal links, here's a quick refresher on deep links so you know exactly how they differ from the new technology you'll explore in this chapter.

### Deep links

Prior to iOS 9, the primary way to let apps communicate with each other was to register a custom URL scheme using the `CFBundleURLTypes` key in your **Info.plist**. For example, if you were developing a social network app for clowns you might have registered something like `clownapp://` or `clown://`.

When iOS encountered a link using a custom URL scheme handled by an installed app, the system would open that app and pass in the entire link. Deep linking applied to system apps as well as third-party apps. You may have come across some of Apple's own URL schemes:

- **Mail.app**: `mailto://john.appleseed@apple.com`
- **Phone.app**: `tel://1-408-555-5555`
- **Messages.app**: `sms://1-408-555-5555`
- **Facetime.app**: `facetime://user@icloud.com`

After registering your custom scheme, you could then link into your app from elsewhere in iOS by constructing a link such as `clownapp://home/feed`. When the link was opened, iOS would then launch your app and pass in the entire URL via the app delegate method `application(_:handleOpenURL:)`. Your app could then interpret the URL whichever way it wanted and respond appropriately.

This system worked fairly well for a long time (since iOS 3.0, in fact!) but had some major drawbacks:

- **Privacy:** In addition to `openURL(_:)`, `UIApplication` also has the method `canOpenURL(_:)`. The _intended_ purpose of this innocent-looking method is to check if there's an app installed on the device that can handle a specific URL. Unfortunately, it was exploited to gather a list of other apps that a user has installed. For instance, if you know that a particular device can open a `clownapp://` URL then it's very likely that the social clown app is installed on it.
- **Collisions**: Facebook's custom URL scheme is `fb://`. What's stopping anyone else from also registering `fb://` as _their_ URL scheme, and capturing Facebook's deep links? In short, nothing. When two apps register for the same custom URL scheme, it's it's undefined which one will get launched.
- **No fallback**: What happens if iOS tries to use a URL with a custom URL scheme that _no_ installed app has registered? Nothing happens. The action fails silently.

### Universal links

iOS 9 introduces the successor to deep links: **universal links**. Instead of registering for custom URL schemes, universal links use standard HTTP and HTTPS links. You can register to handle specific links for any web domains that belong to you.

For example, if you owned the domain `clownapp.com` then you could register `http://clownapp.com/clowns/*` as a universal app link. If the user has your social clown app installed and taps a link such as `http://clownapp.com/clowns/fizbo` within Safari or a web view, then they'll be taken straight to Fizbo's profile within your app. Otherwise, they'll see the clown's information on your website – just like a standard HTTP link. You get the same behaviour if you open the link with `openURL(_:)`.

So universal links are pretty cool - one link that launches either an app or a website! One link to rule them all! :]

These new universal links have a bunch of advantages over deep links:

- **Unique:** There's no way for other apps to register to handle your domain.
- **Secure:** To tie your domain and app together, you have to upload a securely-signed file to your web server (more on this later). Also, there's no way for apps to tell whether your app is installed or not.
- **Simple:** A universal link is just a normal HTTP link, and it works for your website and for your app. So even if a user doesn't have your app installed, the link will just open up in Safari as it normally would. This also means that they still work for users who aren't running iOS 9.

That's enough theory for now! Time to find out how to add universal links to your own apps.

### Registering your app to handle universal links

To tie your domain to your native app and prove that it's your domain, there are two 'bonds' that you have to create: You have to tell your native app about your domain, and you have to tell your domain about your native app. First up, letting the RWDevCon app know about the `rwdevcon.com` domain.

Go to the starter files included with this chapter and open **RWDevCon.xcodeproj** from the **rwdevcon-app** directory. In the **project navigator**, select the **RWDevCon project**, then the main **RWDevCon target**. Switch to the **Capabilities** tab and add the following domains to the **Associated Domains** section:

![bordered width=90%](/images/02-associated-domains.png)

This capability tells iOS which domains the app should respond to. You must make sure you prefix your domain names with `applinks:`.

Xcode may prompt you to select a development team when you attempt to change these settings. For the purposes of this tutorial, you can just cancel out of this dialog when it appears. You'll also notice that Xcode will now show a provisioning warning. Unfortunately you won't be able to run the demo app on a device, because you're not a member of the

When you try add the associated domains for your _own_ app, make sure you first sign into Xcode with the appropriate Apple ID. You can do this by going to **Xcode\Preferences\Account** and then tapping on the plus button. You'll then need to turn on the Associated Domains setting, and then add any domains you want to listen out for.

> **Note**: Only a **team agent** or a **team administrator** on an Apple developer account can turn on the  Associated Domains capability. If you're not assigned one of those roles, reach out to the right person on your team to make this change.

### Registering your server to handle universal links

Next, you have to create the link from your website to your native app. To do this, you need to place a JSON file on your webserver containing some information about your app. You won't be able to follow along for this section as you don't have access to the `rwdevcon.com` web server to upload a file – but here's how the contents of that file should look:

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

The file must be named **apple-app-site-association** and it _must not_ have an extension, not even `.json`.

This might look familiar to you, and for good reason! Apple introduced the **apple-app-site-association** file in iOS 8 to implement shared web credentials between your website and your app as well as Handoff between web and native apps.

The `applinks` section of this file determines which of your apps can handle which URL paths on your website. Somewhat confusingly, the `"apps"` property should _always_ be an empty array.

The `details` section contains an array of dictionaries pairing an `appID` with a list of `paths`.

Your `appID` string consists of your **team ID** (`KFCNEC27GU` in this example) followed by your app's **bundle ID** (`com.razeware.RWDevCon` in this case).

The team ID is supplied by Apple and is unique to a specific development team. `KFCNEC27GU` is specific to the Ray Wenderlich development team so you'll have a different identifier for your own account. If you don't know your team ID, the easiest way to find it is by logging into Apple's [developer member center (https://developer.apple.com/membercenter)](https://developer.apple.com/membercenter). Log in, click on **Your Account**, and then look for your team ID within the **Account Summary**.

![bordered width=80%](/images/03-team-ID.png)

If you don't know your app's bundle ID, go to Xcode and click on your project in the **project navigator**. Select the main target for your app and switch to the **General** tab. The identifier you're looking for is listed as **Bundle Identifier**:

![bordered width=80%](/images/04-bundle-ID.png)

A bundle ID typically uses reverse-DNS notation, of the form `com.exampledomain.exampleappname`.

As the name suggests, the `paths` array contains a list of "white-listed" URL paths that you're letting your app handle instead of your website. If you're a little rusty on your URL components, in the URL:

    https://www.rwdevcon.com/videos/2015/inspiration/?name=Inspiration

the path is the part after the domain name: **/videos/2015/inspiration/**.

Notice that the `paths` array can support some basic pattern matching, such as the `*` wildcard which matches any number of characters. It also supports `?` to match any single character. You can combine both wildcards in a single path, such as `/videos/*/year/201?/videoName` or you can just use a single `*` to specify your entire website.

And that's all there is to it! You can add as many paths as you like for your app to handle. You can also add multiple apps to handle different paths.

Once you have your **apple-app-site-association** file ready, you have to upload it to the root of your web server. In the case of RWDevCon, since you specified both `rwdevcon.com` and `www.rwdevcon.com` in your associated domains, the file has to be accessible at the following locations:

    https://rwdevcon.com/apple-app-site-association
    https://www.rwdevcon.com/apple-app-site-association

It must be hosted without any redirects, and be accessible **over HTTPS**.

Obviously, since you don't have access to the web servers hosting `www.rwdevcon.com`, you can't do this step yourself. Luckily, Ray has already uploaded the file to the root of the web server for you. Thanks Ray! You can verify that it's there by requesting the file with your favorite web browser.

Before moving on to the next section, there are two caveats that you should know about:

1. If you have to target iOS 8 because your app has Continuity features like Handoff and shared web credentials, you'll have to sign your **apple-app-site-association** file using the `openssl`. You can read more about this process in Apple's [Handoff Programming Guide (http://apple.co/1yG4jR9)](http://apple.co/1yG4jR9).

1. Before uploading your **apple-app-site-association** file to your web server, run your JSON through an online validator such as [JSONLint (http://www.jsonlint.com)](http://www.jsonlint.com). Universal links won't work if there's even the slightest syntax error in your JSON file!

### Handling universal links in your app

When your app receives an incoming universal link, you'll want to respond by taking the user straight to the right content. The final step to implementing universal links is to parse the incoming URLs, determine what content to show, and navigate the user there.

Head back to the RWDevCon project in Xcode, open up **Session.swift** and add the following class method to the bottom of the class:

```swift
class func sessionByWebPath(path: String,
  context: NSManagedObjectContext) -> Session? {

  let fetch = NSFetchRequest(entityName: "Session")
  fetch.predicate = NSPredicate(format: "webPath = %@", [path])

  do {
    let results = try context.executeFetchRequest(fetch)
    return results.first as? Session
  } catch let fetchError as NSError {
    print("fetch error: \(fetchError.localizedDescription)")
  }

  return nil
}
```

In the RWDevCon app, `Session` is the Core Data class that represents a particular presentation. `Session` contains a `webPath` property that holds the path of the corresponding video page in `rwdevcon.com`. The class method you just added passes in a URL's path (e.g. `/videos/talk-ray-wenderlich-teamwork.html`) and returns the corresponding session object, or nil if it can't find one.

Next, open **AppDelegate.swift** and add the following helper method to the `AppDelegate`:

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
      rootViewController?.presentViewController(navVideoPlayerVC,
        animated: true, completion: nil)
  }
}
```

This method takes in a video URL and presents an `AVPlayerViewController` embedded in a `UINavigationController` to play it. The video player and the container navigation controller have already been set up, and are loaded from the main storyboard. If you want to see how they're configured you can open **Main.storyboard** to see them.

Finally, still in **AppDelegate.swift**, implement the following `UIApplicationDelegate` method:

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
              let url = NSURL(string: "http://www.rwdevcon.com")!
              app.openURL(url)
            }
        }
    }
    return false
}
```

The system calls this delegate method when there's an incoming universal HTTP link. Pay close attention to what's happening. Here's a breakdown of what each section does:

1. As mentioned above, the system invokes this method for several types of `NSUserActivity`. The type that corresponds to universal HTTP links is `NSUserActivityTypeBrowsingWeb`. When you see a user activity of this type, you're guaranteed that the `NSUserActivity` will have its `webPageURL` property (of type `NSURL?`) set to something you can inspect, so you go ahead and unwrap the optional.
2. You use `NSURLComponents` to extract the URL's path and you use it to map to the correct `Session` object using the class method you added earlier, `sessionByWebPath(_:context:)`.
3. `sessionByWebPath(_:context:)` returns an optional `Session`. If there's a value behind the optional, you use the session's `videoURL` property to present the video player using the `presentVideoViewController(_:)` method that you just added.
4. If there's no value behind the optional, which can happen if you're handed a universal link that the app can't understand, then you just launch the RWDevCon home page in Safari and return false to indicate to the system that you didn't handle the activity.

> **Note:** `application(_:continueUserActivity:restorationHandler:)` may look familiar to you. Apple introduced this `UIApplicationDelegate` method back in iOS 8 to help developers implement Handoff. It also makes an appearance in Chapter 2 of this book in relation to the new search APIs in iOS 9. This method is truly a jack of all trades!

Again, you won't be able to validate the code you just wrote, but hopefully it's useful to see how to handle an incoming link. You can see what the final result is supposed to look like by downloading the App Store version of the RWDevCon app. On your device, go to the App Store, search for **RWDevCon** and download the latest version of the app.

[FPE: This part won't work until we release the update to RWDevCon]

Now, still on your device, open your favorite mail client and send yourself an e-mail that contains these two links:

![bordered width=80%](/images/05-testlinks.png)

Once you receive the email that you just sent, tap on the first link. This opens the app and starts streaming a video:

![iPhone](/images/06-video-link-valid.png)

You tapped on a valid link that corresponds to Tammy Coron's 2015 inspiration talk titled "Possibility". Woo hoo! Now go back to your mail client and tap on the second link. Doing this also opens the app, but then you're bounced back to Safari:

![iphone](/images/07-video-link-invalid.png)

Great job! You've seen how RWDevCon handles the universal links that it recognizes and how it gracefully falls back to Safari for the ones that it doesn't recognize. So what exactly can trigger your app receiving a universal HTTP link? As you saw, tapping on the directly link from another app certainly does the trick. Loading the URL in Safari, a `WKWebView`, or a `UIWebView`, or using `UIApplication`'s `openURL(_:)` can also launch your app.

In the last screen shot, notice that banner at the top? That's a **Smart App Banner**, and you'll learn much more about them in the second half of the chapter.

## Web markup

Now that you know how to implement and handle universal links in iOS 9, it's time to move to the second topic of this chapter: web markup. As it turns out, web markup is part of a much bigger topic that you started to learn about in Chapter 2: app search!

To refresh your memory, search includes three different APIs: `NSUserActivity`, `CoreSpotlight` and web markup. All three APIs are important pieces of your search strategy, and Chapter 2 covered both `NSUserActivity` and `CoreSpotlight`. If you skipped the last chapter and want to learn more about them, go ahead and read it now. Web markup will still be here when you get back! :]

So in iOS 9, search results that appear in Spotlight and in Safari can now include content from native apps. Web markup is one way to get your app's content to appear in these search results. If you have a website that mirrors your app's content, you can mark up its web pages with standards-based markup, Smart App Banners, and universal links that your native app can understand.

Apple's web crawler, lovingly named Applebot, will then crawl your website and index your mobile links. Then, when iOS users search for relevant keywords, Apple can surface your content *even if they don't have your app already installed*.

In other words, if you have a website and optimize your web markup correctly, you'll be able to get new downloads organically. Without further ado, let's dive into the specifics of web markup.

### Make your website discoverable

Applebot crawls the web far and wide but there's no guarantee that it will ever land on your website. Fortunately, there are a few things you can do to make your site more discoverable and easier to crawl.

1. In iTunes Connect, point your app's **support URL** as well as its optional **marketing URL** to the domain that contains your web markup. These support URLs are Applebot's entry points to start crawling your content.
[TODO: Check Applebot capitalization]

> If you need to change your support and marketing URL, simply log into iTunes Connect, go to **My Apps** and navigate to your app's detail page. The fields you want to change (or at least verify) are labeled **Support URL** and **Marketing URL**:
> ![bordered width=80%](/images/08-support-URL.png)

2. Make sure the pages that contain your web markup are accessible from your support URL and marketing URL. If there aren't any direct paths from these entry points to your web markup, you should create them so that Applebot can find them.

3. Check that your site's **robots.txt** file lets Applebot do its job. **Robots.txt**, also known as the robots exclusion protocol, is a standard used by websites to communicates with web crawlers and other web robots like Applebot. The file specifies which parts of the site the web crawler should not scan or process.

> Not all web crawlers follow these directives, but Applebot does! You can learn more about the robots exclusion standard on [Wikipedia (http://bit.ly/1MNna6A)](http://bit.ly/1MNna6A).

### Embed universal links using Smart App Banners

[TODO: Add note about remainder of chapter using HTML]

Once you make sure Applebot can find and crawl your website, the next step is to add something worth crawling! Apple's recommended way of adding mobile links to your site is by using Smart App Banners.

Smart App Banners have been around since iOS 6. Before iOS 9, they used to be simple marketing tools provided by Apple that allowed developers to add advertising banners to promote apps directly on a website.

Adding a Smart App Banner to a website invites visitors who don't have your app installed to download it from the App Store. It also gives visitors who already have your app installed an easy way to open a page deep within the app. You briefly saw a Smart App Banner in the last section, but here it is up close:

![bordered height=20%](/images/09-app-banner-1.png)

This particular Smart App Banner is promoting the RWDevCon iOS app on the RWDevCon website. The banner says **OPEN** because Safari detects that the visitor has the RWDevCon app installed on their device. That's why it's smart!

If the visitor hadn't installed the RWDevCon app, the Smart App Banner would say **VIEW** instead of OPEN. Tapping it would take you to the RWDevCon app's App Store page.

In iOS 9, Apple is breathing new life into Smart App Banners by making them an integral part of search. In addition to their day job as marketing tools, Smart App Banners will also help surface universal links for Applebot to crawl and index. Let's see this in action.

Go to the starter files that came with this chapter and locate the source code for `www.rwdevcon.com` in the **rwdevcon-site** folder. Open the file **talk-ray-wenderlich-teamwork.html** in the **videos** folder and add the following meta tag inside the `head` tag:

```html
<meta name="apple-itunes-app" content="app-id=958625272, app-argument=http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html">
```

The `name` attribute of this `meta` tag is very important, and must always be **apple-itunes-app**. This identifies the type of meta tag as a Smart App Banner meta tag, which in turn tells Safari to display your Smart App Banner.

The `content` attribute contains two parameters that you should pay attention to:

- **app-id**: This parameter corresponds to your app's Apple ID. Yes, apps have Apple IDs too! But this is a bit different from the sort of Apple ID you use to log into iCloud. Your app's Apple ID is simply a unique number, and all apps on the App Store have them. The easiest way to find your app's ID is to log into iTunes Connect, click **My Apps** and then navigate to the app in question. The Apple ID for RWDevCon is `958625272`. This number will be different for your app.
- **app-argument:** This contains the URL that Safari will pass back into the app (if it's installed). Before iOS 9, the value of this parameter used to be a custom URL scheme deep link, but Apple now strongly recommends switching over to using universal links – just like you used earlier in this chapter.

> **Note:** This was a quick overview of Smart App Banners. If you'd like to learn more about their full capabilities, you can read Ray's [Smart App Banners tutorial (http://bit.ly/1iYlyea)](http://www.raywenderlich.com/80347/smart-app-banners-tutorial). You can also read the [Safari Web Content Guide (http://apple.co/1KYeI4I)](http://apple.co/1KYeI4I).

Adding Smart App Banners to your website is helpful for many reasons, including increasing the odds of getting indexed by Applebot. However, it's worth noting that Smart App Banners only work in Safari. If a visitor comes to your website through another browser such as Chrome, they won't see the banner.

Apple understands that not everyone wants to use Smart App Banners, which is why Applebot also supports two other methods of ingesting mobile links. The two alternatives are Twitter Cards and App Links.

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

> **Note**: To learn more about Twitter Cards, head over to their [documentation page (https://dev.twitter.com/cards/mobile)](http://bit.ly/1REZOkC). The same goes for [App Links (http://applinks.org)](http://applinks.org).

Since you don't have the privileges to deploy code to `rwdevcon.com` (sorry!) you won't be able to see your changes in action. However, once again you can try it out using the RWDevCon app from the App Store. If you haven't already, go to the App Store on your device and download the latest version of the RWDevCon app.

Now, switch to mobile Safari and head to <http://www.rwdevcon.com/videos/talk-ray-wenderlich-teamwork.html>. The top of the web page looks like this:

![bordered height=30%](/images/10-app-banner-2.png)

If you don't see the Smart App Banner, swipe down on the page until it comes into view. Do you notice anything different from the Smart App Banner you saw earlier? This one is thinner, and has changed to say **Open in the RWDevCon app**. This special banner only shows up for URLs that match at least one of the paths specified in the **apple-app-site-association** file you saw earlier.

You can verify this behavior by going to the homepage at <http://www.rwdevcon.com>. You'll see the regular-sized banner is still there, not the thin banner you saw on the video page. Even though the homepage also has the appropriate meta tag, the URL in its `app-argument` parameter doesn't match the **/videos/** path you specified in the **apple-app-site-association** file.

> **Note:** Smart App Banners don't work on the iOS simulator so you always have to use a device if you want to see and interact with them.

If you tap on the thin banner, Safari will open the RWDevCon app and play the correct video. This is because you implemented `application(_:continueUserActivity:restorationHandler:)` in the previous section. Good job!

### Semantic markup using Open Graph

So far you've learned how to add Smart App Banners to a web page to make it easier for Applebot to index universal links. However, just because Applebot can find and crawl a website, it doesn't mean that its content will show up in Spotlight! The content also has to be relevant and engaging if it has any chance of competing with other search results.

Apple doesn't reveal much about the relevance algorithm that determines the ranking for Spotlight search results, but it has said that *engagement* with content will be taken into consideration. If users tap on (or otherwise engage with) your search results, relative to all other search results your website will rank higher.

To this end, Apple recommends adding markup for structured data, to allow Spotlight to provide richer search results. Let's see this in action. In your text editor of choice, go back to **/videos/talk-ray-wenderlich-teamwork.html** and below the `meta` tag you added earlier to enable Smart App Banners, add the following:

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
You just added rich web markup to the web page by adding a `video` meta tag, an `image` meta tag and a `description` meta tag. These meta tags contain information that technically is already on the page, but making it explicit using `meta` tags helps Applebot scrape your website and find what it needs.

In the `property` fields above, "og" stands for **Open Graph**. If you want to learn more about Open Graph, make sure to check out its documentation at <http://ogp.me>. Open Graph is one of several standards Apple supports for structured markup. Other standards include [schema.org (http://www.schema.org)](http://www.schema.org), [RDFA (http://rdfa.info)](http://rdfa.info) and [JSON LD (http://json-ld.org)](http://json-ld.org).

The goal of adding rich markup to your web pages is to adorn Spotlight's search results with more information. For example, a quick search for "ray wenderlich" comes up with these results:

![iphone](/images/11-catnap.png)

Notice the CatNap video that Ray recently uploaded to YouTube, marked in red. In addition to the web page's title, the search result also contains a video thumbnail as well as a description. YouTube was able to achieve this by providing rich semantic markup.

### Validation tool

Since there's no "compiler" for the web, how are you supposed to know if your web markup is correct? Along with iOS 9, Apple also helpfully launched a web-based [App Search API Validation Tool (http://apple.co/1F8tTGt)] (https://search.developer.apple.com/appsearch-validation-tool/) that looks like this:
[TODO: bit.ly]

![bordered height=30%](/images/12-validation.png)

To see the validation tool in action, try it out with the URL of the video page for Ray's 2015 inspiration talk. Simply visit the Validation Tool's web page, enter the video page URL, and click **Test URL**.

When you do this, the tool gives you back a "report card" of the things that are good and the things that are missing or need to improve. For example, as of this writing, the validation tool returns this set of suggestions:

![bordered height=30%](/images/13-validation-tool-results.png)

## Where to go from here?

This has been a bit of an odd chapter because you haven't been able to test out your changes as you've gone along. Hopefully you've still found it useful to walk through the steps involved in adding web markup and universal links to your own apps.

iOS 9 is bringing the web and app ecosystem closer to each other than ever. Apple strongly suggests that you start using universal links as soon as you can. This will make linking from the web to your apps a seamless experience. And if you have a website that mirrors your app's content, web markup can help you provide rich search results in Spotlight and Safari. This chapter covered a lot of ground, but you still only dipped your toes in each topic.

Whilst this chapter covered a lot of ground, there are other ways to add rich semantic markup to your sites that you haven't seen yet. These include using supported schemas such as `InteractionCount`, `Organization` and `SearchAction`. As time goes on, Apple will support more schemas and more ways to markup your web pages to make search results come alive.

You should also definitely check out the following WWDC sessions if you want to find out more:

- [Seamless Linking To Your App (http://apple.co/1Way2xz)](https://developer.apple.com/videos/wwdc/2015/?id=509)
- [Introducing Search APIs (http://apple.co/1LFjZZD)](https://developer.apple.com/videos/wwdc/2015/?id=709)
- [Your App, Your Website, and Safari (http://apple.co/1OGLhE3)](https://developer.apple.com/videos/wwdc/2014/#506)

Apple also provides excellent programming guides for universal linking and web markup:

- [App Search Programming Guide (http://apple.co/1ip7lGE)](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/index.html#//apple_ref/doc/uid/TP40016308)
- [iOS Search API Best Practices and FAQs (http://apple.co/1Mj4yJe)](https://developer.apple.com/library/prerelease/ios/technotes/tn2416/_index.html)
