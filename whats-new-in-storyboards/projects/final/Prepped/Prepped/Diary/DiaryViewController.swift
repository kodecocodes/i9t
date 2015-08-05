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

class DiaryViewController: UITableViewController {
  
  let CellPadding: CGFloat = 30.0

  private var yearsArray = [String]()
  private var sectionedDiaryEntries = [String: [DiaryEntry]]()
  private var sortedYears: [String]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60.0

    sortDiaryEntriesByDate()
  }
  
  // MARK: - UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sectionedDiaryEntries.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let entries = sectionedDiaryEntries[sortedYears![section]]
    return entries!.count
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCellWithIdentifier("SectionHeader") as! DiaryHeaderTableViewCell

    headerCell.year = sortedYears![section]
    return headerCell
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 26.0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell", forIndexPath: indexPath) as! DiaryEntryTableViewCell
    
    
    cell.diaryEntry = diaryEntries[indexPath.row]
    
    let entries = sectionedDiaryEntries[sortedYears![indexPath.section]]
    cell.diaryEntry = entries![indexPath.row]
    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      diaryEntries.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
  //MARK: - Unwind Segue Methods
  
  @IBAction func cancelToDiaryViewController(segue: UIStoryboardSegue) {
  }
  
  @IBAction func saveToDiaryViewController(segue: UIStoryboardSegue) {
    if let controller = segue.sourceViewController as? AddDiaryEntryViewController,
      diaryEntry = controller.diaryEntry {
      diaryEntries.append(diaryEntry)

      sortDiaryEntriesByDate()
      tableView.reloadData()
        
    }
  }
}

// MARK:- Date methods

extension DiaryViewController {
  private func sortDiaryEntriesByDate() {
    // sort entries by date descending
    let sortedDiaryEntries = diaryEntries.sort {
      return $0.date > $1.date
    }
    
    // extract years for sections
    var yearsSet = Set<String>()
    yearsSet = Set(diaryEntries.map {
      $0.year
      })
    
    // sort years into descending sequence
    sortedYears = yearsSet.sort {
      $0 > $1
    }
    
    // create a dictionary for accessing years by section index
    for year in yearsSet {
      let array = sortedDiaryEntries.filter( {
        $0.year == year
      })
      sectionedDiaryEntries[year] = array
    }
  }
}

class DiaryEntryTableViewCell: UITableViewCell {
  @IBOutlet var dayLabel:UILabel!
  @IBOutlet var monthLabel:UILabel!
  @IBOutlet var entryLabel: UITextView!

  var diaryEntry: DiaryEntry! {
    didSet {
      dayLabel?.text = "\(diaryEntry.day)"
      monthLabel?.text = diaryEntry.month
      entryLabel?.text = diaryEntry.text
    }
  }
}

class DiaryHeaderTableViewCell: UITableViewCell {
  @IBOutlet var yearLabel: UILabel!
  
  var year: String! {
    didSet {
      yearLabel?.text = year
    }
  }
}