//
//  LegHouseViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/6/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class LegHouseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var legislator_list = [[String:String]]()
    var filtered_list = [[String:String]]()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var selectedIndex = 0
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var search: UISearchBar!
    var searching = true
    
    @IBOutlet weak var legislatorTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.search = UISearchBar()
        search.delegate = self
        search.showsCancelButton = false
        search.sizeToFit()
        self.searchButton.image = UIImage(named: "search")!
        self.searchButton.title = ""
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if legislator_list.count == 0 {
            SwiftSpinner.show("Fetching data...")
            
            Alamofire.request("http://localhost/congress.php?operation=legislators").responseJSON { response in
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    let results = swiftyJsonVar["results"]
                    
                    for (_, subJson) in results {
                        var legislator = [String:String]()
                        if let first_name = subJson["first_name"].string {
                            legislator["first_name"] = first_name
                        }
                        
                        if let last_name = subJson["last_name"].string {
                            legislator["last_name"] = last_name
                        }
                        
                        if let state_name = subJson["state_name"].string {
                            legislator["state_name"] = state_name
                        }
                        
                        if let bioguide_id = subJson["bioguide_id"].string {
                            legislator["bioguide_id"] = bioguide_id
                        }
                        
                        if let birthday = subJson["birthday"].string {
                            legislator["birthday"] = birthday
                        }
                        
                        if let gender = subJson["gender"].string {
                            legislator["gender"] = gender
                        }
                        
                        if let chamber = subJson["chamber"].string {
                            legislator["chamber"] = chamber
                        }
                        
                        if let fax = subJson["fax"].string {
                            legislator["fax"] = fax
                        }
                        
                        if let twitter_id = subJson["twitter_id"].string {
                            legislator["twitter_id"] = twitter_id
                        }
                        
                        if let website = subJson["website"].string {
                            legislator["website"] = website
                        }
                        
                        if let office = subJson["office"].string {
                            legislator["office"] = office
                        }
                        
                        if let term_end = subJson["term_end"].string {
                            legislator["term_end"] = term_end
                        }
                        
                        if let term_start = subJson["term_start"].string {
                            legislator["term_start"] = term_start
                        }
                        
                        if let party = subJson["party"].string {
                            legislator["party"] = party
                        }
                        if subJson["chamber"] == "house"{
                            self.legislator_list.append(legislator)
                        }
                    }
                    SwiftSpinner.hide()
                    self.legislator_list.sort(by: { $0["first_name"]?.localizedCaseInsensitiveCompare($1["first_name"]!) == ComparisonResult.orderedAscending })
                    
                    self.filtered_list = self.legislator_list
                    self.legislatorTable.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.legislatorTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let legislator = self.filtered_list[indexPath.row]
        cell.textLabel?.text = legislator["first_name"]! + " " + legislator["last_name"]!
        cell.detailTextLabel?.text = legislator["state_name"]
        
        let url = URL(string: "https://theunitedstates.io/images/congress/225x275/" + legislator["bioguide_id"]! + ".jpg")
        let data = try? Data(contentsOf: url!)
        
        cell.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "show_legislator_house", sender: nil)
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
            self.filtered_list = self.legislator_list
            self.legislatorTable.reloadData()
            self.searchButton.image = UIImage(named: "search")!
            self.searchButton.title = ""
            self.searching = true
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filtered_list = searchText.isEmpty ? self.legislator_list : self.legislator_list.filter({(dataString: [String:String]) -> Bool in
            return dataString["first_name"]?.range(of: searchText, options: .caseInsensitive) != nil
        })
        self.legislatorTable.reloadData()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "show_legislator_house" {
            let viewController:LegislatorDetailViewController = segue.destination as! LegislatorDetailViewController
            
            viewController.legislatorDetail = (self.legislator_list[self.selectedIndex])
        }
    }
}
