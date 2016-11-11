//
//  AboutViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/11/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, SlideMenuControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
}
