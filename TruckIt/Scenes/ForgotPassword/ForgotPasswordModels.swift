//
//  ForgotPasswordModels.swift
//  Udecide
//
//  Created by hb on 11/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ForgotPassword {
    struct Request {
        var mobile: String
    }
    
    class ViewModel: WSResponseData {
        var otp : String?
        var resetKey: String?
        
        enum CodingKeys: String, CodingKey {
            case otp
            case reset_key
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            otp = try values.decodeIfPresent(String.self, forKey: .otp)
            resetKey = try values.decodeIfPresent(String.self, forKey: .reset_key)
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(otp, forKey: .otp)
            try container.encode(resetKey, forKey: .reset_key)
        }
    }
}