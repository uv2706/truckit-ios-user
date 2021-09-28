//
//  UIPageViewController+Extension.swift
//  PickUpUser
//
//  Created by hb on 31/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = false
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}
