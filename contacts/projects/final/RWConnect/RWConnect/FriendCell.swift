//
//  FriendCell.swift
//  RWConnect
//
//  Created by Evan Dekhayser on 7/28/15.
//  Copyright © 2015 Razeware, LLC. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

	override func layoutSubviews() {
		super.layoutSubviews()
		
		if imageView?.image != nil{
			imageView?.frame = CGRectMake(10, 13, 40, 40)
			imageView?.contentMode = UIViewContentMode.ScaleAspectFill
			imageView?.layer.masksToBounds = true
			imageView?.layer.cornerRadius = 20
			textLabel!.frame = CGRect(x: textLabel!.frame.origin.x - 38, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
			detailTextLabel!.frame = CGRect(x: detailTextLabel!.frame.origin.x - 38, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
			separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
		}
	}

}
