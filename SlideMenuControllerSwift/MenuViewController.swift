//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case legislators = 0
    case bills
    case committee
    case favorite
    case about
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class MenuViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Legislators", "Bills", "Committee", "Favorite", "About"]
    
    var legislatorsViewController: UIViewController!
    var billsViewController: UITabBarController!
    var committeeViewController: UITabBarController!
    var favoriteViewController: UITabBarController!
    var aboutViewController: UIViewController!
    
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let billsViewController = storyboard.instantiateViewController(withIdentifier: "Bills") as! UITabBarController
        self.billsViewController = billsViewController
        
        let committeeViewController = storyboard.instantiateViewController(withIdentifier: "Committee") as! UITabBarController
        self.committeeViewController = committeeViewController
        
        let favoriteViewController = storyboard.instantiateViewController(withIdentifier: "Favorite") as! UITabBarController
        self.favoriteViewController = favoriteViewController
        
        let aboutViewController = storyboard.instantiateViewController(withIdentifier: "About") 
        self.aboutViewController = aboutViewController
        
        
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .legislators:
            self.slideMenuController()?.changeMainViewController(self.legislatorsViewController, close: true)
        case .bills:
            self.slideMenuController()?.changeMainViewController(self.billsViewController, close: true)
        case .committee:
            self.slideMenuController()?.changeMainViewController(self.committeeViewController, close: true)
        case .favorite:
            self.slideMenuController()?.changeMainViewController(self.favoriteViewController, close: true)
        case .about:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
        }
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legislators, .bills, .committee, .favorite,.about:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension MenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legislators, .bills, .committee, .favorite, .about:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
