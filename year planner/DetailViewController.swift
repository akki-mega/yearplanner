//
//  DetailViewController.swift
//  year planner
//
//  Created by A.F. on 2016/11/13.
//  Copyright © 2016年 A.F. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController ,UITextFieldDelegate ,UIToolbarDelegate , UIPickerViewDelegate, UIPickerViewDataSource {
    
    var scheduleItems: NSMutableArray = []
    var buttonSender:Int!
    var scheduleName:String!
    
    @IBOutlet var detailTextView: UITextView!
    
    var periodDatePicker1: UIDatePicker!
    var periodDatePicker2: UIDatePicker!
    var colorPickerView: UIPickerView!
    
    var toolBar1: UIToolbar!
    var toolBar2: UIToolbar!
    var toolBar3: UIToolbar!

    
    var scheduleNameSaveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var scheduleNameTextField: UITextField!
    @IBOutlet var periodTextField1: UITextField!
    @IBOutlet var periodTextField2: UITextField!
    @IBOutlet var colorTextField: UITextField!
    
    
    
    var periodUIColorArray: [UIColor] = [UIColor.blackColor() , UIColor.darkGrayColor() , UIColor.lightGrayColor() , UIColor.magentaColor() , UIColor.redColor() , UIColor.orangeColor() , UIColor.yellowColor() , UIColor.greenColor() , UIColor.cyanColor() , UIColor.blueColor() , UIColor.purpleColor() , UIColor.brownColor()]
    
    var periodColorArray: [String] = ["Black" , "Dark gray" , "Light gray" , "Magenta" , "Red" , "Orange" , "Yellow" , "Green" , "Cyan" , "Blue" , "Purple" , "Brown"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if scheduleNameSaveData.objectForKey(scheduleName) != nil {
            let tmpScheduleItems = scheduleNameSaveData.arrayForKey(scheduleName)! as NSArray
            scheduleItems = tmpScheduleItems.mutableCopy() as! NSMutableArray
            print("scheduleItems")
            print(scheduleItems)
        }
//        let keys: Array = Array(scheduleItems.keys)
//        scheduleNameTextField.text = keys[buttonSender]
        
        print(scheduleItems)
        print(buttonSender)
        
        scheduleNameTextField.text = scheduleItems[buttonSender]["title"] as! String
        
        scheduleNameTextField.delegate = self
        
        self.detailTextView.layer.borderColor = UIColor.blackColor().CGColor
        self.detailTextView.layer.borderWidth = 1
        self.detailTextView.layer.cornerRadius = 10
        
        if scheduleItems[buttonSender]["date1"] === nil{
            periodTextField1.placeholder = dateToString(NSDate())
            periodTextField1.text        = dateToString(NSDate())
        }
        else{
            periodTextField1.text        = scheduleItems[buttonSender]["date1"] as! String
            
            print(scheduleItems[buttonSender]["date1"])
        }
        self.view.addSubview(periodTextField1)
        
        periodDatePicker1 = UIDatePicker()
        periodDatePicker1.addTarget(self, action: "changedDateEvent1:", forControlEvents: UIControlEvents.ValueChanged)
        periodDatePicker1.datePickerMode = UIDatePickerMode.Date
        periodTextField1.inputView = periodDatePicker1
        
        if scheduleItems[buttonSender]["date2"] === nil{
            periodTextField2.placeholder = dateToString(NSDate())
            periodTextField2.text        = dateToString(NSDate())
        }
        else{
            periodTextField2.text        = scheduleItems[buttonSender]["date2"] as! String
        }
        self.view.addSubview(periodTextField2)
        
        periodDatePicker2 = UIDatePicker()
        periodDatePicker2.addTarget(self, action: "changedDateEvent2:", forControlEvents: UIControlEvents.ValueChanged)
        periodDatePicker2.datePickerMode = UIDatePickerMode.Date
        periodTextField2.inputView = periodDatePicker2
        
        colorTextField.textColor = periodUIColorArray[periodColorArray.indexOf(scheduleItems[buttonSender]["color"] as! String)!]
        colorTextField.text = scheduleItems[buttonSender]["color"] as! String
        self.view.addSubview(colorTextField)
        
        colorPickerView = UIPickerView()
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
        
        colorTextField.inputView = colorPickerView
        
        
        toolBar1 = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar1.barStyle = .Default
        toolBar1.tintColor = UIColor.blueColor()
        toolBar1.backgroundColor = UIColor.whiteColor()
        
        toolBar2 = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar2.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar2.barStyle = .Default
        toolBar2.tintColor = UIColor.blueColor()
        toolBar2.backgroundColor = UIColor.whiteColor()
        
        toolBar3 = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar3.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar3.barStyle = .Default
        toolBar3.tintColor = UIColor.blueColor()
        toolBar3.backgroundColor = UIColor.whiteColor()
        
        let toolBarButton1      = UIBarButtonItem(title: "Set", style: .Bordered, target: self, action: "tappedToolBarButton1:")
        let toolBarButton2      = UIBarButtonItem(title: "Set", style: .Bordered, target: self, action: "tappedToolBarButton2:")
        let toolBarButton3      = UIBarButtonItem(title: "Set", style: .Bordered, target: self, action: "tappedToolBarButton3:")
        
        toolBarButton1.tag = 1
        toolBar1.items = [toolBarButton1]
        periodTextField1.inputAccessoryView = toolBar1
        
        toolBarButton2.tag = 2
        toolBar2.items = [toolBarButton2]
        periodTextField2.inputAccessoryView = toolBar2
        
        toolBarButton3.tag = 3
        toolBar3.items = [toolBarButton3]
        colorTextField.inputAccessoryView = toolBar3
        
        if scheduleItems[buttonSender]["detail"] !== nil{
            detailTextView.text = scheduleItems[buttonSender]["detail"] as! String
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func periodColorChanger(){
        
    }
    
    func changedDateEvent1(sender:AnyObject?){
        var dateSelecter: UIDatePicker = sender as! UIDatePicker
        self.changeLabelDate1(periodDatePicker1.date)
    }
    
    func changeLabelDate1(date:NSDate) {
        periodTextField1.text = self.dateToString(date)
        var scheduleItem:[String:AnyObject] = scheduleItems[buttonSender] as! [String:AnyObject]
        scheduleItem["date1"] = periodTextField1.text
        scheduleItems[buttonSender] = scheduleItem as AnyObject
        self.scheduleNameSaveData.setObject(scheduleItems , forKey: self.scheduleName)
        self.scheduleNameSaveData.synchronize()
    }

    func changedDateEvent2(sender:AnyObject?){
        var dateSelecter: UIDatePicker = sender as! UIDatePicker
        self.changeLabelDate2(periodDatePicker2.date)
    }
    
    func changeLabelDate2(date:NSDate) {
        periodTextField2.text = self.dateToString(date)
        var scheduleItem:[String:AnyObject] = scheduleItems[buttonSender] as! [String:AnyObject]
        scheduleItem["date2"] = periodTextField2.text
        scheduleItems[buttonSender] = scheduleItem as AnyObject
        self.scheduleNameSaveData.setObject(scheduleItems , forKey: self.scheduleName)
        self.scheduleNameSaveData.synchronize()
    }
    
    func tappedToolBarButton1(sender: UIBarButtonItem) {
        periodTextField1.resignFirstResponder()
    }
    
    func tappedToolBarButton2(sender: UIBarButtonItem) {
        periodTextField2.resignFirstResponder()
    }
    
    func tappedToolBarButton3(sender: UIBarButtonItem) {
        colorTextField.resignFirstResponder()
    }
    
    func dateToString(date:NSDate) ->String {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale     = NSLocale(localeIdentifier: "ja")
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.stringFromDate(date)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return periodColorArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return periodColorArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colorTextField.text = periodColorArray[row]
        colorTextField.textColor = periodUIColorArray[row]
        var scheduleItem:[String:AnyObject] = scheduleItems[buttonSender] as! [String:AnyObject]
        scheduleItem["color"] = periodColorArray[row]
        scheduleItems[buttonSender] = scheduleItem as AnyObject
        self.scheduleNameSaveData.setObject(scheduleItems , forKey: self.scheduleName)
        self.scheduleNameSaveData.synchronize()
        
        print("scheduleItems　color change")
        print(self.scheduleNameSaveData.arrayForKey(self.scheduleName))
    }
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let text = detailTextView.text
        let titleText = scheduleNameTextField.text
        var scheduleItem:[String:AnyObject] = scheduleItems[buttonSender] as! [String:AnyObject]
        scheduleItem["detail"] = text
        scheduleItem["title"] = titleText
        scheduleItems[buttonSender] = scheduleItem as AnyObject
        self.scheduleNameSaveData.setObject(scheduleItems , forKey: self.scheduleName)
        self.scheduleNameSaveData.synchronize()
        

//        self.scheduleNameSaveData.setObject(self.scheduleItems , forKey: self.scheduleName)
//        self.scheduleNameSaveData.synchronize()
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
