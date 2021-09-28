//
//  UILabel+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    public func addAttributeString(mainString: String, subString: String, subStringFont: UIFont, subStringColor: UIColor) {
        let attributeString = NSMutableAttributedString(string: mainString)
        let attributes = [NSAttributedString.Key.font: subStringFont, NSAttributedString.Key.foregroundColor: subStringColor]
        attributeString.addAttributes(attributes, range: (mainString as NSString).range(of: subString))
        self.attributedText = attributeString
    }
    
    public func addAttributeAgain(mainString: NSAttributedString, subString: String, subStringFont: UIFont, subStringColor: UIColor) {
        let attributeString = NSMutableAttributedString(attributedString: mainString)
        let attributes = [NSAttributedString.Key.font: subStringFont, NSAttributedString.Key.foregroundColor: subStringColor]
        attributeString.addAttributes(attributes, range: (mainString.string as NSString).range(of: subString))
        self.attributedText = attributeString
    }
}

