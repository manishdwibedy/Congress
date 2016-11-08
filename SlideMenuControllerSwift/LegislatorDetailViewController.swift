//
//  LegislatorDetailViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/7/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit
import SwiftSpinner

class LegislatorDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var legislatorDetail = [String:String]()
    let titleValue = ["first_name"]
    @IBOutlet weak var legislatorDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "legislator_list", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "legislator_list" {
            SwiftSpinner.show("Testing")
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.legislatorDetails.dequeueReusableCell(withIdentifier: "cell")! as! LegislatorDetailViewCell
        cell.title.text = self.titleValue[indexPath.row]
        cell.value.text = self.legislatorDetail[self.titleValue[indexPath.row]]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
