//
//  ReviewRattingTableViewCell.swift
//  PickUpDriver
//
//  Created by hb on 02/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class ReviewRattingTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewRatting: SwiftyStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(data: ReviewAndRattings.ViewModel){
        self.lblUserName.text = data.name
        self.lblComment.text = data.review
        imgView.setImage(with: data.profile, placeHolder: #imageLiteral(resourceName: "user_s_14_view_driver"), completed: nil)
        lblTime.text = GlobalUtility.shared.getFormattedDate(date: data.added_at ?? "0000-00-00 00:00:00")
        
        if let rating = data.rating {
            self.viewRatting.value = CGFloat(Float(rating) ?? 0)
        }
    }
}
