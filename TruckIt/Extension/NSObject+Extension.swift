//
//  NSObject+Extension.swift
//  My Home Hub
//
//  Created by hb on 19/12/18.
//  Copyright © 2018 Hidden Brains. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    
    /// Get Json String from any Object
    ///
    /// - Parameter object: Object to be converted in to json string
    /// - Returns: Returns json string
    func json() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
