//
//  PastCell.swift
//  PickUpUser
//
//  Created by hb on 14/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class PastCell: UITableViewCell {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    static let cellId = "PastCell"
    static let cellCancelId = "PastCancelledCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.viewBg.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewBg.layoutIfNeeded()
        self.viewBg.addCircularShadow(5.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Set past data in cell
    ///
    /// - Parameter data: deliveries model
    func setUpData(data: Deliveries.ViewModel) {
        
        
        
        if let _ = imgUser
        {
            if let profile = data.driverProfile {
                imgUser.setImage(with: profile, placeHolder: #imageLiteral(resourceName: "user_s_14_view_driver"), completed: nil)
            } else {
                imgUser.image = #imageLiteral(resourceName: "sign_up_user")
            }
        }
        
        
        if data.offeramount?.count ?? 0 > 0 , let _ = lblAmount {
            lblAmount.text = "$\(GlobalUtility.shared.roundOffTextTwoDigit(data.offeramount ?? "0.00"))"
            lblAmount.textColor = #colorLiteral(red: 0, green: 0.4877254367, blue: 1, alpha: 1)
        }
        
       
        
        
        if let status = data.pickUpStatus, status == "Cancelled" {
            lblStatus.text = "Cancelled"
            lblStatus.textColor = #colorLiteral(red: 0.6823529412, green: 0.02745098039, blue: 0.1529411765, alpha: 1)
        } else if let status = data.pickUpStatus, status == "Delivered" {
            lblStatus.text = "Delivered"
            lblStatus.textColor = #colorLiteral(red: 0, green: 0.4877254367, blue: 1, alpha: 1)
        }
        
        if let _ = lblName
        {
            lblName.text = data.driverName
        }
        
        lblDescription.text = data.pickUpLocation
        lblDropLocation.text = data.dropOffLocation
    }
}
