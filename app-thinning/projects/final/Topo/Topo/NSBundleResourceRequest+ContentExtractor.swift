//
//  ContentExtractor.swift
//  Topo
//
//  Created by Derek Selander on 6/29/15.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit
import MapKit

extension NSBundleResourceRequest {
  func extractMapContentBundleWithTitle(title: String) ->([String : AnyObject], UIImage, String) {
    
    
    let bundleURL = self.bundle.URLForResource(title, withExtension:"bundle")!
    let loadedBundle = NSBundle(URL: bundleURL)!
    
    let auxilliaryURL = loadedBundle.URLForResource(title, withExtension: "plist")!
    let auxilliaryDictionary = NSDictionary(contentsOfURL: auxilliaryURL)!
    
    let imageURL = loadedBundle.URLForResource("map", withExtension: "png")!
    let data = NSData(contentsOfURL: imageURL)!
    let image = UIImage(data: data)!
    
    return (auxilliaryDictionary as! [String : AnyObject], image, loadedBundle.bundlePath)
  }
}
