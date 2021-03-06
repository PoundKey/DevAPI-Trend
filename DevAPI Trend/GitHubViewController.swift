//
//  GitHubViewController.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-19.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit

class GitHubViewController: UIViewController {
    
    var topBarItems = []
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var currentController: GitHubAPIController?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewList()
    }
    
    func initViewList() {
        topBarItems = ["Swift", "JavaScript", "Overall"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: topBarItems as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insertIntoRootViewController(self)
        self.currentController = self.carbonTabSwipeNavigation.viewControllers[0] as? GitHubAPIController
        self.style()
    }

    @IBAction func srollToTop(sender: AnyObject) {
        if let tableView = self.currentController?.tableView {
            tableView.setContentOffset(CGPointZero, animated:true)
        }
    }
    
    func style() {
        //let color: UIColor = UIColor(red: 24.0 / 255, green: 75.0 / 255, blue: 152.0 / 255, alpha: 1)
        let color: UIColor = UIColor(red: 0.0 / 255, green: 94.0 / 255, blue: 170.0 / 255, alpha: 1)

        carbonTabSwipeNavigation.toolbar.translucent = false
        carbonTabSwipeNavigation.setIndicatorColor(color)
        
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        let width = self.view.frame.size.width / 3
        
        for var i = 0; i < topBarItems.count; i++ {
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: i)
        }
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.blackColor().colorWithAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(color, font: UIFont.boldSystemFontOfSize(15))
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension GitHubViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("GitHubAPIController") as! GitHubAPIController
        
        switch index {
        case 0:
            let swiftRepo = "language:swift+stars:>300+created:>2014-06-01"
            controller.query = swiftRepo
        case 1:
            let javaScriptRepo = "language:javascript+stars:>300+created:>2015-01-01"
            controller.query = javaScriptRepo
        case 2:
            let overallRepo = "stars:>1000+created:>2015-01-01"
            controller.query = overallRepo
        default:
            controller.query = ""
        }
        return controller
    }
    
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAtIndex index: UInt) {
        self.currentController = self.carbonTabSwipeNavigation.viewControllers[index] as? GitHubAPIController
    }
}
