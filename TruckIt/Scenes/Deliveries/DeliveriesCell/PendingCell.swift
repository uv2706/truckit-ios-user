//
//  PendingCell.swift
//  PickUpUser
//
//  Created by hb on 14/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class PendingCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var dropLocation: UILabel!
    @IBOutlet weak var pickLocation: UILabel!
    @IBOutlet weak var pickTime: UILabel!
    @IBOutlet weak var dropTime: UILabel!
    @IBOutlet weak var lblEstimatedAmount: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    
    static let cellId = "PendingCell"
    
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

    /// Setup pending data in pending cell
    ///
    /// - Parameter data: Deliveries model
    func setUpData(data: Deliveries.ViewModel) {
        dropLocation.text = data.dropOffLocation
        pickLocation.text = data.pickUpLocation

        pickTime.text = GlobalUtility.shared.getFormattedDate(date: data.pickUpAt ?? "0000-00-00 00:00:00")
        dropTime.text = GlobalUtility.shared.getFormattedDate(date: data.dropOffAt ?? "0000-00-00 00:00:00")
        
        lblEstimatedAmount.text = "$\(GlobalUtility.shared.roundOffTextTwoDigit(data.estimatedAmount ?? "0.00"))"
        
        if let count = data.offerCount {
            count == "1" ? (lblOffer.text = "\(count) Offer"):(lblOffer.text = "\(count) Offers")
        }
    }
}
