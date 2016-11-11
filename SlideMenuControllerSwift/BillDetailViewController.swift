//
//  BillDetailViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/10/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var legislatorDetail = [String:String]()
    let titleValue = ["bill_id", "bill_type", "first_name", "last_action_at", "pdf", "chamber", "last_vote_at", "active"]
    
    let titleValues = ["bill_id": "Bill ID", "bill_type": "Bill Type", "first_name": "Sponsor", "last_action_at": "Last Action", "pdf": "PDF", "chamber": "Chamber", "last_vote_at" : "Last Vote", "active": "Status"]
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var billTable: UITableView!
    @IBOutlet weak var billTitle: UITextView!
    var tab = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.billTable.tableFooterView = UIView()
        
        let favorites = UserDefaults.standard.stringArray(forKey: "favorite_bill")
        if favorites != nil && (favorites?.contains(legislatorDetail["bill_id"]!))!{
            self.favoriteButton.image = UIImage(named: "star-filled")!
            self.favoriteButton.title = ""
        }
        else{
            self.favoriteButton.image = UIImage(named: "star")!
            self.favoriteButton.title = ""
        }
        
        billTitle.text = self.legislatorDetail["title"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.billTable.dequeueReusableCell(withIdentifier: "cell")! as! BillDetailViewCell
        
        cell.title.text = self.titleValues[self.titleValue[indexPath.row]]
        
        if self.titleValue[indexPath.row] == "pdf"{
            if let twitterID = legislatorDetail["pdf"]{
                let linkAttributes = [
                    NSLinkAttributeName: NSURL(string:  twitterID)!,
                    NSForegroundColorAttributeName: UIColor.blue,
                    NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)
                    ] as [String : Any]
                
                let attributedString = NSMutableAttributedString(string: "PDF Link")
                
                attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, 8))
                cell.value.attributedText = attributedString
            }
            else{
                cell.value.text = "N.A."
            }
        }
        else if self.titleValue[indexPath.row] == "last_action_at" || self.titleValue[indexPath.row] == "last_vote_at"{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = self.legislatorDetail[self.titleValue[indexPath.row]] {
                
                let date1 = dateFormatter.date(from: date)
                dateFormatter.dateFormat = "dd MMM yyyy"
                
                cell.value.text = dateFormatter.string(from: date1!)
            }
            else{
                cell.value.text = "N.A."
            }
            
        }
        else if self.titleValue[indexPath.row] == "first_name"{
            cell.value.text = self.legislatorDetail["sponsor_title"]! + " " + self.legislatorDetail["first_name"]! + " " + self.legislatorDetail["last_name"]!
        }
        else{
            cell.value.text = self.legislatorDetail[self.titleValue[indexPath.row]]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    @IBAction func favorite(_ sender: Any) {
        var favorite = UserDefaults.standard.stringArray(forKey: "favorite_bill")
        
        let id = self.legislatorDetail["bill_id"]!
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
            if let index = favorite?.index(of: legislatorDetail["bill_id"]!) {
                favorite?.remove(at: index)
            }
        }
        
        
        UserDefaults.standard.set(favorite, forKey: "favorite_bill")
    }

}
