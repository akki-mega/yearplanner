//
//  ScheduleViewController.swift
//  year planner
//
//  Created by A.F. on 2016/07/30.
//  Copyright © 2016年 A.F. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet var monthButtonArray: [UIButton]!
    
    
    @IBOutlet var scheduleNameLabel:UILabel!
    var scheduleName:String!
    
    
    var buttonChecker: Int = 0
    var buttonCheckTag: Int!
    
    var buttonSender:Int!
    
    var buttonCounter:Int = 0

    var scheduleNameSaveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var scheduleItems: NSMutableArray = []
    
    @IBOutlet var yearImageView: UIImageView!
    
    var periodButtonArray: [UIButton] = []
    
    var periodUIColorArray: [UIColor] = [UIColor.blackColor() , UIColor.darkGrayColor() , UIColor.lightGrayColor() , UIColor.magentaColor() , UIColor.redColor() , UIColor.orangeColor() , UIColor.yellowColor() , UIColor.greenColor() , UIColor.cyanColor() , UIColor.blueColor() , UIColor.purpleColor() , UIColor.brownColor()]
    
    var periodColorArray: [String] = ["Black" , "Dark gray" , "Light gray" , "Magenta" , "Red" , "Orange" , "Yellow" , "Green" , "Cyan" , "Blue" , "Purple" , "Brown"]
        
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = UIInterfaceOrientationMask.LandscapeRight
        
        return orientation
    }
    
    //指定方向に自動的に変更
    override func shouldAutorotate() -> Bool{
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        periodButtonArray.removeAll()
        
        self.title = scheduleName
        
        // Do any additional setup after loading the view.
        if scheduleNameSaveData.objectForKey(scheduleName) != nil {
            let tmpScheduleItems = scheduleNameSaveData.arrayForKey(scheduleName)! as NSArray
            scheduleItems = tmpScheduleItems.mutableCopy() as! NSMutableArray
            print("scheduleItems")
            print(scheduleItems)
            
            
        }
        
        
        
        buttonCounter = 0

        for item in scheduleItems {
            //periodButtonArray[buttonCounter].removeFromSuperview()
            print(item)
            print (buttonCounter)
            let i1: Int = (item["period"] as! Int) / 100
            let i2: Int = (item["period"] as! Int) % 100
            
            let button1 = monthButtonArray[i1]
            let button2 = monthButtonArray[i2]
            let periodButton = UIButton(frame: CGRect(x: button1.frame.origin.x, y: yearImageView.frame.origin.y + CGFloat(5) + CGFloat(periodButtonArray.count) * 20, width: button2.frame.origin.x + button2.frame.size.width - button1.frame.origin.x, height: 15))
            periodButton.tag = buttonCounter
            periodButton.addTarget(self, action: "toNext:", forControlEvents: .TouchUpInside)
            periodButton.backgroundColor = periodUIColorArray[periodColorArray.indexOf(item["color"] as! String)!]
            periodButtonArray.append(periodButton)
            self.view.addSubview(periodButton)
            buttonCounter = buttonCounter + 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func monthButton(sender: UIButton){
        if buttonChecker == 0{
            monthButtonArray[sender.tag].backgroundColor = UIColor(red: 0.976, green: 0.780, blue: 0.788, alpha: 1)
            buttonCheckTag = sender.tag
            buttonChecker = 1
        }
        else {
            var itemName = ""
            let makescheduleItemsAlert: UIAlertController = UIAlertController(title: "New schedule item", message: "", preferredStyle: .Alert)
            makescheduleItemsAlert.addTextFieldWithConfigurationHandler {
                (textField:UITextField!) -> Void in
            }
            
            makescheduleItemsAlert.addAction(
                UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            )
            
            let defaultAction = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler:{
                    (action:UIAlertAction!) -> Void in
                    let nameingTextField = makescheduleItemsAlert.textFields
                    if nameingTextField != nil {
                        for textField in nameingTextField! {
                            let period = self.buttonCheckTag * 100 + sender.tag
                            let title = textField.text!
                            let color = "Cyan"
                            let scheduleItem = ["title": title , "period": period , "color": color]
                            //append(scheduleItem)
                            
                            print(">>>>>>>>>>>>>>>>>")
                            print(scheduleItem)
                            print("<<<<<<<<<<<<<<<<<")
                            
                            self.scheduleItems.addObject(scheduleItem)
//                            scheduleItems[]["name"] = textField.text!
//                            self.scheduleItems[itemName] = self.buttonCheckTag * 100 + sender.tag
                            self.scheduleNameSaveData.setObject(self.scheduleItems ,
                                forKey: self.scheduleName)
                            self.scheduleNameSaveData.synchronize()
                            print("------------------")
                            print(self.scheduleNameSaveData.objectForKey(self.scheduleName))
                        }
                    }
            })
            
            makescheduleItemsAlert.addAction(defaultAction)
            presentViewController(makescheduleItemsAlert, animated: true, completion: nil)

            
            if sender.tag >= buttonCheckTag{
                if yearImageView.frame.origin.y + CGFloat(5) + CGFloat(periodButtonArray.count) * 20 < yearImageView.frame.origin.y + yearImageView.frame.size.height {
                    
                    let periodButton = UIButton(frame: CGRect(x: monthButtonArray[buttonCheckTag].frame.origin.x, y: yearImageView.frame.origin.y + CGFloat(5) + CGFloat(periodButtonArray.count) * 20, width: monthButtonArray[sender.tag].frame.origin.x + monthButtonArray[sender.tag].frame.size.width - monthButtonArray[buttonCheckTag].frame.origin.x, height: 15))
                    
                    periodButton.tag = buttonCounter
                    buttonCounter = buttonCounter + 1
                    periodButton.addTarget(self, action: "toNext:", forControlEvents: .TouchUpInside)
                    periodButton.backgroundColor = UIColor.cyanColor()
                    self.view.addSubview(periodButton)
                    periodButtonArray.append(periodButton)
                    monthButtonArray[buttonCheckTag].backgroundColor = UIColor(red: 0.894, green: 0.988, blue: 1, alpha: 1)
                    buttonChecker = 0
                }
                else {
                    let overAlert: UIAlertController = UIAlertController(title: "It's full!", message: "", preferredStyle: .Alert)
                    overAlert.addAction(
                        UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    )
                    presentViewController(overAlert, animated: true, completion: nil)
                    monthButtonArray[buttonCheckTag].backgroundColor = UIColor(red: 0.894, green: 0.988, blue: 1, alpha: 1)
                    buttonChecker = 0
                }
            }
            else {
                monthButtonArray[buttonCheckTag].backgroundColor = UIColor(red: 0.894, green: 0.988, blue: 1, alpha: 1)
                buttonChecker = 0
            }
        }
    }
    
    
    
//    @IBAction func home(){
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    
    
    func toNext(sender: UIButton){
        buttonSender = sender.tag
        performSegueWithIdentifier("detailViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController:DetailViewController = segue.destinationViewController as! DetailViewController
//        detailViewController.scheduleNameSaveData = self.scheduleNameSaveData
        detailViewController.scheduleName = self.scheduleName
        detailViewController.scheduleItems = self.scheduleItems
        detailViewController.buttonSender = self.buttonSender
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
