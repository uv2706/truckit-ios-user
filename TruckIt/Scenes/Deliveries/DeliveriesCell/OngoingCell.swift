//
//  OngoingCell.swift
//  PickUpUser
//
//  Created by hb on 14/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class OngoingCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var dropOffLocation: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblImage: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    static let cellId = "OngoingCell"
    
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

    /// Setup ongoing data in cell
    ///
    /// - Parameter data: Deliveries model
    func setUpData(data: Deliveries.ViewModel) {
        if let profile = data.driverProfile {
          lblImage.setImage(with: profile, placeHolder: #imageLiteral(resourceName: "user_s_14_view_driver"), completed: nil)
        } else {
            lblImage.image = #imageLiteral(resourceName: "sign_up_user")
        }
        
        if data.pickUpStatus?.lowercased() == "PickedUp".lowercased() {
            lblStatus.text = "Picked Up"
        } else {
            lblStatus.text = data.pickUpStatus
        }
        
        lblName.text = data.driverName
        lblAmount.text = "$\(GlobalUtility.shared.roundOffTextTwoDigit(data.offeramount ?? "0.00"))"
        lblLocation.text = data.pickUpLocation
        dropOffLocation.text = data.dropOffLocation
    }
    
}
