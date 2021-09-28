//
//  Tip.swift
//  TruckIt
//
//  Created by hb on 30/12/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class TipCell: UICollectionViewCell {
    
    static let cellId = "TipCell"
    @IBOutlet weak var btnTip: UIButton!
    var btnTap: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnTip.layer.borderWidth = 1
        self.btnTip.layer.cornerRadius = 5
    }
    
    @IBAction func btnTipAction(_ sender: UIButton) {
        if self.btnTap != nil {
            self.btnTap!()
        }
    }
    
}
