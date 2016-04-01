/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

/// Provides the app with some sample data to start with.
class LogsSeed {
  
  class func preload() {
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    let collection = LogStore.sharedStore.logCollection
    
    let intro_date = formatter.dateFromString("2015-04-17 16:00")!
    let intro_text = "I was lucky to get a WWDC15 ticket this year. I expect a lot about the Apple Watch software developer kit."
    let intro_log = TextLog(text: intro_text, date: intro_date)
    collection.addLog(intro_log)
    
    let moscone_date  = formatter.dateFromString("2015-06-08 09:00")!
    let moscone_image = UIImage(named: "moscone-west")!
    let moscone_log = ImageLog(image: moscone_image, date: moscone_date)
    collection.addLog(moscone_log)
    
    let swift_2_session_date = formatter.dateFromString("2015-06-09 11:00")!
    let swift_2_session_text = "I went to the talk about error handling in Swift 2.0 today. Instead of NSError objects and double pointers, we’re moving to a new system that looks similar to exception handling."
    let swift_2_session_log = TextLog(text: swift_2_session_text, date: swift_2_session_date)
    collection.addLog(swift_2_session_log)
    
    let ui_testing_session_date = formatter.dateFromString("2015-06-10 11:00")!
    let ui_testing_session_text = "UI Testing in Xcode: This year Apple moved UI Testing out of Instruments and into Xcode 7. Previously, testing the UI required use of Javascript and UIAutomation. Now in Xcode 7, you can perform UI Testing natively so you can find UI elements and validate their positions and attributes. XCTest is integrated along with Accessibility, which allows XCTest to interact with your apps in the same way that a user would. It seems to me that Xcode 7 makes it relatively painless to adopt testing as a regular part of your development cycle. The demo from this presentation shows how easy it is to record and create tests in Xcode 7 using XCTestElements and XCTestQueries. Chaining queries together can create powerful tests for your app. Including Accessibility in your apps lets less able-bodied users get the most out of your app. Test Reports lets you review the tests run on your app. If you’ve been at all curious about creating tests for your apps, or creating better tests for your apps, then this session is for you."
    let ui_testing_session_log = TextLog(text: ui_testing_session_text, date: ui_testing_session_date)
    collection.addLog(ui_testing_session_log)
    
    let protocol_oriented_session_date = formatter.dateFromString("2015-06-10 14:30")!
    let protocol_oriented_session_text = "Protocol-Oriented Programming in Swift is mind blowing. Apple engineer Dave Abrahams asks us to put aside our regular ways of developing and follow along as he tells a story using protocol-oriented development rather than classes. After listing off the benefits of classes, he counters those benefits with the revelation that Swift is a protocol-based language. By trading dynamic polymorphism for static polymorphism, he contends that protocols and the new protocol extensions are much better than superclasses for abstraction. Protocols add new magic and lead into the use of value types as outlined in Building Better Apps With Value Types in Swift."
    let protocol_oriented_session_log = TextLog(text: protocol_oriented_session_text, date: protocol_oriented_session_date)
    collection.addLog(protocol_oriented_session_log)
    
    let watchkit_animations_session_date = formatter.dateFromString("2015-06-11 10:00")!
    let watchkit_animations_session_text = "Layout and Animation Techniques for WatchKit: Mic Pringle says if you can only watch one WatchKit video, this is the best choice. This session targets all WatchKit developers as it covers aspects of both the current WatchKit and the new WatchKit 2.0 frameworks. The session explains how you align and size interface objects and how WatchKit 2.0 gives you even finer control of layout and animation."
    let watchkit_animations_session_log = TextLog(text: watchkit_animations_session_text, date: watchkit_animations_session_date)
    collection.addLog(watchkit_animations_session_log)
    
    let autolayout_mysteries_session_date = formatter.dateFromString("2015-06-11 11:00")!
    let autolayout_mysteries_session_text = "As Sam Davies says, since Auto Layout is now pretty much a requirement for apps, it’s well worth checking this out – there’s something for everybody to learn. Since its introduction a couple of years ago, adopting Auto Layout has been a challenge for many developers. Some developers love the code-based approach, but last year’s revision to Auto Layout and the additional tools in Interface Builder have made adoption of Auto Layout a little easier."
    let autolayout_mysteries_session_log = TextLog(text: autolayout_mysteries_session_text, date: autolayout_mysteries_session_date)
    collection.addLog(autolayout_mysteries_session_log)
    
    let meet_ray_date = formatter.dateFromString("2015-06-11 17:00")!
    let meet_ray_text = "I met Ray and some RW Tutorial Team members today in San Francisco!"
    let meet_ray_log = TextLog(text: meet_ray_text, date: meet_ray_date)
    collection.addLog(meet_ray_log)
    
    let take_pic_with_ray_date = formatter.dateFromString("2015-06-11 17:30")!
    let take_pic_with_ray_image = UIImage(named: "ray-and-friends")!
    let take_pic_with_ray_log = ImageLog(image: take_pic_with_ray_image, date: take_pic_with_ray_date)
    collection.addLog(take_pic_with_ray_log)
    
    let better_apps_session_date = formatter.dateFromString("2015-06-12 14:30")!
    let better_apps_session_text = "Building Better Apps with Value Types in Swift: This follows up on Protocol-Oriented Programming in Swift, and demonstrates how protocols and value types are used in Swift development. The talk covers the distinction of reference types from value types and how they can be used together."
    let better_apps_session_log = TextLog(text: better_apps_session_text, date: better_apps_session_date)
    collection.addLog(better_apps_session_log)
    
    LogStore.sharedStore.save()
  }
}