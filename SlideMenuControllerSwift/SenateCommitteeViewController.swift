//
//  SenateCommitteeViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/6/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class SenateCommitteeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var committeeTable: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var committeeTabel: UITableView!
    
    var committee_list = [[String:String]]()
    var filtered_list = [[String:String]]()
    
    var selectedIndex = 0
    
    var search: UISearchBar!
    var searching = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.search = UISearchBar()
        search.delegate = self
        search.showsCancelButton = false
        search.sizeToFit()
        self.searchButton.image = UIImage(named: "search")!
        self.searchButton.title = ""
        
        let appearance = UITabBarItem.appearance()
        let attributes: [String: AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 20.0)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -12)
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.committee_list.count == 0 {
            SwiftSpinner.show("Fetching data...")
            
            Alamofire.request("http://localhost/congress.php?operation=committees").responseJSON { response in
                
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
                        
                        
                        
                        if subJson["chamber"] == "senate"{
                            self.committee_list.append(committee)
                        }
                    }
                    SwiftSpinner.hide()
                    self.committee_list.sort(by: { $0["first_name"]?.localizedCaseInsensitiveCompare($1["first_name"]!) == ComparisonResult.orderedAscending })
                    
                    self.filtered_list = self.committee_list
                    self.committeeTable.reloadData()
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
            self.committeeTable.reloadData()
            self.searchButton.image = UIImage(named: "search")!
            self.searchButton.title = ""
            self.searching = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.committeeTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let legislator = self.filtered_list[indexPath.row]
        cell.textLabel?.text = legislator["name"]!
        cell.detailTextLabel?.text = legislator["committee_id"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filtered_list = searchText.isEmpty ? self.committee_list : self.committee_list.filter({(dataString: [String:String]) -> Bool in
            return dataString["name"]?.range(of: searchText, options: .caseInsensitive) != nil
        })
        self.committeeTable.reloadData()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
    }
}

