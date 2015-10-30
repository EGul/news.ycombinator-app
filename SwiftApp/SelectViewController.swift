//
//  SelectViewController.swift
//  SwiftApp
//
//  Created by Evan on 10/28/15.
//  Copyright © 2015 none. All rights reserved.
//

import Foundation
import UIKit

class  SelectViewController: UIViewController {
    
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    
    var storyURL = ""
    
    var webView = UIWebView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        webView = UIWebView(frame: CGRectMake(0, 0, width, height))
        
        let req = NSURLRequest(URL: NSURL(string: storyURL)!)
        webView.loadRequest(req)
        
        self.view.addSubview(webView)
        
    }
    
    func rotated() {
        webView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}
