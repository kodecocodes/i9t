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
