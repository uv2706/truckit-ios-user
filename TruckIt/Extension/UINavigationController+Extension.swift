//
//  UINavigationController+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        let vc = GlobalUtility.shared.currentTopViewController()
        guard vc != nil else {return .default}
        return .lightContent
    }
}

