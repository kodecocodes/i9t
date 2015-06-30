//
//  ContentExtractor.swift
//  Topo
//
//  Created by Derek Selander on 6/29/15.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit

extension NSBundleResourceRequest {
  func extractMapContentBundleWithTitle(title: String) ->([String : AnyObject], UIImage) {
    
    let auxilliaryURL = self.bundle.URLForResource("auxilliary", withExtension: "plist")!
    let auxilliaryDictionary = NSDictionary(contentsOfURL: auxilliaryURL)!
    
    let imageURL = self.bundle.URLForResource("map", withExtension: "png")!
    let data = NSData(contentsOfURL: imageURL)!
    let image = UIImage(data: data)!
    
    return (auxilliaryDictionary as! [String : AnyObject], image)
  }
}
