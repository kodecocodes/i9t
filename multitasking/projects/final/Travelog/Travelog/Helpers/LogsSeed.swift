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

import Foundation
import TravelogKit

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
    
    let protocol_oriented_session_date = formatter.dateFromString("2015-06-10 14:30")!
    let protocol_oriented_session_text = "Protocol-Oriented Programming in Swift is mind blowing. Apple engineer Dave Abrahams asks us to put aside our regular ways of developing and follow along as he tells a story using protocol-oriented development rather than classes. After listing off the benefits of classes, he counters those benefits with the revelation that Swift is a protocol-based language. By trading dynamic polymorphism for static polymorphism, he contends that protocols and the new protocol extensions are much better than superclasses for abstraction. Protocols add new magic and lead into the use of value types as outlined in Building Better Apps With Value Types in Swift."
    let protocol_oriented_session_log = TextLog(text: protocol_oriented_session_text, date: protocol_oriented_session_date)
    collection.addLog(protocol_oriented_session_log)
    
    let meet_ray_date = formatter.dateFromString("2015-06-11 17:00")!
    let meet_ray_text = "I met Ray and some RW Tutorial Team members today in San Francisco!"
    let meet_ray_log = TextLog(text: meet_ray_text, date: meet_ray_date)
    collection.addLog(meet_ray_log)
    
    let take_pic_with_ray_date = formatter.dateFromString("2015-06-11 17:30")!
    let take_pic_with_ray_image = UIImage(named: "ray-and-friends")!
    let take_pic_with_ray_log = ImageLog(image: take_pic_with_ray_image, date: take_pic_with_ray_date)
    collection.addLog(take_pic_with_ray_log)
    
    let better_apps_session_date = formatter.dateFromString("2015-06-12 14:30")!
    let better_apps_session_text = "Building Better Apps with Value Types in Swift. This follows up on Protocol-Oriented Programming in Swift, and demonstrates how protocols and value types are used in Swift development. The talk covers the distinction of reference types from value types and how they can be used together."
    let better_apps_session_log = TextLog(text: better_apps_session_text, date: better_apps_session_date)
    collection.addLog(better_apps_session_log)
    
    LogStore.sharedStore.save()
  }
}