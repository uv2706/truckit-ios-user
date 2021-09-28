//
//  CustomTExtField.swift
//  TruckIt
//
//  Created by hb on 14/08/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

/// Maxlength property for textfield
private var kAssociationTextFieldKeyMaxLength: Int = 0


/// Custom Textfield to define properties
@IBDesignable class CustomTextField: UITextField {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.borderStyle = .roundedRect
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",attributes: [NSAttributedString.Key.foregroundColor: AppConstants.placeholderColor])
    }
    
    ///Provides left padding for images
    ///
    /// - Parameter bounds: Bounds for padding
    /// - Returns: returns rect area
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        var apadding : CGFloat = 0.0
        if #available(iOS 13.0, *) {
             apadding = leftPadding
        } else {
            apadding = 0.0
        }
        
        
        textRect.origin.x += apadding
        return textRect
    }
    
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        var apadding : CGFloat = 0.0
        if #available(iOS 13.0, *) {
             apadding = rightPadding
        } else {
            apadding = 0.0
        }
        

        textRect.origin.x += -1 * apadding
        return textRect
    }
    
    
    /// Sets corner radius for textfield
    @IBInspectable  var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
        
            layer.cornerRadius = 5

        }
    }
    
    /// Set Max Length
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationTextFieldKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationTextFieldKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    /// Check max length
    ///
    /// - Parameter textField: Textfield object
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text, prospectiveText.count > maxLength else
        {
            return
        }
        let selection = selectedTextRange
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
        
    /// Left image for textfield
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    /// Set left padding for textfield
    @IBInspectable var leftPadding: CGFloat = 0
     @IBInspectable var rightPadding: CGFloat = 0
    
    /// Set text color
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    override var placeholder: String?{
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",attributes: [NSAttributedString.Key.foregroundColor: AppConstants.placeholderColor])
        }
    }
    
    
    /// Update View
    func updateView() {
        if let _ = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            view.backgroundColor = nil
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = image
//            imageView.tintColor = color
//            view.addSubview(imageView)
            leftView = view
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
       
    }
    
    
}



