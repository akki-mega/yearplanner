//
//  ViewController.swift
//  year planner
//
//  Created by A.F. on 2016/07/03.
//  Copyright © 2016年 A.F. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var scheduleTable: UITableView!
    
    var topSaveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    var scheduleNameArray = [String]()
    var scheduleIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scheduleTable.dataSource = self
        scheduleTable.delegate = self
        
        /*self.topSaveData.setObject(self.scheduleNameArray, forKey: "scheduleName")
        topSaveData.synchronize()*/
        
        if topSaveData.objectForKey("scheduleName") != nil{
            scheduleNameArray = topSaveData.objectForKey("scheduleName") as! [String]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        cell?.textLabel?.text = scheduleNameArray[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        scheduleIndex = indexPath.row
        performSegueWithIdentifier("ScheduleViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let scheduleViewController = segue.destinationViewController as! ScheduleViewController
        scheduleViewController.scheduleName = self.scheduleNameArray[scheduleIndex]
    }
    
    @IBAction func makeNewCell(){
        var scheduleName = ""
        let makeNewScheduleAlert: UIAlertController = UIAlertController(title: "New schedule", message: "", preferredStyle: .Alert)
        makeNewScheduleAlert.addTextFieldWithConfigurationHandler {
            (textField:UITextField!) -> Void in
            //scheduleName =
        }
        
        makeNewScheduleAlert.addAction(
            UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        )
        
        let defaultAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                let textFields = makeNewScheduleAlert.textFields
                if textFields != nil {
                    for textField in textFields! {
                        scheduleName = textField.text!
                        self.scheduleNameArray.append(scheduleName)
                        self.topSaveData.setObject(self.scheduleNameArray, forKey: "scheduleName")
                        self.topSaveData.synchronize()
                        self.scheduleTable.reloadData()
                    }
                }
        })
        
        makeNewScheduleAlert.addAction(defaultAction)
        presentViewController(makeNewScheduleAlert, animated: true, completion: nil)
        
    }
    
    

}

