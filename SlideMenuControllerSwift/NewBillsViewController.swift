//
//  NewBillsViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/6/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//


import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class NewBillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var billTable: UITableView!
    
    var committee_list = [[String:String]]()
    var filtered_list = [[String:String]]()
    var selectedIndex = 0
    var search: UISearchBar!
    var searching = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.committee_list.count == 0 {
            SwiftSpinner.show("Fetching data...")
            
            Alamofire.request("http://104.196.231.114:8080/committees?per_page=all").responseJSON { response in
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    let results = swiftyJsonVar["results"]
                    
                    for (_, subJson) in results {
                        var committee = [String:String]()
                        if let chamber = subJson["chamber"].string {
                            committee["chamber"] = chamber
                        }
                        
                        if let committee_id = subJson["committee_id"].string {
                            committee["committee_id"] = committee_id
                        }
                        
                        if let name = subJson["name"].string {
                            committee["name"] = name
                        }
                        
                        if let parent_committee_id = subJson["parent_committee_id"].string {
                            committee["parent_committee_id"] = parent_committee_id
                        }
                        
                        if let office = subJson["office"].string {
                            committee["office"] = office
                        }
                        
                        if let phone = subJson["phone"].string {
                            committee["phone"] = phone
                        }
                        
                        if subJson["chamber"] == "house"{
                            self.committee_list.append(committee)
                        }
                    }
                    SwiftSpinner.hide()
                    self.committee_list.sort(by: { $0["name"]?.localizedCaseInsensitiveCompare($1["name"]!) == ComparisonResult.orderedAscending })
                    
                    self.filtered_list = self.committee_list
                    self.billTable.reloadData()
                }
            }
        }
    }
    @IBAction func search(_ sender: UIBarButtonItem) {
        navigationBar.topItem?.titleView = self.search
        if self.searching{
            self.searchButton.image = UIImage(named: "cancel")!
            self.searchButton.title = ""
            self.searching = false
        }
        else{
            self.search.text = ""
            navigationBar.topItem?.titleView = nil
            self.filtered_list = self.committee_list
            self.billTable.reloadData()
            self.searchButton.image = UIImage(named: "search")!
            self.searchButton.title = ""
            self.searching = true
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.billTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let legislator = self.filtered_list[indexPath.row]
        cell.textLabel?.text = legislator["name"]!
        cell.detailTextLabel?.text = legislator["committee_id"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "house_committee_detail", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filtered_list = searchText.isEmpty ? self.committee_list : self.committee_list.filter({(dataString: [String:String]) -> Bool in
            return dataString["name"]?.range(of: searchText, options: .caseInsensitive) != nil
        })
        self.billTable.reloadData()
    }
}
