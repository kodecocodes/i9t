//
//  ContentExtractor.swift
//  Topo
//
//  Created by Derek Selander on 6/29/15.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit
import MapKit

extension NSBundle {
  
  func extractMapContentBundleWithTitle(title: String) ->([String : AnyObject], String) {
    let bundleURL = self.URLForResource(title, withExtension:"bundle")!
    let loadedBundle = NSBundle(URL: bundleURL)!
    
    let auxilliaryURL = loadedBundle.URLForResource(title, withExtension: "plist")!
    let auxilliaryDictionary = NSDictionary(contentsOfURL: auxilliaryURL)!
    
    return (auxilliaryDictionary as! [String : AnyObject], loadedBundle.bundlePath)
  }
  
}
