//
//  PaymentCardCell.swift
//  ForgetMeKnots
//
//  Created by hb on 24/05/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import Stripe
import RevealingTableViewCell

class PaymentCardCell: RevealingTableViewCell {

    @IBOutlet weak var viewRedBg: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblCardnumber: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var imgCardIcon: UIImageView!
    
    var buttonDeleteClicked: ((Int)->())?
    
    static let celllId = "PaymentCardCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        btnDelete.setImage(#imageLiteral(resourceName: "delete_setting_s_h").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State())
        btnDelete.tintColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.imgCardIcon.layoutIfNeeded()
        self.imgCardIcon.roundCorners(corners: [.topLeft,.topRight, .bottomRight, .bottomLeft], radius: 5)
        self.viewRedBg.layoutIfNeeded()
        self.viewRedBg.roundCorners(corners: [.topRight,.bottomRight], radius: 10)
        // self.viewBg.addViewShadowAtPosition(position: .full)
        
    }
    func setData(data: PaymentCardListing.ViewModel) {
        let aDict = ["Visa":#imageLiteral(resourceName: "img_visa"),"American Express":#imageLiteral(resourceName: "img_americanexp"),"MasterCard":#imageLiteral(resourceName: "img_mastrcrd")]
        if aDict.keys.contains(data.brand ?? "")
        {
            imgCardIcon.image = aDict[data.brand!]
        }
        
        if data.brand == "American Express"
        {
            lblCardnumber.text = "•••• •••••• \(data.last4 ?? "")"
            
        }
        else
        {
            lblCardnumber.text = "•••• •••• •••• \(data.last4 ?? "")"
            
        }
        
        lblCardName.text = data.brand?.uppercased()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func btnDeleteCellTapped(_ sender: UIButton) {
        if self.buttonDeleteClicked != nil {
            self.buttonDeleteClicked!(sender.tag)
        }
    }
    
}


class CardView: UIView {
    
}
