//
//  CategoryController.swift
//  MaxMemo
//
//  Created by Aleksandar Dimitrov on 3/29/15.
//  Copyright (c) 2015 Aleksandar Dimitrov. All rights reserved.
//

import Foundation
import UIKit

class CategoryContrller: UIViewController, UITableViewDelegate {
    @IBOutlet var categoriesTableView: UITableView!
    var categories: [String] = ["We", "Heart", "Swift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.categoriesTableView.dequeueReusableCellWithIdentifier("categoryCell") as UITableViewCell
        
        cell.textLabel?.text = self.categories[indexPath.row]
        
        return cell
    }
    
    @IBAction func addCategory(sender: AnyObject) {
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Add Category",
            message: "Enter category name below",
            preferredStyle: .Alert)
        
        alertController!.addTextFieldWithConfigurationHandler({(textField: UITextField!) in})
        
        let action = UIAlertAction(title: "Add",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields{
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    self!.categories.append(enteredText)
                    self!.categoriesTableView.reloadData();
                }
        })
        
        alertController!.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in }))
        
        alertController?.addAction(action)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
        
        
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            categories.removeAtIndex(indexPath.row)
            categoriesTableView.reloadData();
        }
    }
}