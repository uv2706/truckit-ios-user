//
//  Range+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}

