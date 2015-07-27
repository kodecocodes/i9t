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

class AnimalsViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let cell = sender as? UITableViewCell {
      let indexPath = tableView.indexPathForCell(cell)!
      let animal = animalData[indexPath.row]
      let controller = segue.destinationViewController as! AnimalDetailViewController
      controller.animal = animal
    }
  }
}

extension AnimalsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return animalData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
    let animal = animalData[indexPath.row]
    cell.textLabel?.text = animal.name
    cell.detailTextLabel?.text = animal.description
    
    let cellImageView:RoundedImageView
    if let imageView = cell.contentView.viewWithTag(100) as? RoundedImageView {
      cellImageView = imageView
    } else {
      let margin:CGFloat = 4
      let height = cell.contentView.bounds.height - margin*2
      let frame = CGRect(origin: CGPoint(x: 10, y: margin), size: CGSize(width: height, height: height))
      cellImageView = RoundedImageView(frame: frame)
      cellImageView.cornerRadius = height/2
      cellImageView.borderColor = AppThemeColor
      cellImageView.borderWidth = 2.0
    }
    cellImageView.image = UIImage(named: animal.name)
    cellImageView.tag = 100
    cell.contentView.addSubview(cellImageView)
    
    return cell
  }
  
}

extension AnimalsViewController: UITableViewDelegate {
}