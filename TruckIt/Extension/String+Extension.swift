//
//  String+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    /// Check if string is 1,yes,true,on
    ///
    /// - Returns: Returns true if
    func isTrue() -> Bool {
        return ((lowercased() == "1") || (lowercased() == "yes") || (lowercased() == "true") || (lowercased() == "on"))
        //return ((lowercased() != "0") && (self != ""))
    }
    
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
    
    /// Provides substring in range
    ///
    /// - Parameters:
    ///   - start: Start index
    ///   - end: End Index
    /// - Returns: String in the range
    func substring(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        
        return self.substring(with: range)
    }
    
    
    public func addOrUpdateQueryStringParameter( key: String, value: String?) -> String {
        if let components = URLComponents(string: self){
            var aComponents = components
            var queryItems = (components.queryItems ?? [])
            for (index, item) in queryItems.enumerated() {
                // Match query string key and update
                if item.name == key {
                    if let v = value {
                        queryItems[index] = URLQueryItem(name: key, value: v)
                    } else {
                        queryItems.remove(at: index)
                    }
                    aComponents.queryItems = queryItems.count > 0
                        ? queryItems : nil
                    return aComponents.string!
                }
            }
            
            // Key doesn't exist if reaches here
            if let v = value {
                // Add key to URL query string
                queryItems.append(URLQueryItem(name: key, value: v))
                aComponents.queryItems = queryItems
                return aComponents.string!
            }
        }
        
        return self
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    var isValidMobile: Bool {
        return (self as! NSString).length > 13
    }
    
    var isValidName: Bool {
        let emailRegEx = "^(?=.*[A-Z])(?=.*[a-z]).{8,15}$"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,15}$")
        return passwordPred.evaluate(with: self)
    }
    
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /// To calculate Height of the string
    ///
    /// - Parameters:
    ///   - width: Width of the UIView where text needs to be fit in
    ///   - font: Fonts of the string
    /// - Returns: Returns the height that will be occupied by the string
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// To calculate Height of the string
    ///
    /// - Parameters:
    ///   - width: Width of the UIView where text needs to be fit in
    ///   - font: Fonts of the string
    /// - Returns: Returns the height that will be occupied by the string
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
