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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let webView = UIWebView(frame: CGRectMake(0, 0, width, height))
        
        let req = NSURLRequest(URL: NSURL(string: storyURL)!)
        webView.loadRequest(req)
        
        self.view.addSubview(webView)
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}
