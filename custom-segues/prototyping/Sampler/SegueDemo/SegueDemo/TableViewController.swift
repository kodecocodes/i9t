//
//  TableViewController.swift
//  CellExpand
//
//  Created by Caroline Begbie on 20/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

  var data = [String]()
  var selectedCell:UITableViewCell?
  var selectedCellViewFrame = CGRect.zeroRect
  
    override func viewDidLoad() {

      super.viewDidLoad()

      data = []
      for i in 0...100 {
        data.append("\(i)")
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row]

        return cell
    }

  @IBAction func unwindToTableViewController(segue: UIStoryboardSegue) {
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Segue" {
      let cell = sender as! UITableViewCell
      let indexPath = tableView.indexPathForCell(cell)!
      let controller = segue.destinationViewController
  
      if let label = controller.view.viewWithTag(1) as? UILabel {
        label.text = data[indexPath.row]
      }
      selectedCell = cell
      
      if let selectedCell = selectedCell {
        let rectInTableView = tableView.rectForRowAtIndexPath(tableView.indexPathForCell(selectedCell)!)
        let rectInSuperView = tableView.convertRect(rectInTableView, toView: tableView.superview)
        selectedCellViewFrame = rectInSuperView
      }

    }
   }
}

extension TableViewController: CellScaleable {
  var cellView:UIView? {return selectedCell?.contentView }
  var cellViewFrame:CGRect {
    return selectedCellViewFrame
  }
}
