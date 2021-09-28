//
//  SideMenuCell.swift
//  AtlasGPS
//
//  Created by hb on 22/04/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var viewIndicator: UIView!
    
    var btnTapped:((Int)->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func btnTitleTapped(_ sender: UIButton) {
        if self.btnTapped != nil {
            self.btnTapped!(sender.tag)
        }
    }
    
}
