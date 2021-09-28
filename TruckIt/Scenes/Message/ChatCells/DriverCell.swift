//
//  ClaimTrackCell.swift
//  PatientData
//
//  Created by hb on 08/04/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class DriverCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewBg: UIView!
    static var cellId = "DriverCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewBg.layoutIfNeeded()
        self.viewBg.roundCorners(corners: [.topRight, .bottomRight, .bottomLeft], radius: 15)
    }
    
//    func setData(data: Chat.ViewModel) {
//        lblDate.text = data.messageTime
//        lblDescription.text = data.message
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
