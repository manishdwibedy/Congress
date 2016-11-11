//
//  FavoriteBillViewControllwe.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/6/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class FavoriteBillViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var billTable: UITableView!
    var legislator_list = [[String:String]]()
    var filtered_list = [[String:String]]()
    var searching = true
    var search = UISearchBar()
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
        self.billTable.tableFooterView = UIView()
    }
    
    
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let favorite = UserDefaults.standard.stringArray(forKey: "favorite_bill")
        
        if self.legislator_list.count == 0 && favorite != nil && (favorite?.count)! > 0 {
            SwiftSpinner.show("Fetching data...")
            
            Alamofire.request("http://localhost/congress.php?operation=bills").responseJSON { response in
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    let results = swiftyJsonVar["results"]
                    
                    for (_, subJson) in results {
                        var committee = [String:String]()
                        if let title = subJson["official_title"].string {
                            committee["title"] = title
                        }
                        
                        if let bill_id = subJson["bill_id"].string {
                            committee["bill_id"] = bill_id
                        }
                        
                        if let bill_type = subJson["bill_type"].string {
                            committee["bill_type"] = bill_type
                        }
                        if let first_name = subJson["sponsor"]["first_name"].string {
                            committee["first_name"] = first_name
                        }
                        if let last_name = subJson["sponsor"]["last_name"].string {
                            committee["last_name"] = last_name
                        }
                        if let sponsor_title = subJson["sponsor"]["title"].string {
                            committee["sponsor_title"] = sponsor_title
                        }
                        
                        if let last_action_at = subJson["last_action_at"].string {
                            committee["last_action_at"] = last_action_at
                        }
                        
                        if let chamber = subJson["chamber"].string {
                            committee["chamber"] = chamber
                        }
                        
                        
                        if let pdf = subJson["last_version"]["urls"]["pdf"].string {
                            committee["pdf"] = pdf
                        }
                        
                        if let last_vote_at = subJson["last_vote_at"].string {
                            committee["last_vote_at"] = last_vote_at
                        }
                        
                        if (favorite?.contains(subJson["bill_id"].string!))!{
                            self.legislator_list.append(committee)
                        }
                    }
                    SwiftSpinner.hide()
                    self.legislator_list.sort(by: { $0["title"]?.localizedCaseInsensitiveCompare($1["title"]!) == ComparisonResult.orderedAscending })
                    
                    self.filtered_list = self.legislator_list
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
            self.filtered_list = self.legislator_list
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
        let cell = self.billTable.dequeueReusableCell(withIdentifier: "cell")! as! FavoriteBillViewCell
        
        let legislator = self.filtered_list[indexPath.row]
        cell.value.text = legislator["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected_index = indexPath.row
        self.performSegue(withIdentifier: "fav_bill_detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fav_bill_detail" {
            let viewController = segue.destination as! BillDetailViewController
            
            viewController.legislatorDetail = (self.legislator_list[self.selected_index])
            viewController.tab = 4
        }
    }

}

