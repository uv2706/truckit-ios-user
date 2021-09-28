//
//  DriverRatingCell.swift
//  PickUpUser
//
//  Created by hb on 20/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class DriverRatingCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUSer: UIImageView!
    static let cellId = "DriverRatingCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(data: DriverProfile.ViewModel.DriverReview) {
        self.lblName.text = data.userName
        
        if let profile = data.userProfile {
            self.imgUSer.setImage(with: profile,placeHolder:#imageLiteral(resourceName: "sign_up_user"))
        }  else {
            imgUSer.image = #imageLiteral(resourceName: "sign_up_user")
        }
        
        self.lblDate.text = GlobalUtility.shared.getFormattedDate(date: data.reviewdAt ?? "0000-00-00 00:00:00")
        self.lblDescription.text = data.review
    }
}
