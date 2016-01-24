//
//  GitHubAPIController.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-23.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit
import Alamofire

class GitHubAPIController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var trendOverall = [APIModel]()
    
    var request: String!
    var page: Int =  1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewList()
    }
    
    func initViewList() {
        tableView.registerNib(UINib(nibName: "APICell", bundle:nil), forCellReuseIdentifier: "cell")
        fetchJSON()
    }
    
    func fetchJSON() {
        
    }
    
    func parseJSON() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! APICell
        let url = NSURL(string: cell.url!)
        let controller = segue.destinationViewController as! WebPageViewController
        controller.request = NSURLRequest(URL: url!)
        controller.hidesBottomBarWhenPushed = true
        controller.title = cell.title.text
    }
}

extension GitHubAPIController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendOverall.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! APICell
        let APIitem: APIModel = trendOverall[indexPath.row]
        cell.title.text = APIitem.title
        cell.detail.text = APIitem.detail
        cell.info.text = "Version: \(APIitem.version)"
        cell.url = APIitem.url
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath) as! APICell
        if let _ = selectedCell.url {
            performSegueWithIdentifier("loadWeb", sender: selectedCell)
        }
    }
}


