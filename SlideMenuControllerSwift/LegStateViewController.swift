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

class LegStateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var legislator_list = [[String:String]]()
    
    @IBOutlet weak var legislators: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

                    //party
                    self.legislator_list.append(legislator)
                }
                self.legislators.reloadData()
            }
        }
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.legislator_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.legislators.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let legislator = self.legislator_list[indexPath.row]
        cell.textLabel?.text = legislator["first_name"]! + " " + legislator["last_name"]!
        cell.detailTextLabel?.text = legislator["state_name"]
        
        let url = URL(string: "https://theunitedstates.io/images/congress/225x275/" + legislator["bioguide_id"]! + ".jpg")
        let data = try? Data(contentsOf: url!)

        cell.imageView?.image = UIImage(data: data!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}
