//
//  NoRecordCell.swift
//  PickUpUser
//
//  Created by hb on 03/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class NoRecordCell: UITableViewCell {

    static var cellId = "NoRecordCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
