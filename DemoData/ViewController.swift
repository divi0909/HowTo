//
//  ViewController.swift
//  DemoData
//
//  Created by Octal on 24/10/16.
//  Copyright © 2016 Octal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var lblTitle:UILabel!
    
    @IBOutlet weak var lblContent:UILabel!
    
    @IBOutlet weak var viewData:UIView!
    
    var arrSearchResult:Array = [String]()
    
    var arrLinkResult:Array = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: TABLEVIEW METHOD
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrSearchResult.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = arrSearchResult[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tblView.isHidden = true
        
        
        do
        {
            let data = try Data.init(contentsOf: URL.init(string: arrLinkResult[indexPath.row])!)
            
            let hpple:TFHpple = TFHpple.init(htmlData: data)
            
            let queryTitle = "//title"
            
            let querySteps = "//b[@class='whb']"
            
            let arrTitle = hpple.search(withXPathQuery: queryTitle)
            
            let arrSteps = hpple.search(withXPathQuery: querySteps)
            
            if arrTitle!.count > 0
            {
                
                let hppleEle:TFHppleElement = arrTitle![0] as! TFHppleElement
                
                lblTitle?.text = hppleEle.content
                
            }
            
            if arrSteps!.count > 0
            {
                var strSteps:String = ""
                
                for ele in arrSteps!
                {
                    
                    let hppleEle:TFHppleElement = ele as! TFHppleElement
                    
                    strSteps.append("\(hppleEle.content!)\n")
                    
                }
                
                lblContent?.text = strSteps
                
            }
            
            viewData.isHidden = false
            
        }
        catch
        {
            print(error)
        }

        
    }
    
    
    //MARK: SHOW DATA
    
    func showData(element:TFHppleElement)
    {
        
        lblContent?.text = element.content
    }
    
    //MARK: SEARCH DATA
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        arrSearchResult.removeAll()
        arrLinkResult.removeAll()
        
        viewData.isHidden = true
        
        do
        {
            let data = try Data.init(contentsOf: URL.init(string: "http://www.wikihow.com/wikiHowTo?search=\(searchText)")!)
            
            let hpple:TFHpple = TFHpple.init(htmlData: data)
            
            let arrQuery = ["//a[@class='result_link']"]
            
            for strQuery in arrQuery
            {
                let arrElement = hpple.search(withXPathQuery: strQuery)
                
                if arrElement!.count > 0
                {
                    
                    for element in arrElement!
                    {
                        let hppleEle:TFHppleElement = element as! TFHppleElement
                        
                        let link = hppleEle.attributes["href"] as Any as! String
                        
                        
                        arrLinkResult.append(link.replacingOccurrences(of: "//", with: "http://"))
                        
                        arrSearchResult.append(hppleEle.content)
                    }
                    
                    tblView.isHidden = false
                    
                    self.view.bringSubview(toFront: tblView)
                    
                    tblView?.reloadData()
                    
                }
                else
                {
                    tblView?.isHidden = true
                }
            }
            
        }
        catch
        {
            print(error)
        }
        
    }

}

