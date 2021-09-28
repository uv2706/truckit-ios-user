//
//  AddImage.swift
//  PickUpUser
//
//  Created by hb on 13/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class AddImageCell: UICollectionViewCell {
    static let cellId = "AddImageCell"

    var btnAddTappedClouser: ((Int)->())?
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
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
    @IBAction func btnAddImageTapped(_ sender: UIButton) {
        if self.btnAddTappedClouser != nil {
            self.btnAddTappedClouser!(sender.tag)
        }
    }
}
