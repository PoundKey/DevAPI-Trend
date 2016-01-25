//
//  CocoaPodViewController.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-19.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import SVProgressHUD

class CocoaPodViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var trendDaily = [APIModel]()
    var trendOverall = [APIModel]()
    
    var htmlPageTitle: String?
    var htmlPageLastUpdated: String?
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshView:", forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CocoaPods"
        initViewList()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! DevCell
        let url = NSURL(string: cell.url!)
        let controller = segue.destinationViewController as! WebPageViewController
        controller.request = NSURLRequest(URL: url!)
        controller.hidesBottomBarWhenPushed = true
        controller.title = cell.title.text
    }
    
    func initViewList() {
        self.tableView.registerNib(UINib(nibName: "DevCell", bundle:nil), forCellReuseIdentifier: "cell")
        self.tableView.addSubview(self.refreshControl)
        SVProgressHUD.show()
        fetchHTML()
    }
    
    func fetchHTML() {
        let url = "https://trendingcocoapods.github.io"
        Alamofire.request(.GET, url).responseString { res in
            switch res.result {
            case .Success(let value):
                self.parseHTML(value)
            case .Failure:
                print("No Internet Connection Error: DX21")
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func parseHTML(html: String) {
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            setHtmlPageMeta(doc)
            for (index, table) in doc.css("tbody").enumerate() {
                switch index {
                case 0:
                    setTrendList(&trendDaily, table: table)
                case 1:
                    setTrendList(&trendOverall, table: table)
                default:
                    break
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func setHtmlPageMeta(doc: HTMLDocument) {
        if let title = doc.title, updatedTime = doc.at_css("body > div > p:nth-child(3)")?.text {
            self.htmlPageTitle = title
            self.htmlPageLastUpdated = updatedTime
        }
    }
    
    func setTrendList(inout trend: [APIModel], table: XMLElement) {
        for row in table.css("tr") {
            let info = row.css("td")
            if info.count == 4, let title = info[1].text,
                let star = info[2].text, let detail = info[3].text {
                    // Gather the Github Link for the CocoaPod.
                    if let anchor = info[1].at_css("a"), link = anchor["href"] {
                        let APIitem = APIModel(title: title, detail: detail, url: link)
                        APIitem.star = Int(star)!
                        trend.append(APIitem)
                    }
            }
        }
    }
    
    func reloadHTML() {
        let url = "https://trendingcocoapods.github.io"
        Alamofire.request(.GET, url).responseString { res in
            switch res.result {
            case .Success(let value):
                self.trendOverall.removeAll()
                self.trendDaily.removeAll()
                self.parseHTML(value)
                lastUpdatedFormatter(self.refreshControl)
                SVProgressHUD.showSuccessWithStatus("Reloaded!")
            case .Failure:
                SVProgressHUD.showErrorWithStatus("Reuqest Failed.")
                print("No Internet Connection Error: DX21")
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func refreshView(refreshControl: UIRefreshControl) {
        reloadHTML()
    }
    
}

extension CocoaPodViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if trendOverall.count > 0 {
            self.tableView.backgroundView = nil
            return 2
        } else {
            emptyTableViewPage(self.tableView, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return trendDaily.count
        case 1:
            return trendOverall.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DevCell
        let APIitem: APIModel
        switch indexPath.section {
        case 0:
            APIitem = trendDaily[indexPath.row]
        case 1:
            APIitem = trendOverall[indexPath.row]
        default:
            APIitem = APIModel(title: "nil", detail: "null", url: "undefined")
        }
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
        return 30
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let updated = htmlPageLastUpdated {
            return updated
        }
        return nil
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title: String
        switch section {
        case 0:
            title = "Daily Trend"
        case 1:
            title = "Overall Trend"
        default:
            title = ""
        }
        return title
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath) as! DevCell
        if let _ = selectedCell.url {
            performSegueWithIdentifier("loadWeb", sender: selectedCell)
        }
    }
}


