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

class CocoaPodViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var trendDaily = [APIModel]()
    var trendOverall = [APIModel]()
   
    var htmlPageTitle: String?
    var htmlPageLastUpdated: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CocoaPods"
        initViewList()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! APICell
        let url = NSURL(string: cell.url!)
        let controller = segue.destinationViewController as! WebPageViewController
        controller.request = NSURLRequest(URL: url!)
        controller.hidesBottomBarWhenPushed = true
        controller.title = cell.title.text
    }
    
    func initViewList() {
        tableView.registerNib(UINib(nibName: "APICell", bundle:nil), forCellReuseIdentifier: "cell")
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
    
    func refreshView() {
        
    }

}

extension CocoaPodViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! APICell
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
        return 80
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
        let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath) as! APICell
        if let _ = selectedCell.url {
            performSegueWithIdentifier("loadWeb", sender: selectedCell)
        }
    }
}

/*
extension CocoaPodViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return trendDaily.count
        case 1:
            return trendOverall.count
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! APICell
        
        let APIitem: APIModel
        switch indexPath.section {
        case 0:
            APIitem = trendDaily[indexPath.row]
        case 1:
            APIitem = trendOverall[indexPath.row]
        default:
            APIitem = APIModel(title: "nil", detail: "null", url: "undefined", star: 0)
        }
        cell.title.text = APIitem.title
        cell.detail.text = APIitem.detail
        cell.star.text = "Star: \(APIitem.star)"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected: \(indexPath.row)")
    }
}
*/


