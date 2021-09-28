//
//  CGRect+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    
    /// Width ratio
    static var widthRatio:CGFloat {
        return AppConstants.screenWidth / 320
    }
    
    /// Height Ratio
    static var heightRatio:CGFloat {
        return ((max(AppConstants.screenHeight, 568)) / 568)
    }
}


