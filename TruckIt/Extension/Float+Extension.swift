//
//  Float+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension Float {
    /// To get value as 45.23000 ---> 45.23
    ///
    /// - Returns: String with proper format
    func cleanValue() -> String {
        let intValue = Int(self)
        if self == 0 {return "0"}
        if self / Float (intValue) == 1 { return "\(intValue)" }
        return "\(self)"
    }
}
