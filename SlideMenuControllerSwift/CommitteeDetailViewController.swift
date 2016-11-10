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
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var committeeDetail = [String:String]()
    var tab = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = committeeDetail["name"]
        self.committeeDetailTable.tableFooterView = UIView()

        // Do any additional setup after loading the view.
        let favorites = UserDefaults.standard.stringArray(forKey: "favorite_committee")
        if ((favorites != nil) && (favorites?.contains(committeeDetail["committee_id"]!))!){
            self.favoriteButton.image = UIImage(named: "star-filled")!
            self.favoriteButton.title = ""
        }
        else{
            self.favoriteButton.image = UIImage(named: "star")!
            self.favoriteButton.title = ""
        }
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
    
    
    @IBAction func favorite(_ sender: UIBarButtonItem) {
        var favorite = UserDefaults.standard.stringArray(forKey: "favorite_committee")
        
        let id = self.committeeDetail["committee_id"]!
        if favorite == nil{
            favorite = [id]
            self.favoriteButton.image = UIImage(named: "star-filled")!
            self.favoriteButton.title = ""
        }
        else if !(favorite?.contains(id))!{
            favorite?.append(id)
            self.favoriteButton.image = UIImage(named: "star-filled")!
            self.favoriteButton.title = ""
            
        }
        else{
            self.favoriteButton.image = UIImage(named: "star")!
            self.favoriteButton.title = ""
            if let index = favorite?.index(of: committeeDetail["committee_id"]!) {
                favorite?.remove(at: index)
            }
        }
        
        
        UserDefaults.standard.set(favorite, forKey: "favorite_committee")

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "committee_list" {
            let viewController:CommitteeViewController = segue.destination as! CommitteeViewController
            
            viewController.tab = self.tab
        }
    }

}
