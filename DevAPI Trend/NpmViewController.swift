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
    
    var responseString: String?
    var htmlPageTitle: String?
    var htmlPageNext: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewList()
    }
    
    func initViewList() {
        tableView.registerNib(UINib(nibName: "APICell", bundle:nil), forCellReuseIdentifier: "cell")
        let baseUrl = "https://www.npmjs.com/browse/star"
        fetchHTML(baseUrl)
    }
    
    func fetchHTML(url: String) {
        
        Alamofire.request(.GET, url).responseString { res in
            switch res.result {
            case .Success(let value):
                //print("Successful in retrieving html page")
                self.responseString = value
                self.parseHTML()
            case .Failure:
                print("No Internet Connection Error: DX21")
            }
        }
    }
    
    func parseHTML() {
        if let html = responseString, doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            for node in 2...13 {
                for i in 1...3 {
                    let selectors = getNodeSelectors(node, child: i)
                    if let title = doc.css(selectors[0]).text,
                        detail = doc.css(selectors[1]).text,
                        version = doc.css(selectors[2]).text {
                        print("Title: \(title), Detail:\(detail) => Version: \(version)")
                    }
                }
            }
        }
    }
    
    func getNodeSelectors(node: Int, child: Int) -> [String] {
        let base    = "body > div.container.content > ul:nth-child(\(node)) > li:nth-child(\(child)) > div > div > "
        let title   = "\(base)h3 > a"
        let detail  = "\(base)p.description"
        let version = "\(base)p.author.quiet > a.version"
        return [title, detail, version]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension NpmViewController {
    
}