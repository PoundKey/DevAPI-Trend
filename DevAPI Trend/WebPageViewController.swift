//
//  WebPageViewController.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-20.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit

class WebPageViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    var request: NSURLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(request)
    }
        
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

}
