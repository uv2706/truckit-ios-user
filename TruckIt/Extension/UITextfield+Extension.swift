//
//  UITextfield+Extension.swift
//  PickUpUser
//
//  Created by hb on 12/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setBorderColor(width: CGFloat = 0.5, color: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRadious: CGFloat = 0.0) {
        self.layer.cornerRadius = CGFloat(cornerRadious)
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.leftView = button
        self.leftViewMode = .always
    }
    
    func setLeftView(image: UIImage, tintColor: UIColor = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: AppConstants.placeholderColor])
        let imgView = UIImageView(frame: CGRect(x: 15, y: 0, width: 40, height: 45))
        imgView.contentMode = .center
        imgView.image = image
        imgView.changePngColorTo(color: tintColor)
        imgView.clipsToBounds = true
        self.leftView = nil
        self.leftView = imgView
        self.leftViewMode = .always
    }

    func setRightView(image: UIImage, tintColor: UIColor = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: AppConstants.placeholderColor])
        let imgView = UIImageView(frame: CGRect(x: (self.frame.size.width - 40), y: 0, width: 40, height: 45))
        imgView.contentMode = .center
        imgView.image = image
        imgView.changePngColorTo(color: tintColor)
        imgView.clipsToBounds = true
        self.rightView = imgView
        self.rightViewMode = .always
    }
    
    func setPlaceholder(color: UIColor = AppConstants.placeholderColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
