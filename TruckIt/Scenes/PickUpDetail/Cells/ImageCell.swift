//
//  ImageCell.swift
//  PickUpUser
//
//  Created by hb on 17/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgView: UIImageView!
    static let cellId = "ImageCell"
    var buttonTapped: ((Int)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewBg.layer.cornerRadius = 5
        imgView.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewBg.layoutIfNeeded()
        self.viewBg.addCircularShadow(5.0)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if self.buttonTapped != nil {
            self.buttonTapped!(sender.tag)
        }
    }
}
