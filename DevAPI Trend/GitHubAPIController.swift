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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewList()
    }
    
    func initViewList() {
        tableView.registerNib(UINib(nibName: "DevCell", bundle:nil), forCellReuseIdentifier: "cell")
        fetchJSON()
    }
    
    func fetchJSON() {
        
        // A closure that tackles the problem of default encoding ("+" and ">") provided by Alamofire,
        // unfortunately GitHub search API does not like it, therefore customization is provided.
        let custom: (URLRequestConvertible, parameters: [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) = { req, param in
            let request = req.URLRequest.mutableCopy() as! NSMutableURLRequest
            let baseURL = (request.URL?.absoluteString)!
            var reqString = baseURL + "?" + self.generateQuery(param as! [String: String])
            let charSet = NSCharacterSet.URLQueryAllowedCharacterSet()
            reqString = reqString.stringByAddingPercentEncodingWithAllowedCharacters(charSet)!
            let URL = NSURL(string: reqString)
            request.URL = URL
            return (request, nil)
        }
        
        let param: [String: String] = ["q": query, "sort": "stars", "order": "desc", "page": String(page)]

        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: param, encoding: .Custom(custom)).responseJSON { res in
            
            switch res.result {
            case .Success(let value):
                let json = JSON(value)
                let items = json["items"]
                self.parseJSON(items)
            case .Failure:
                print("No Internet Connection Error: DX21")
            }
        }
    }
    
    func parseJSON(items: JSON) {

        for (_, item) in items {
            let title   = item["name"].stringValue
            let star   = item["stargazers_count"].intValue
            let detail = item["description"].stringValue
            let url    = item["url"].stringValue
            let APIitem = APIModel(title: title, detail: detail, url: url)
            APIitem.star = star
            trendOverall.append(APIitem)
        }
        // Increase the page count
        self.tableView.reloadData()
    }
    
    func generateQuery(dict: [String:String]) -> String {
        let query   = dict["q"]!
        let sortVar = dict["sort"]!
        let order   = dict["order"]!
        let page    = dict["page"]!
        return "q=\(query)&sort=\(sortVar)&order=\(order)&page=\(page)"
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
        return 1
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


