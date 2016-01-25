//
//  WebPageViewController.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-20.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit
import SVProgressHUD

class WebPageViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    var request: NSURLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
        
    @IBAction func goBack(sender: AnyObject) {
        webView.goBack()
    }
    /**
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
*/
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
}

extension WebPageViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("Loading...")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.showSuccessWithStatus("Loaded!")
        //SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.showInfoWithStatus("Reuqest Failed.")
    }
}
