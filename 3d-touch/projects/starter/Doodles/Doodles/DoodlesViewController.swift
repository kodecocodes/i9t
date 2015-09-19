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

struct Doodle {
  let name: String
  let date: NSDate
  let image: UIImage?
  
  static var allDoodles = [ Doodle(name: "Name", date: NSDate(), image: UIImage(named: "doodle1")) ]
  
  static func addDoodle(doodle: Doodle) {
    allDoodles.append(doodle)
  }
}

class DoodleCell: UITableViewCell {
  @IBOutlet weak var doodleNameLabel: UILabel!
  @IBOutlet weak var doodleDateLabel: UILabel!
  @IBOutlet weak var doodlePreviewImageView: UIImageView!
  
  private static var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd MMM yyyy, HH:mm"
    return formatter
  }()
  
  var doodle: Doodle? {
    didSet {
      if let doodle = doodle {
        doodleNameLabel.text = doodle.name
        doodleDateLabel.text = self.dynamicType.dateFormatter.stringFromDate(doodle.date)
        doodlePreviewImageView.image = doodle.image
      }
    }
  }
}

class DoodlesViewController: UITableViewController {
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
  }
  
  @IBAction func unwindToDoodlesViewController(segue: UIStoryboardSegue) {}
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destinationViewController = segue.destinationViewController as? DoodleViewController,
       let indexPath = tableView.indexPathForSelectedRow
       where segue.identifier == "ViewDoodleSegue" {
        let doodle = Doodle.allDoodles[indexPath.row]
        destinationViewController.doodle = doodle
    }
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Doodle.allDoodles.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("DoodleCell", forIndexPath: indexPath) as! DoodleCell
    
    cell.doodle = Doodle.allDoodles[indexPath.row]
    
    return cell
  }
}

