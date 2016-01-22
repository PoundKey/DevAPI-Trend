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
        setSVHubStyle()
        webView.delegate = self
        webView.loadRequest(request)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
        
    @IBAction func goBack(sender: AnyObject) {
        webView.goBack()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func setSVHubStyle() {
        //SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.75))
        SVProgressHUD.setForegroundColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1))
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
