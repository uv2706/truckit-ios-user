

//
//  NSAttributedString.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit


extension NSAttributedString {
    /// Get Height of the Attributed String
    ///
    /// - Parameter width: Width of the View in which String needs to be displayed
    /// - Returns: Returns the Height of the Attributed String
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let aRect = self.boundingRect(with: constraintRect, options:.usesLineFragmentOrigin , context: nil)
        return ceil(aRect.height)
    }
    
}




