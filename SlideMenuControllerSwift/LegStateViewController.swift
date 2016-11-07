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

class LegStateViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://localhost/congress.php?operation=legislators").responseJSON { response in
            
            if((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                print("Teting")
                let results = swiftyJsonVar["results"]
                
                var legislators = [[String:String]]()
                for (_, subJson) in results {
                    var legislator = [String:String]()
                    if let first_name = subJson["first_name"].string {
                        legislator["first_name"] = first_name
                    }
                    
                    if let last_name = subJson["last_name"].string {
                        legislator["last_name"] = last_name
                    }
                    legislators.append(legislator)
                }
            }
        }
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
