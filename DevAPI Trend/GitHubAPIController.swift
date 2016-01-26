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
    
    let request = "https://api.github.com/search/repositories"
    var query: String!
    var page: Int =  1
    
    // A closure that tackles the problem of default encoding ("+" and ">") provided by Alamofire,
    // unfortunately GitHub search API does not like it, therefore customization is provided.
    let custom: (URLRequestConvertible, parameters: [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) = { req, param in
        let request = req.URLRequest.mutableCopy() as! NSMutableURLRequest
        let baseURL = (request.URL?.absoluteString)!
        var reqString = baseURL + "?" + generateQuery(param as! [String: String])
        let charSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        reqString = reqString.stringByAddingPercentEncodingWithAllowedCharacters(charSet)!
        let URL = NSURL(string: reqString)
        request.URL = URL
        return (request, nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initViewList()
    }

    func initViewList() {
        tableView.registerNib(UINib(nibName: "DevCell", bundle:nil), forCellReuseIdentifier: "cell")
        self.tableView.headerView = createHeaderRefreshControl(self, action: "reloadJSON")
        self.tableView.footerView = createFooterRefreshControl(self, action: "fetchJSON")
        SVProgressHUD.show()
        reloadJSON()
    }
    
    func reloadJSON() {
        let param: [String: String] = ["q": query, "sort": "stars", "order": "desc", "page": "1"]
        
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: param, encoding: .Custom(custom)).responseJSON { res in
            switch res.result {
            case .Success(let value):
                self.trendOverall.removeAll()
                self.page = 1 //reset data and request page
                let json = JSON(value)
                let items = json["items"]
                self.parseJSON(items)
            case .Failure:
                SVProgressHUD.showErrorWithStatus("Reuqest Failed.")
            }

            self.tableView.headerView?.endRefreshing()
        }
    }
    
    func fetchJSON() {
        
        let param: [String: String] = ["q": query, "sort": "stars", "order": "desc", "page": String(page)]

        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: param, encoding: .Custom(custom)).responseJSON { res in
            
            switch res.result {
            case .Success(let value):
                let json = JSON(value)
                let items = json["items"]
                self.parseJSON(items)
            case .Failure:
                SVProgressHUD.showErrorWithStatus("Reuqest Failed.")
            }
            self.tableView.footerView?.endRefreshing()
        }
    }
    
    func parseJSON(items: JSON) {
        if !items.isEmpty {
            for (_, item) in items {
                let title    = item["name"].stringValue
                let star     = item["stargazers_count"].intValue
                let detail   = item["description"].stringValue
                let url      = item["html_url"].stringValue
                let APIitem  = APIModel(title: title, detail: detail, url: url)
                APIitem.star = star
                trendOverall.append(APIitem)
            }
            self.page += 1 // Increase the page count
            self.tableView.reloadData()
        }
        
        SVProgressHUD.dismiss()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! DevCell
        let url = NSURL(string: cell.url!)
        let controller = segue.destinationViewController as! WebPageViewController
        controller.request = NSURLRequest(URL: url!)
        controller.hidesBottomBarWhenPushed = true
        controller.title = cell.title.text
    }
}

extension GitHubAPIController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if trendOverall.count > 0 {
            self.tableView.backgroundView = nil
            return 1
        } else {
            emptyTableViewPage(self.tableView, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendOverall.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DevCell
        let APIitem: APIModel = trendOverall[indexPath.row]
        cell.title.text = APIitem.title
        cell.detail.text = APIitem.detail
        cell.info.text = "Star: \(APIitem.star)"
        cell.url = APIitem.url
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath) as! DevCell
        if let _ = selectedCell.url {
            performSegueWithIdentifier("loadWeb", sender: selectedCell)
        }
    }
}


