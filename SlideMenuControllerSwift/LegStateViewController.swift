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
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")

    }
}
