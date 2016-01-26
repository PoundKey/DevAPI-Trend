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

func createHeaderRefreshControl(controller: UIViewController, action: Selector) -> XWRefreshNormalHeader {
    let header: XWRefreshNormalHeader = XWRefreshNormalHeader(target: controller, action: action)
    header.automaticallyChangeAlpha = true
    header.stateLabel.font = UIFont.boldSystemFontOfSize(15)
    header.lastUpdatedTimeLabel.font = UIFont.systemFontOfSize(13)
    return header
}

func createFooterRefreshControl(controller: UIViewController, action: Selector) -> XWRefreshAutoNormalFooter {
    let footer: XWRefreshAutoNormalFooter = XWRefreshAutoNormalFooter(target: controller, action: action)
    return footer
}

/**
 Helper function used to generate parameter string in GET request
 
 - parameter dict: parameter dictionary
 
 - returns: partial string for GET request
 */

func generateQuery(dict: [String: String]) -> String {
    let query   = dict["q"]!
    let sortVar = dict["sort"]!
    let order   = dict["order"]!
    let page    = dict["page"]!
    return "q=\(query)&sort=\(sortVar)&order=\(order)&page=\(page)"
}
