//
//  SwishDownStoryboardSegue.swift
//  WelcomeWizard
//
//  Created by Aaron Douglas on 7/19/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

class SwishDownStoryboardSegue: UIStoryboardSegue {
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    override func perform() {
        let view = self.destinationViewController.view
        self.sourceViewController.view.addSubview(view)
        
        self.sourceViewController.addChildViewController(self.destinationViewController)
        
        let center = self.destinationViewController.view.center
        self.destinationViewController.view.center = CGPointMake(center.x, -1 * center.y)
        
        let animator = (self.sourceViewController as! PhotosCollectionViewController).animator!
        animator.removeAllBehaviors()
        
        let gravityBehavior = UIGravityBehavior(items: [view])
        animator.addBehavior(gravityBehavior)
        
        let slidingAttachment = UIAttachmentBehavior.slidingAttachmentWithItem(view, attachmentAnchor: self.sourceViewController.view.center, axisOfTranslation: CGVectorMake(0, 1))
        slidingAttachment.attachmentRange = UIFloatRange(minimum: view.frame.size.height * -1, maximum: view.frame.size.height)
        animator.addBehavior(slidingAttachment)
    }
}
