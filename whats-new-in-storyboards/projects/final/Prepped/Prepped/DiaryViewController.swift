//
//  DiaryViewController.swift
//  Prepped
//
//  Created by Caroline Begbie on 26/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class DiaryViewController: UITableViewController {
  
  let CellPadding: CGFloat = 30.0
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    let indexPath = NSIndexPath(forRow: diaryData.count-1, inSection: 0)
    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return diaryData.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell", forIndexPath: indexPath)
    let diary = diaryData[indexPath.row]
    if let dateLabel = cell.contentView.viewWithTag(1) as? UILabel {
      dateLabel.text = diary.date
    }
    if let diaryLabel = cell.contentView.viewWithTag(2) as? UILabel {
      diaryLabel.text = diary.diaryEntry
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let diary = diaryData[indexPath.row]
    let font = UIFont.systemFontOfSize(15)
    let size = CGSize(width: 276, height: 600)
    let rect = diary.diaryEntry.boundingRectWithSize(size,
                              options: .UsesLineFragmentOrigin ,
                              attributes: [NSFontAttributeName: font],
                              context: nil)
    return ceil(rect.height) + CellPadding
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      diaryData.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
  //MARK: - Unwind Segue Methods
  
  @IBAction func cancelToDiaryViewController(segue: UIStoryboardSegue) {
    
  }
  
  @IBAction func saveToDiaryViewController(segue: UIStoryboardSegue) {
    if let  controller = segue.sourceViewController as? DiaryDetailViewController,
            diaryEntry = controller.diaryEntry.text {
      let formatter = NSDateFormatter()
      formatter.dateStyle = .MediumStyle
      let currentDate = formatter.stringFromDate(NSDate())
      let diary:DiaryData = (currentDate, diaryEntry)
      diaryData.append(diary)
      let indexPath = NSIndexPath(forRow: diaryData.count-1, inSection: 0)
      self.tableView.beginUpdates()
      self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
      self.tableView.endUpdates()
    }
  }
}
