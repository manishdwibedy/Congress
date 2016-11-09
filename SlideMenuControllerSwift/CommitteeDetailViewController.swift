//
//  CommitteeDetailViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/8/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class CommitteeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var committeeDetailTable: UITableView!
    
    @IBOutlet weak var name: UITextView!
    let titleValue = ["committee_id", "parent_committee_id", "chamber", "office", "phone"]
    
    let titleValues = ["committee_id": "ID", "parent_committee_id": "Parent ID", "chamber": "Chamber", "office": "Office", "phone": "Contact"]
    
    var committeeDetail = [String:String]()
    var tab = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = committeeDetail["name"]
        self.committeeDetailTable.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.committeeDetailTable.dequeueReusableCell(withIdentifier: "cell")! as! CommitteeViewCell
        
        cell.label.text = self.titleValues[self.titleValue[indexPath.row]]
        if self.titleValue[indexPath.row] == "office"{
            if let office = self.committeeDetail[self.titleValue[indexPath.row]]{
                cell.value.text = office
            }
            else{
                cell.value.text = "N.A."
            }
        }
        else if self.titleValue[indexPath.row] == "phone"{
            if let phone = self.committeeDetail[self.titleValue[indexPath.row]]{
                cell.value.text = phone
            }
            else{
                cell.value.text = "N.A."
            }
        }
        else if self.titleValue[indexPath.row] == "parent_committee_id"{
            if let parent_committee_id = self.committeeDetail[self.titleValue[indexPath.row]]{
                cell.value.text = parent_committee_id
            }
            else{
                cell.value.text = "N.A."
            }
        }
        else{
            cell.value.text = self.committeeDetail[self.titleValue[indexPath.row]]
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "committee_list" {
            let viewController:CommitteeViewController = segue.destination as! CommitteeViewController
            
            viewController.tab = self.tab
        }
    }

}
