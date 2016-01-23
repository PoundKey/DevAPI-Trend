//
//  GitHubViewController.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-19.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit
import Alamofire

class GitHubViewController: UIViewController {
    
    var topBarItems = []
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewList()
        // Do any additional setup after loading the view.
    }
    
    func initViewList() {
        topBarItems = ["Swift", "JavaScript", "Overall"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: topBarItems as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insertIntoRootViewController(self)
        self.style()
        //let swiftRepo = "https://api.github.com/search/repositories?q=language:swift+stars:>300+created:>2014-06-01&sort=stars&order=desc"
    }

    
    func style() {
        let color: UIColor = UIColor(red: 24.0 / 255, green: 75.0 / 255, blue: 152.0 / 255, alpha: 1)
        /**
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .BlackTranslucent
        */
        carbonTabSwipeNavigation.toolbar.translucent = false
        carbonTabSwipeNavigation.setIndicatorColor(color)
        
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        let width = self.view.frame.size.width / 3
        
        for var i = 0; i < topBarItems.count; i++ {
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: i)
        }
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.blackColor().colorWithAlphaComponent(0.6), font: UIFont.boldSystemFontOfSize(15))
        carbonTabSwipeNavigation.setSelectedColor(color, font: UIFont.boldSystemFontOfSize(15))
        
    }
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension GitHubViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController {
        switch index {
        default:
            return UIViewController()
        }
        
    }
    
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAtIndex index: UInt) {
        switch index {
        default:
            self.navigationItem.title = "CarbonKit"
        }
    }
}
