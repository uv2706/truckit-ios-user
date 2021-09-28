//
//  UserCell.swift
//  PatientData
//
//  Created by hb on 08/04/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lblDescriptiom: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblDate: UILabel!
    static let cellId = "UserCell"
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewBg.layoutIfNeeded()
        self.viewBg.roundCorners(corners: [.topLeft, .bottomRight, .bottomLeft], radius: 15)
    }

//    func setData(data: Chat.ViewModel) {
//        lblDate.text = data.message_time_mobile
//        lblDescriptiom.text = data.message
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
