//
//  NpmViewController.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-19.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class NpmViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var trendOverall = [APIModel]()

    let homePage = "https://www.npmjs.com/browse/star"
    var htmlPageTitle: String?
    var htmlPageNext: String?
    
    /**
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshView:", forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    tableView.addSubview(self.refreshControl)
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Node Packages"
        initViewList()
    }
    
    func initViewList() {
        tableView.registerNib(UINib(nibName: "DevCell", bundle:nil), forCellReuseIdentifier: "cell")
        
        self.tableView.headerView = createHeaderRefreshControl(self, action: "refreshView")
        self.tableView.footerView = createFooterRefreshControl(self, action: "loadNextPage")
        SVProgressHUD.show()
        fetchHTML(homePage)
    }
    
    func fetchHTML(url: String) {
        
        Alamofire.request(.GET, url).responseString { res in
            switch res.result {
            case .Success(let value):
                self.parseHTML(value)
            case .Failure:
                SVProgressHUD.showErrorWithStatus("Reuqest Failed.")
            }
            self.tableView.footerView?.endRefreshing()
        }
    }
    
    func parseHTML(html: String) {
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            let baseUrl = "https://www.npmjs.com"
            for node in 2...13 {
                for i in 1...3 {
                    let selectors = getNodeSelectors(node, child: i)
                    if let title = doc.css(selectors[0]).text,
                        detail = doc.css(selectors[1]).text,
                        version = doc.css(selectors[2]).text {
                            let package = (doc.css(selectors[0])[0]["href"])!
                            let url = baseUrl + package
                            let APIitem = APIModel(title: title, detail: detail, url: url)
                            APIitem.version = version
                            trendOverall.append(APIitem)
                    }
                }
            }

            if let nextPage = doc.at_css("body > div.container.content > div > a.next"),
                link = nextPage["href"] {
                    htmlPageNext = baseUrl + link
            }
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
        }
    }
    
    func getNodeSelectors(node: Int, child: Int) -> [String] {
        let base    = "body > div.container.content > ul:nth-child(\(node)) > li:nth-child(\(child)) > div > div > "
        let title   = "\(base)h3 > a"
        let detail  = "\(base)p.description"
        let version = "\(base)p.author.quiet > a.version"
        return [title, detail, version]
    }
    
    func reloadHTML() {
        Alamofire.request(.GET, homePage).responseString { res in
            switch res.result {
            case .Success(let value):
                self.trendOverall.removeAll()
                self.parseHTML(value)
            case .Failure:
                SVProgressHUD.showErrorWithStatus("Reuqest Failed.")
            }
            self.tableView.headerView?.endRefreshing()
        }
    }
    
    func loadNextPage() {
        if let next = htmlPageNext {
            fetchHTML(next)
        } else {
            self.tableView.footerView?.endRefreshing()
        }
    }
    
    func refreshView() {
        reloadHTML()
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

extension NpmViewController: UITableViewDataSource, UITableViewDelegate {
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
        cell.info.text = "Version: \(APIitem.version)"
        cell.url = APIitem.url
        return cell
    }
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Most Starred Packages"
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath) as! DevCell
        if let _ = selectedCell.url {
            performSegueWithIdentifier("loadWeb", sender: selectedCell)
        }
    }
}
