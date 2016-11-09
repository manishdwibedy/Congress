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
    let titleValue = ["first_name", "last_name", "state_name", "birthday", "gender", "chamber", "fax", "twitter_id", "website", "office", "term_end"]
    
    let titleValues = ["first_name": "First Name", "last_name": "Last Name", "state_name": "State", "birthday": "Birth date", "gender": "Gender", "chamber": "Chamber", "fax" : "Fax No.", "twitter_id": "Twitter", "website": "Website", "office": "Office No.", "term_end": "Term ends on"]
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var legislatorDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "legislator_list", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let url = URL(string: "https://theunitedstates.io/images/congress/225x275/" + legislatorDetail["bioguide_id"]! + ".jpg")
        let data = try? Data(contentsOf: url!)
        
        image.image = UIImage(data: data!)

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
        
        cell.title.text = self.titleValues[self.titleValue[indexPath.row]]
        if self.titleValue[indexPath.row] == "twitter_id"{
            if let twitterID = legislatorDetail["twitter_id"]{
                let linkAttributes = [
                    NSLinkAttributeName: NSURL(string: "http://twitter.com/" + twitterID)!,
                    NSForegroundColorAttributeName: UIColor.blue,
                    NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)
                    ] as [String : Any]
                
                let attributedString = NSMutableAttributedString(string: "Twitter Link")
                
                attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, 12))
                cell.value.attributedText = attributedString
            }
            else{
                cell.value.text = "N.A."
            }
            
        }
        else if self.titleValue[indexPath.row] == "website"{
            let linkAttributes = [
                NSLinkAttributeName: NSURL(string: self.legislatorDetail[self.titleValue[indexPath.row]]!)!,
                NSForegroundColorAttributeName: UIColor.blue,
                NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)
                ] as [String : Any]
            
            let attributedString = NSMutableAttributedString(string: "Website Link")
            
            attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, 12))
            cell.value.attributedText = attributedString
        }
        else{
            cell.value.text = self.legislatorDetail[self.titleValue[indexPath.row]]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func favorite(_ sender: UIBarButtonItem) {
        var favorite = UserDefaults.standard.stringArray(forKey: "favorite_legislator")
        
        let id = self.legislatorDetail["bioguide_id"]!
        if favorite == nil{
            favorite = [id]
        }
        else if !(favorite?.contains(id))!{
            favorite?.append(id)
        }
        
        
        UserDefaults.standard.set(favorite, forKey: "favorite_legislator")
    }
}
