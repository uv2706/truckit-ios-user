//
//  ViewImageCell.swift
//  PickUpUser
//
//  Created by hb on 13/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class ViewImageCell: UICollectionViewCell {
    static let cellId = "ViewImageCell"
    
    var btnRemoveTappedClouser: ((Int)->())?
    
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBG.layer.cornerRadius = 5
        imgView.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.viewBG.layoutIfNeeded()
        self.viewBG.addCircularShadow(5.0)
        self.imgView.layoutIfNeeded()
        self.imgView.roundCorners(corners: [.topLeft,.topRight,.bottomLeft, .bottomRight], radius: 5)
        // self.viewBg.addViewShadowAtPosition(position: .full)
        
    }
    
    @IBAction func btnRemoveTapped(_ sender: UIButton) {
        if self.btnRemoveTappedClouser != nil {
            self.btnRemoveTappedClouser!(sender.tag)
        }
    }
    
}
