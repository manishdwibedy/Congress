//
//  FavoriteLegislatorViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/6/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FavoriteLegislatorViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var legislator_list = [[String:String]]()
    var filtered_list = [[String:String]]()
    @IBOutlet weak var legislatorTable: UITableView!
    var search = UISearchBar()
    @IBOutlet weak var navigationBar: UINavigationBar!
    var searching = true
    var selected_index = 0
    
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
        self.legislatorTable.tableFooterView = UIView()
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let favorite = UserDefaults.standard.stringArray(forKey: "favorite_legislator")
        
        if (favorite?.count)! > 0 {
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
                        if (favorite?.contains(subJson["bioguide_id"].string!))!{
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
        self.selected_index = indexPath.row
        self.performSegue(withIdentifier: "fav_leg_detail", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fav_leg_detail" {
            let viewController:LegislatorDetailViewController = segue.destination as! LegislatorDetailViewController
            
            viewController.legislatorDetail = (self.legislator_list[self.selected_index])
            viewController.tab = 4
        }
    }
    
}
