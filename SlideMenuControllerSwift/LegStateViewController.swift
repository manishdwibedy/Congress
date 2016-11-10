//
//  LegStateViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/6/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class LegStateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource  {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    var legislator_list = [[String:String]]()
    var filtered_list = [String:[[String:String]]]()
    var alphabets = [String]()
    var filteredAlphabets = [String]()
    var alphabetMapping = [String:[[String:String]]]()
    
    var selectedAlpha = 0
    var selectedIndex = 0
    
    @IBOutlet weak var stateFilter: UIPickerView!
    @IBOutlet weak var legislators: UITableView!
    
    var stateList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stateFilter.delegate = self
        self.stateFilter.dataSource = self
        
        let appearance = UITabBarItem.appearance()
        let attributes: [String: AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 20.0)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -12)
        
        if legislator_list.count == 0 {
            

            Alamofire.request("http://104.196.231.114:8080/legislators?per_page=all").responseJSON { response in
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    let results = swiftyJsonVar["results"]
                    self.stateList.append("All States")
                    
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
                            if !self.stateList.contains(state_name){
                                self.stateList.append(state_name)
                            }
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
                        
                        self.legislator_list.append(legislator)
                    }
                    SwiftSpinner.hide()
                    
                    for legislator in self.legislator_list{
                        let name:String = legislator["first_name"]!
                        let firstLetter: String = String(name.characters.first!)
                        if !self.alphabets.contains(firstLetter){
                            self.alphabets.append(firstLetter)
                            self.alphabetMapping[firstLetter] = [legislator]
                        }
                        else{
                            self.alphabetMapping[firstLetter]!.append(legislator)
                        }
                    }
                    
                    self.alphabets.sort(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending})
                        
                    self.legislator_list.sort(by: { $0["first_name"]?.localizedCaseInsensitiveCompare($1["first_name"]!) ==
                        ComparisonResult.orderedAscending })
                    self.filteredAlphabets = self.alphabets
                    self.filtered_list = self.alphabetMapping
                    self.legislators.reloadData()
                    self.stateFilter.reloadAllComponents()
                }
            }
        }
        self.legislators.tableFooterView = UIView()
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.legislator_list.count == 0{
            SwiftSpinner.show("Fetching data...")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.legislators.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let alphabet = indexPath.section
        let legislator = self.filtered_list[self.filteredAlphabets[alphabet]]?[indexPath.row]
        cell.textLabel?.text = (legislator?["first_name"]!)! + " " + (legislator?["last_name"]!)!
        cell.detailTextLabel?.text = legislator?["state_name"]
        
        let url = URL(string: "https://theunitedstates.io/images/congress/225x275/" + (legislator?["bioguide_id"]!)! + ".jpg")
        let data = try? Data(contentsOf: url!)

        cell.imageView?.image = UIImage(data: data!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        self.selectedAlpha = indexPath.section
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "show_legislator", sender: nil)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        return self.filteredAlphabets[section]
        
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.filtered_list[self.filteredAlphabets[section]]!.count
    }
    
    
    
    @available(iOS 2.0, *)
    public func numberOfSections(in tableView: UITableView) -> Int{
        return self.filteredAlphabets.count
        
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        return self.filteredAlphabets
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int{
        return self.filteredAlphabets.index(of: title)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "show_legislator" {
            let viewController:LegislatorDetailViewController = segue.destination as! LegislatorDetailViewController
            
            viewController.legislatorDetail = (self.filtered_list[self.filteredAlphabets[ self.selectedAlpha]]?[self.selectedIndex])!
        }
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.stateList.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.stateList[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        self.filterLegislatorsByState(state: self.stateList[row])
        self.stateFilter.isHidden = true
        self.legislators.isHidden = false
    }
    
    @IBAction func filterLegislators(_ sender: UIBarButtonItem) {
        self.stateFilter.isHidden = false
        self.legislators.isHidden = true
    }
    
    func filterLegislatorsByState(state: String){
        self.filtered_list = [:]
        self.filteredAlphabets = []
        
        for alphabet in self.alphabets{
            for legislator in self.alphabetMapping[alphabet]!{
                if legislator["state_name"] == state || state == "All States"{
                    let name:String = legislator["first_name"]!
                    let firstLetter: String = String(name.characters.first!)
                    if !self.filteredAlphabets.contains(firstLetter){
                        self.filteredAlphabets.append(firstLetter)
                        self.filtered_list[alphabet] = [legislator]
                    }
                    else{
                        self.filtered_list[alphabet]!.append(legislator)
                    }
                }
            }
        }
        self.legislators.reloadData()
        
    }
}
