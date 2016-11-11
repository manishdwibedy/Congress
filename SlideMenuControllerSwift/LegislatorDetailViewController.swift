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
    
    var tab = 0
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var legislatorDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.legislatorDetails.tableFooterView = UIView()
        
        let favorites = UserDefaults.standard.stringArray(forKey: "favorite_legislator")
        if (favorites?.contains(legislatorDetail["bioguide_id"]!))!{
            self.favoriteButton.image = UIImage(named: "star-filled")!
            self.favoriteButton.title = ""
        }
        else{
            self.favoriteButton.image = UIImage(named: "star")!
            self.favoriteButton.title = ""
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        if self.tab < 4{
            self.performSegue(withIdentifier: "legislator_list", sender: nil)
        }
        else if self.tab == 4{
            self.performSegue(withIdentifier: "fav_leg", sender: nil)
        }
        
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
        else if self.titleValue[indexPath.row] == "birthday" || self.titleValue[indexPath.row] == "term_end"{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: self.legislatorDetail[self.titleValue[indexPath.row]]!)
            dateFormatter.dateFormat = "dd MMM yyyy"

            cell.value.text = dateFormatter.string(from: date!)
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
            if let index = favorite?.index(of: legislatorDetail["bioguide_id"]!) {
                favorite?.remove(at: index)
            }
        }
        
        
        UserDefaults.standard.set(favorite, forKey: "favorite_legislator")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "legislator_list" {
            let viewController:LegislatorViewController = segue.destination as! LegislatorViewController
            
            viewController.tab = self.tab
        }
        else if segue.identifier == "fav_leg"{
            //let viewController = segue.destination as! FavoriteLegislatorViewController
        }
    }
}
