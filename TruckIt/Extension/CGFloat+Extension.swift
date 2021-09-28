//
//  CGFloat+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    public static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func scale(_ scale: CGFloat, delta originDelta: CGFloat = 4, roundingRule: FloatingPointRoundingRule? = nil) -> CGFloat {
        let delta: CGFloat = scale >= 1.0 ? originDelta : self >= originDelta ? originDelta : self
        let base = self - delta
        let result = base + scale * delta
        if let rule = roundingRule {
            return result.rounded(rule)
        }
        return result
    }
}

