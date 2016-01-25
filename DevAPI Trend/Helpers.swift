//
//  Helpers.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-24.
//  Copyright © 2016 DX. All rights reserved.
//

import Foundation

func emptyTableViewPage(tableView: UITableView, width:CGFloat, height: CGFloat) {
    let messageLabel = UILabel(frame: CGRectMake(0, 0, width, height))
    messageLabel.text = "No DevAPI data is currently available. Please pull down to refresh."
    messageLabel.textColor = UIColor.blackColor()
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .Center
    messageLabel.font = UIFont(name: "Palatino-Italic", size: 18)
    messageLabel.sizeToFit()
    
    tableView.backgroundView = messageLabel;
    tableView.separatorStyle = .None
}

func lastUpdatedFormatter(refreshControl: UIRefreshControl) {
    let formatter: NSDateFormatter = NSDateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    let title: String = "Last update: \(formatter.stringFromDate(NSDate()))"
    let attrsDictionary = NSDictionary(object: UIColor.grayColor(), forKey: NSForegroundColorAttributeName)
    let attributedTitle: NSAttributedString = NSAttributedString(string: title, attributes: attrsDictionary as? [String : AnyObject])
    refreshControl.attributedTitle = attributedTitle
}

func lastUpdatedTime() -> String {
    let formatter: NSDateFormatter = NSDateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    let time: String = "Last update: \(formatter.stringFromDate(NSDate()))"
    return time
}

func createMJRefreshNormalHeader(controller: UIViewController, action: Selector) -> MJRefreshNormalHeader {
    let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingTarget: controller, refreshingAction: action)
    header.automaticallyChangeAlpha = true
    header.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(12)
    header.setTitle("Pull down to refresh", forState: .Idle)
    header.setTitle("Release to refresh", forState: .Pulling)
    header.setTitle("Loading...", forState: .Refreshing)
    return header
}
