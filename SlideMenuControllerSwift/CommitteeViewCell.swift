//
//  CommitteeViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Manish Dwibedy on 11/8/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class CommitteeViewCell: UITableViewCell {

    @IBOutlet weak var value: UILabel!
    
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
