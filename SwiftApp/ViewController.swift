//
//  ViewController.swift
//  SwiftApp
//
//  Created by Evan on 10/28/15.
//  Copyright © 2015 none. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataArr: [NSDictionary] = []
    var selectedArr: [String] = []
    
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height

    var limitView = UIView()
    var limitViewLabel = UILabel()
    var limitMaxLimitLabel = UILabel()
    var limitIntervalLabel = UILabel()
    var limitCount = 0
    var maxLimit = 5
    var limitTimer = NSTimer()
    var limitTimerIsRunning = false
    var limitTimerInterval = 15.0 * 60

    var leftPickerView = UIPickerView()
    var rightPickerView = UIPickerView()
    var leftPickerViewData = ["unlimited", "1", "2", "3", "4", "5"]
    var leftPickerViewLimit = 5
    var rightPickerViewData = ["1min", "5min", "10min", "15min", "30min"]
    var rightPickerViewInterval = 15.0 * 60

    var mainTableView = UITableView()
    var mainTableViewIsDown = false
    var mainTableViewIsAnimating = false
    var refreshControl = UIRefreshControl()
    let mainTableViewCellIdentifier = "something"

    let newsAPI = NewsAPI()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "news.ycombinator"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)

        let statusHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        let topHeight = statusHeight + navHeight!
        self.view.backgroundColor = UIColor.whiteColor()

        limitView = UIView(frame: CGRectMake(0, topHeight, width, 50))
        limitView.backgroundColor = UIColor.whiteColor()

        limitViewLabel = UILabel(frame: CGRectMake(0, 0, width, 50))
        limitViewLabel.text = "0 of " + String(maxLimit) + " stories left"
        limitViewLabel.textColor = UIColor.blackColor()
        limitViewLabel.textAlignment = NSTextAlignment.Center

        let limitViewSpace = limitView.frame.origin.y + limitView.frame.size.height
        limitMaxLimitLabel = UILabel(frame: CGRectMake(10, limitViewSpace, width / 2, 50))
        limitMaxLimitLabel.text = "Maximum Read"
        limitMaxLimitLabel.textAlignment = NSTextAlignment.Center
        limitMaxLimitLabel.layer.zPosition = -100

        limitIntervalLabel = UILabel(frame: CGRectMake(width / 2, limitViewSpace, width / 2, 50))
        limitIntervalLabel.text = "Reset Interval"
        limitIntervalLabel.textAlignment = NSTextAlignment.Center
        limitIntervalLabel.layer.zPosition = -100

        let limitPickerLabelSpace = limitIntervalLabel.frame.origin.y + limitIntervalLabel.frame.size.height

        leftPickerView = UIPickerView(frame: CGRectMake(0, limitPickerLabelSpace, width / 2, 150))
        leftPickerView.delegate = self
        leftPickerView.dataSource = self
        leftPickerView.selectRow(5, inComponent: 0, animated: false)

        rightPickerView = UIPickerView(frame: CGRectMake(width / 2, limitPickerLabelSpace, width / 2, 150))
        rightPickerView.delegate = self
        rightPickerView.dataSource = self
        rightPickerView.selectRow(3, inComponent: 0, animated: false)

        mainTableView = UITableView(frame: CGRectMake(0, limitViewSpace, width, height - limitViewSpace))
        mainTableView.delegate = self
        mainTableView.dataSource = self

        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        mainTableView.addSubview(refreshControl)

        limitView.addSubview(limitViewLabel)
        self.view.addSubview(limitView)
        self.view.addSubview(limitMaxLimitLabel)
        self.view.addSubview(limitIntervalLabel)
        self.view.addSubview(leftPickerView)
        self.view.addSubview(rightPickerView)
        self.view.addSubview(mainTableView)
        
        newsAPI.getTopStories() { (result: [NSDictionary], error: NSError?) in
            
            if (error == nil) {
                
                self.dataArr = result
                dispatch_async(dispatch_get_main_queue()) {
                    self.mainTableView.reloadData()
                }
                
            }
            
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rotated() {
        
        let orientation = UIDevice.currentDevice().orientation
        
        if (orientation == UIDeviceOrientation.FaceUp ||
            orientation == UIDeviceOrientation.FaceDown ||
            orientation == UIDeviceOrientation.Unknown) {
            return
        }
        
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        let topHeight = statusHeight + navHeight!
        
        let leftPickerViewSelectedRow = leftPickerView.selectedRowInComponent(0)
        let rightPickerViewSelectedRow = rightPickerView.selectedRowInComponent(0)
        
        var toLeftPickerView = UIPickerView()
        var toRightPickerView = UIPickerView()
        
        if orientation == UIDeviceOrientation.Portrait {
            
            limitView.frame = CGRectMake(0, topHeight, width, 50)
            limitViewLabel.frame = CGRectMake(0, 0, width, 50)
            
            let limitViewSpace = limitView.frame.origin.y + limitView.frame.size.height
            
            limitMaxLimitLabel.frame = CGRectMake(10, limitViewSpace, width / 2, 50)
            limitIntervalLabel.frame = CGRectMake(width / 2, limitViewSpace, width / 2, 50)
            
            let limitPickerLabelSpace = limitIntervalLabel.frame.origin.y + limitIntervalLabel.frame.size.height
            
            toLeftPickerView = UIPickerView(frame: CGRectMake(0, limitPickerLabelSpace, width / 2, leftPickerView.frame.size.height))
            toLeftPickerView.layer.zPosition = -100
            toLeftPickerView.userInteractionEnabled = false
            
            toRightPickerView = UIPickerView(frame: CGRectMake(width / 2, limitPickerLabelSpace, width / 2, leftPickerView.frame.size.height))
            toRightPickerView.layer.zPosition = -100
            toRightPickerView.userInteractionEnabled = false
            
            mainTableView.frame = CGRectMake(0, limitViewSpace, width, height - limitViewSpace)
            
        }
        
        if UIDeviceOrientationIsLandscape(orientation) {
            
            limitView.frame = CGRectMake(0, topHeight, height, 50)
            limitViewLabel.frame = CGRectMake(0, 0, height, 50)
            
            let limitViewSpace = limitView.frame.origin.y + limitView.frame.size.height

            limitMaxLimitLabel.frame = CGRectMake(10, limitViewSpace, height / 2, 50)
            limitIntervalLabel.frame = CGRectMake(height / 2, limitViewSpace, height / 2, 50)
            
            let limitPickerLabelSpace = limitIntervalLabel.frame.origin.y + limitIntervalLabel.frame.size.height
            
            toLeftPickerView = UIPickerView(frame: CGRectMake(0, limitPickerLabelSpace, height / 2, leftPickerView.frame.size.height))
            toLeftPickerView.layer.zPosition = -100
            toLeftPickerView.userInteractionEnabled = false
            
            toRightPickerView = UIPickerView(frame: CGRectMake(height / 2, limitPickerLabelSpace, height / 2, leftPickerView.frame.size.height))
            toRightPickerView.layer.zPosition = -100
            toRightPickerView.userInteractionEnabled = false
            
            mainTableView.frame = CGRectMake(0, limitViewSpace, height, width - limitViewSpace)
            
        }
        
        leftPickerView.removeFromSuperview()
        self.view.addSubview(toLeftPickerView)
        leftPickerView = toLeftPickerView
        
        rightPickerView.removeFromSuperview()
        self.view.addSubview(toRightPickerView)
        rightPickerView = toRightPickerView
        
        leftPickerView.delegate = self
        leftPickerView.dataSource = self
        
        rightPickerView.delegate = self
        rightPickerView.dataSource = self
        
        leftPickerView.selectRow(leftPickerViewSelectedRow, inComponent: 0, animated: false)
        rightPickerView.selectRow(rightPickerViewSelectedRow, inComponent: 0, animated: false)
        
        mainTableViewIsDown = false
        mainTableViewIsAnimating = false
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moveTableView()
        limitViewLabel.textColor = UIColor.blackColor()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        limitViewLabel.textColor = UIColor.lightGrayColor()
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        limitViewLabel.textColor = UIColor.blackColor()
    }

    func moveTableView() {

        if (!mainTableViewIsAnimating) {

            mainTableViewIsAnimating = true

            if !mainTableViewIsDown {

                moveTableViewDown()

            }
            else {

                moveTableViewUp()

                if leftPickerViewLimit == -1 {
                    limitCount = 0
                    limitTimer.invalidate()
                }
                
                if limitCount == -1 && leftPickerViewLimit > limitCount {
                    limitCount = 0
                }

                if limitCount > leftPickerViewLimit {
                    limitCount = leftPickerViewLimit
                }

                if limitTimerInterval != rightPickerViewInterval {
                    if limitTimerIsRunning {
                        limitTimer.invalidate()
                        setLimitIntervalTimer(rightPickerViewInterval)
                    }
                }

                maxLimit = leftPickerViewLimit
                limitTimerInterval = rightPickerViewInterval
                setLimitLabelText()

            }

        }

    }

    func moveTableViewDown() {

        UIView.animateWithDuration(0.5, animations: {
            let x = self.mainTableView.frame.origin.x
            let y = self.mainTableView.frame.origin.y + 200
            let tableWidth = self.mainTableView.frame.size.width
            let tableHeight = self.mainTableView.frame.size.height
            self.mainTableView.frame = CGRectMake(x, y, tableWidth, tableHeight)
            }, completion: { (value: Bool) in
                self.mainTableViewIsDown = true
                self.mainTableViewIsAnimating = false
                self.leftPickerView.userInteractionEnabled = true
                self.rightPickerView.userInteractionEnabled = true
        })

    }

    func moveTableViewUp() {

        UIView.animateWithDuration(0.5, animations: {
            let x = self.mainTableView.frame.origin.x
            let y = self.mainTableView.frame.origin.y - 200
            let tableWidth = self.mainTableView.frame.size.width
            let tableHeight = self.mainTableView.frame.size.height
            self.mainTableView.frame = CGRectMake(x, y, tableWidth, tableHeight)
            }, completion: { (value: Bool) in
                self.mainTableViewIsDown = false
                self.mainTableViewIsAnimating = false
                self.leftPickerView.userInteractionEnabled = false
                self.rightPickerView.userInteractionEnabled = false
        })

    }

    func setLimitIntervalTimer(interval: Double) {
        limitTimer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "limitTimerDidElapse", userInfo: nil, repeats: false)
    }

    func limitTimerDidElapse() {

        limitCount--

        if limitCount > 0 {
            setLimitIntervalTimer(limitTimerInterval)
        }
        else {
            limitTimerIsRunning = false
        }

        setLimitLabelText()

    }

    func setLimitLabelText() {
        if (maxLimit == -1) {
            limitViewLabel.text = "you can read as many stories as you want!"
        }
        else {
            limitViewLabel.text = String(limitCount) + " of " + String(maxLimit) + " stories left"
        }
    }

    func refresh() {
        
        newsAPI.getTopStories() { (result: [NSDictionary], error: NSError?) in
            if (error == nil) {
                self.refreshControl.endRefreshing()
                self.dataArr = result
                dispatch_async(dispatch_get_main_queue()) {
                    self.mainTableView.reloadData()
                }
            }
            else {
                self.refreshControl.endRefreshing()
            }
        }

    }
    
    func getFormattedURL(index: Int) -> String {
        
        var storyURL: String
        
        if dataArr[index].valueForKey("url") == nil {
            storyURL = "news.ycombinator.com"
        }
        else {
            storyURL = NSURL(string: String(dataArr[index].valueForKey("url")!))!.host!
        }
        
        storyURL = storyURL.stringByReplacingOccurrencesOfString("http://", withString: "")
        storyURL = storyURL.stringByReplacingOccurrencesOfString("https://", withString: "")
        storyURL = storyURL.stringByReplacingOccurrencesOfString("www.", withString: "")
        
        return storyURL
    }
    
    func getTimeSincePost(num: Int) -> String {
        
        let diff = (Int(NSDate().timeIntervalSince1970) - num) / 60
        
        if diff == 0 {
            return "a moment ago"
        }
        
        if diff < 60 {
            return String(diff) + " minutes ago"
        }
        
        return String(diff / 60) + " hours ago"
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        var cell = tableView.dequeueReusableCellWithIdentifier(mainTableViewCellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: mainTableViewCellIdentifier)
            cell!.textLabel?.numberOfLines = 3
            cell!.detailTextLabel?.numberOfLines = 4
            cell!.detailTextLabel?.textColor = UIColor.grayColor()
        }
        
        if selectedArr.contains(String(dataArr[row].valueForKey("id")!)) == false {
            cell!.textLabel?.textColor = UIColor.blackColor()
        }
        else {
            cell!.textLabel?.textColor = UIColor.grayColor()
        }
        
        var detailText = getFormattedURL(row) + "\n"
        
        if let score = dataArr[row].valueForKey("score") {
            detailText += String(score) + " points"
        }
        if let by = dataArr[row].valueForKey("by") {
            detailText += " by " + String(by)
        }
        if let time = dataArr[row].valueForKey("time") {
            detailText += " " + getTimeSincePost(Int(String(time))!)
        }
        if let descendants = dataArr[row].valueForKey("descendants") {
            detailText += " | " + String(descendants) + " comments"
        }
        
        cell!.textLabel?.text = dataArr[row].valueForKey("title") as? String
        cell!.detailTextLabel?.text = detailText
        
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if (limitCount < maxLimit || maxLimit == -1) {

            if maxLimit != -1 {

                limitCount++

                if (!limitTimerIsRunning) {
                    setLimitIntervalTimer(limitTimerInterval)
                    limitTimerIsRunning = true
                }

                setLimitLabelText()

            }
            
            if selectedArr.contains(String(dataArr[indexPath.row].valueForKey("id"))) == false {
                selectedArr.append(String(dataArr[indexPath.row].valueForKey("id")!))
                tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.textColor = UIColor.grayColor()
            }
            
            let row = indexPath.row
            var storyURL = dataArr[row].valueForKey("url") as? String
            
            if storyURL == nil {
                storyURL = "https://news.ycombinator.com/item?id=" + String(dataArr[row].valueForKey("id")!)
            }

            let selectViewController = SelectViewController()
            selectViewController.storyURL = storyURL!

            self.navigationController?.pushViewController(selectViewController, animated: true)

        }

        tableView.deselectRowAtIndexPath(indexPath, animated: false)

    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == leftPickerView) {
            return leftPickerViewData.count
        }
        else {
            return rightPickerViewData.count
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == leftPickerView) {
            return leftPickerViewData[row]
        }
        else {
            return rightPickerViewData[row]
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == leftPickerView) {
            if (leftPickerViewData[row] == "unlimited") {
                leftPickerViewLimit = -1
            }
            else {
                leftPickerViewLimit = Int(leftPickerViewData[row])!
            }
        }
        else {
            var tempString = rightPickerViewData[row]
            tempString = tempString.substringToIndex(tempString.endIndex.advancedBy(-3))
            rightPickerViewInterval = Double(tempString)! * 60
        }
    }

}
