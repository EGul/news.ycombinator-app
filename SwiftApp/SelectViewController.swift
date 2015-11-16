//
//  SelectViewController.swift
//  SwiftApp
//
//  Created by Evan on 10/28/15.
//  Copyright © 2015 none. All rights reserved.
//

import Foundation
import UIKit

import Reachability

class  SelectViewController: UIViewController, SeedsWrapperProtocol, IAPTableViewDelegate {
    
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    
    var storyURL = ""
    
    var webView = UIWebView()
    
    var reach: Reachability?
    
    var createAd = false
    var showIAPView = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        webView = UIWebView(frame: CGRectMake(0, 0, width, height))
        webView.scalesPageToFit = true
        
        let req = NSURLRequest(URL: NSURL(string: storyURL)!)
        webView.loadRequest(req)
        
        self.view.addSubview(webView)
        
        self.reach = Reachability.reachabilityForInternetConnection()
        
        self.reach!.startNotifier()
        
        if createAd && reach!.isReachable() {
            SeedsWrapper().delegate = self
            Seeds.sharedInstance().requestInAppMessage()
        }
        
    }
    
    func iapDidMakePurchase(amount: String) {
        
        let alertController = UIAlertController(title: "Thank You For Your Purchase!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        /*
        in app purchase code would go here
        seeds sdk request to iap endpoint would go here
        */
        
    }
    
    func seedsWrapperInAppMessageClicked() {
        showIAPView = true
    }
    
    func seedsWrapperInAppMessageClosed() {
        if showIAPView {
            let iapTableView = IAPTableViewController()
            iapTableView.delegate = self
            self.navigationController?.pushViewController(iapTableView, animated: true)
            showIAPView = false
        }
    }
    
    func seedsWrapperInAppMessageLoadSucceeded() {
        Seeds.sharedInstance().showInAppMessageIn(self)
    }
    
    func seedsWrapperInAppMessageShown() {
    }
    
    func seedsWrapperNoInAppMessageFound() {
    }
    
    func rotated() {
        webView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}
