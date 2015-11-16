//
//  IAPTableView.swift
//  SwiftApp
//
//  Created by Evan on 11/15/15.
//  Copyright © 2015 none. All rights reserved.
//

import Foundation
import UIKit

protocol IAPTableViewDelegate {
    func iapDidMakePurchase(amount: String)
}

class IAPTableViewController: UITableViewController {
    
    let dataSource = ["test $1.00", "test $2.50", "test $5.00", "test $10.00", "test $100.00"]
    var amount = ""
    var delegate: IAPTableViewDelegate? = nil
    
    func setup() {
        
        let width = self.tableView.frame.size.width
        let height = self.tableView.frame.size.height
        
        self.tableView.frame = CGRectMake(0, 50, width, height - 50)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("something")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "something")
        }
        
        cell?.textLabel?.text = dataSource[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        amount = (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!
        amount = amount.stringByReplacingOccurrencesOfString("test $", withString: "")
        
        let message = "this is a test for in app purchases.\n no real purchase will be made."
        
        let doneAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
            self.delegate?.iapDidMakePurchase(self.amount)
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil)
        
        let alertController = UIAlertController(title: "Are You Sure?", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }

}